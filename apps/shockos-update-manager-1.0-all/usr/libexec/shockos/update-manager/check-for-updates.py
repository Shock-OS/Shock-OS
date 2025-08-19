#!/usr/bin/env python3

import os
import sys
import atexit
sys.path.append('/usr/lib/shockos/')
import shockos
import gi
import argparse
import subprocess
from pathlib import Path
gi.require_version('Notify', '0.7')
from gi.repository import Gio, GLib, Notify
Notify.init('Update Manager')

class App(Gio.Application):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.connect('activate', self.on_activate)

    def on_activate(self, app):
        updates = subprocess.run(['/usr/libexec/shockos/update-manager/refresh.sh', '--count'], capture_output=True, text=True)
        updates = int(updates.stdout.strip())
        if updates > 0:
            if updates == 1:
                title = 'An Update is Available'
                message = 'There is 1 update available.'
                button_label = 'Install Update'
            else:
                title = 'Updates are Available'
                message = f"There are {updates} updates available."
                button_label = 'Install Updates'
            tmpdir = Path('~/.cache/shockos-tmp/update-manager').expanduser()
            tmpdir.mkdir(parents=True, exist_ok=True)
            self.pidfile = Path('~/.cache/shockos-tmp/update-manager/notfiy-pid').expanduser()
            self.pidfile.write_text(os.getpid())
            self.notification = Notify.Notification.new('Update Manager', message, 'software-update-available')
            self.notification.add_action('button_clicked', button_label, self.button_clicked, None)
            self.notification.set_hint("resident")#, GLib.Variant('b', True))
            self.notification.connect("closed", self.quit)
            self.notification.show()
            atexit.register(self.on_exit)
            self.loop = GLib.MainLoop()
            self.loop.run()

    def button_clicked(self, *args):
        subprocess.Popen(['shockos-update-manager'])
        self.quit()

    def quit(self, *args):
        self.loop.quit()

    def on_exit(self, *args):
        self.notification.close()
        self.pidfile.unlink(missing_ok=True)

app = App(application_id=f"net.shockos.UpdateManager", flags=Gio.ApplicationFlags.NON_UNIQUE)
app.run()
