import ast
import sys
import gi
import metadata
import subprocess
import argparse
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk

parser = argparse.ArgumentParser(description='Shock OS Imager: Install Shock OS onto SD cards and USB drives.')

parser.add_argument('--debug', action='store_true', help='Launch the software in debug mode')

args = parser.parse_args()

if args.debug:
    print("VERSIONS: ", metadata.versions)

class MyApp(Gtk.Application):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.connect('activate', self.on_activate)
            
    

    def on_activate(self, app):
        # Create a Builder
        builder = Gtk.Builder()
        builder.add_from_file("imager.ui")

        # Get Error Message dialog window
        error_no_drive = builder.get_object('error_no_drive')
        def close_error_no_drive(self, combo):
            error_no_drive.hide()
        error_no_drive.connect("response", close_error_no_drive)
        
        # Get the combo boxes
        self.version_cb = builder.get_object("version_cb")
        self.edition_cb = builder.get_object("edition_cb")
        self.arch_cb = builder.get_object("arch_cb")
        self.device_cb = builder.get_object("device_cb")
        
        # Get the buttons
        self.settings_button = builder.get_object("settings_button")
        self.refresh_button = builder.get_object("refresh_button")
        self.flash_button = builder.get_object("flash_button")
        
        # Define button actions
        def settings_button_clicked(self):
            if args.debug:
                print("Settings Button Clicked")
        
        def refresh_devices(self):
            if args.debug:
                print("Refreshing device list...")
            current_device = app.device_cb.get_active_text()
            if current_device is None:
                current_device = ""
            lsblk_cmd_out = subprocess.run(['/bin/bash', 'shock-os-imager-get-drives.sh'], capture_output=True, text=True)
            devices = ast.literal_eval(lsblk_cmd_out.stdout)          
            if args.debug:
                print("DEVICES:", *devices)
                if devices:
                    print("DEVICES[0]:", devices[0])
            app.device_cb.remove_all()
            for device in devices:
                app.device_cb.append_text(device)
            if current_device in devices:
                counter = 0
                for device in devices:
                    if device == current_device:
                        break
                    else:
                        counter += 1
                app.device_cb.set_active(counter)
            else:
                app.device_cb.set_active(0)

        refresh_devices(self)
                
        
        def flash_button_clicked(self):
            if args.debug:
                print("Flash Button Clicked")
            version = app.version_cb.get_active_text()
            edition = app.edition_cb.get_active_text()
            arch = app.arch_cb.get_active_text()
            device = app.device_cb.get_active_text()
            if device is None:
                error_no_drive.show()
                if args.debug:
                    print("ERROR: Please select a device")
            else:
                app.quit()
                if args.debug:
                    print(version,edition,arch,sep="_")
        
        self.settings_button.connect("clicked", settings_button_clicked)
        self.refresh_button.connect("clicked", refresh_devices)
        self.flash_button.connect("clicked", flash_button_clicked)
        
        # Set up Version combo box
        for version in metadata.versions:
            self.version_cb.append_text(version)
        
        # Connect signals
        self.version_cb.connect("changed", self.on_version_changed)

        # Obtain and show the main window
        self.version_cb.set_active(0)
        self.edition_cb.set_active(0)
        self.arch_cb.set_active(0)
        self.device_cb.set_active(0)
        self.win = builder.get_object("main_window")
        self.win.set_application(self)  # Application will close once it no longer has active windows attached to it
        self.win.present()
        
    def on_version_changed(self, combo):
        # Get current version, edition, and arch variables
        version = self.version_cb.get_active_text()
        edition = self.edition_cb.get_active_text()
        arch = self.arch_cb.get_active_text()
        device = self.device_cb.get_active_text()


        if args.debug:
            print("VERSION:", version)
            print("EDITION:", edition)
            print("ARCH:", arch)
            print("DEVICE:", device)
        
        #Populate Edition combo box
        self.edition_cb.remove_all()
        for item in metadata.editions[version]:
            self.edition_cb.append_text(item)
        if edition in metadata.editions[version]:
            counter = 0
            for item in metadata.editions[version]:
                if item == edition:
                    break
                else:
                    counter += 1
            self.edition_cb.set_active(counter)
        else:
            self.edition_cb.set_active(0)
        
        #Populate Architecture combo box
        self.arch_cb.remove_all()
        for item in metadata.arches[version]:
            self.arch_cb.append_text(item)
        if arch in metadata.arches[version]:
            counter = 0
            for item in metadata.arches[version]:
                if item == arch:
                    break
                else:
                    counter += 1
            self.arch_cb.set_active(counter)
        else:
            self.arch_cb.set_active(0)

app = MyApp(application_id="net.ShockOS.Imager")
app.run()

