#!/usr/bin/env python3

# This is likely only a temporary library, as its functionality will probably be implemented into /usr/libexec/shockos/pyapt.py in the future.

import argparse
import apt
import apt.debfile
import apt.progress.base
from apt.progress.base import InstallProgress
import apt.progress.text

parser = argparse.ArgumentParser(description='Python DEB package helper script')
parser.add_argument('action', help='Install/remove/reinstall')
parser.add_argument('package', help='File path to .deb package')
parser.add_argument('--percentage', action='store_true', help="Only show percentage")
parser.add_argument('--combine', action='store_true', help='When using --percentage, combine downloading and installing progress into one')
args = parser.parse_args()
action = args.action
package = args.package
percentage = args.percentage
combine = args.combine

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
    print(f"\r{percent:.0f}%", end='\n\r')

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
            apt.progress.base.InstallProgress()
        )

refresh_cache()

deb = apt.debfile.DebPackage(package)

if action == 'install':
    if percentage:
        deb.install(
            AcquirePercentage(),
            InstallPercentage()
        )
    else:
        deb.install(
            apt.progress.text.AcquireProgress(),
            apt.progress.base.InstallProgress()
        )
elif action == 'remove':
    pkg = cache[deb.pkgname]
    if pkg.is_installed:
        pkg.mark_delete()
        commit()
elif action == 'reinstall':
    pkg = cache[deb.pkgname]
    if pkg.is_installed:
        reinstall_step = 1
        pkg.mark_delete()
        commit()
        refresh_cache()
    reinstall_step = 2
    if percentage:
        deb.install(
            AcquirePercentage(),
            InstallPercentage()
        )
    else:
        deb.install(
            apt.progress.text.AcquireProgress(),
            apt.progress.base.InstallProgress()
        )
    commit()
    refresh_cache()
