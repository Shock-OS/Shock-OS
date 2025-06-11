#!/usr/bin/env python3

import os
import sys
sys.path.append('/usr/lib/shockos/')
import shockos
import gi
import argparse
import subprocess
gi.require_version('Notify', '0.7')
from gi.repository import Gio, GLib, Notify
Notify.init('Update Manager')

#parser = argparse.ArgumentParser(description="Check for updates and display a notification if they are available")

#parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose output")

loop = GLib.MainLoop()

#args = parser.parse_args()
#def log(message):
    #if args.verbose:
        #print(message)

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
            #if shockos.deskenv_is_gnome:
                #action = Gio.SimpleAction.new("open-update-manager")
                #action.connect("activate", self.button_clicked)
                #self.add_action(action)
                #notification = Gio.Notification.new(title)
                #notification.set_body(message)
                #notification.set_icon(Gio.ThemedIcon.new('software-update-available'))
                #notification.add_button('Open Update Manager', "app.open-update-manager")
                #self.send_notification(None, notification)
                #GLib.timeout_add_seconds(10, self.quit)
                #loop.run()
                notification = Notify.Notification.new('Update Manager', message, 'software-update-available')
                notification.add_action('button_clicked', button_label, self.button_clicked, None)
                notification.set_hint("resident", GLib.Variant('b', True))
                notification.show()
                GLib.timeout_add_seconds(10, self.quit) # This is janky and needs improving
                loop.run()

    def quit(self):
        loop.quit()

    def button_clicked(self, notification, action, user_data):
        subprocess.Popen(['shockos-update-manager'])

app = App(application_id=f"net.shockos.UpdateManager", flags=Gio.ApplicationFlags.NON_UNIQUE)
app.run()
