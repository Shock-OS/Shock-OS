#!/usr/bin/env python3

import argparse
import apt
import apt.debfile
import apt.progress.base
from apt.progress.base import InstallProgress
import apt.progress.text

parser = argparse.ArgumentParser(description='Python APT helper script')
parser.add_argument('action', help='Install/remove/reinstall/update/upgrade')
parser.add_argument('package', nargs='?', help='Package name')
parser.add_argument('--percentage', action='store_true', help="Only show percentage")
parser.add_argument('--combine', action='store_true', help='When using --percentage, combine downloading and installing progress into one')
parser.add_argument('--yad-percentage', action='store_true', help='When using --percentage, also output #[PERCENTAGE]% for legacy YAD dialogs')
args = parser.parse_args()
action = args.action
package = args.package
percentage = args.percentage
combine = args.combine
yad_percentage = args.yad_percentage

if package is None and not (action == 'update' or action == 'upgrade'):
    raise ValueError(f"Must supply package name or path with action '{action}'")

cache = apt.Cache()

def refresh_cache():
    cache.update()
    cache.open()

def display_percentage(percent, step):
    if combine:
        if step == 'acquire':
            percent = percent / 2
        else:
            percent = (percent / 2) + 50
        if action == 'reinstall':
            if reinstall_step == 1:
                percent = percent / 2
            else:
                percent = (percent /2) + 50
    print(f"\r{percent:.0f}%", end='\n\r', flush=True)
    if yad_percentage:
        print(f"\r#{percent:.0f}%", end='\n\r', flush=True)

class AcquirePercentage(apt.progress.text.AcquireProgress):
    def __init__(self):
        super().__init__()
        self.last_percent = -1

    def fetch(self, item):
        # Called for each item being downloaded
        super().fetch(item)
        self._print_percent()

    def pulse(self, owner=None):
        # Still required to return True so downloads continue
        return True

    def _print_percent(self):
        if self.total_bytes:
            percent = (self.current_bytes / self.total_bytes) * 100
            if int(percent) != int(self.last_percent):
                display_percentage(percent, 'acquire')
                self.last_percent = percent

    def done(self, *args, **kwargs):
        self._print_percent()
        print("")  # Ensure newline after download is complete

class InstallPercentage(InstallProgress):
    def status_change(self, pkg, percent, status):
        display_percentage(percent, 'install')

def commit():
    if percentage:
        cache.commit(
            AcquirePercentage(),
            InstallPercentage()
        )
    else:
        cache.commit(
            apt.progress.text.AcquireProgress(),
            apt.progress.text.InstallProgress()
        )

refresh_cache()

if package:
        pkg = cache[package]

if action == 'install' and not pkg.is_installed:
    pkg.mark_install()
    commit()
elif action == 'remove' and pkg.is_installed:
    pkg.mark_delete()
    commit()
elif action == 'reinstall':
    if pkg.is_installed:
        reinstall_step = 1
        pkg.mark_delete()
        commit()
        refresh_cache()
    reinstall_step = 2
    pkg.mark_install()
    commit()
    refresh_cache()
elif action == 'update':
    refresh_cache()
elif action == 'upgrade':
    cache.upgrade()
    commit()
