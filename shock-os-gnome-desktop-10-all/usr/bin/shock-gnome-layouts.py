import argparse
import subprocess
import sys
import gi
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk

# PUT CODE HERE TO GET THE CURRENT LAYOUT AND ACTIVATE THE CORRESPONDING BUTTON

parser = argparse.ArgumentParser(description="Change the GNOME layout")

parser.add_argument("--debug", action="store_true", help="Enable debug mode (print variables)")

args = parser.parse_args()

class MyApp(Gtk.Application):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.connect('activate', self.on_activate)

    def on_activate(self, app):
        # Create a Builder
        builder = Gtk.Builder()
        builder.add_from_file("/usr/share/shock-gnome-layouts/shock-gnome-layouts.ui")

        # Get toggle buttons
        panel_mode_button = builder.get_object("panel_mode_button")
        dock_mode_button = builder.get_object("dock_mode_button")
        vanilla_mode_button = builder.get_object("vanilla_mode_button")

        # Group the buttons
        dock_mode_button.set_group(panel_mode_button)
        vanilla_mode_button.set_group(panel_mode_button)

        def panel_mode_selected(self):
            if panel_mode_button.get_active():
                if args.debug:
                    print("Panel mode selected")
                subprocess.run(['/bin/bash', '/usr/bin/shock-gnome-layouts', 'panel'], capture_output=True)

        def dock_mode_selected(self):
            if dock_mode_button.get_active():
                if args.debug:
                    print("Dock mode selected")
                subprocess.run(['/bin/bash', '/usr/bin/shock-gnome-layouts', 'dock'])

        def vanilla_mode_selected(self):
            if vanilla_mode_button.get_active():
                if args.debug:
                    print("Vanilla mode selected")
                subprocess.run(['/bin/bash', '/usr/bin/shock-gnome-layouts', 'vanilla'])

        # Connect the toggled signals of the buttons
        panel_mode_button.connect("toggled", panel_mode_selected)
        dock_mode_button.connect("toggled", dock_mode_selected)
        vanilla_mode_button.connect("toggled", vanilla_mode_selected)

        # Get and show the main window
        self.main_window = builder.get_object("main_window")
        self.main_window.set_application(self) # Application will close once it no longer has active windows
        self.main_window.present()

app = MyApp(application_id="net.ShockOS.GNOMELayouts")
app.run()
