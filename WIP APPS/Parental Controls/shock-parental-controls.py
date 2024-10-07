import sys
import gi
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk, Gio
import argparse
import subprocess
import ast

parser = argparse.ArgumentParser(description="Shock OS Parental Controls App")

parser.add_argument("--verbose", "-v", action="store_true", help="Run in verbose mode")

args = parser.parse_args()

class MyApp(Gtk.Application):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.connect('activate', self.on_activate)

    def on_activate(self, app):
        # Create a Builder
        builder = Gtk.Builder()
        builder.add_from_file("shock-parental-controls.ui")

        #### TEMPORARY TESTING ####
        def print_selected_item(button):
            print(self.on_activate.selection_model.get_selected())
        print_selected_item_button = builder.get_object("print_selected_item_button")
        print_selected_item_button.connect("clicked", print_selected_item)
        
        #### TEMPORARY TESTING ####

        user_list = builder.get_object("user_list")

        list_store = Gio.ListStore.new(Gtk.StringObject)

        selection_model = Gtk.SingleSelection.new(list_store)
        user_list.set_model(selection_model)

        factory = Gtk.SignalListItemFactory()

        def bind_list_item(factory, list_item):
            label = Gtk.Label()
            list_item.set_child(label)

        def update_list_item(factory, list_item):
            item = list_item.get_item()
            label = list_item.get_child()
            label.set_text(item.get_string())

        factory.connect("setup", bind_list_item)
        factory.connect("bind", update_list_item)
        
        user_list.set_factory(factory)
        output = subprocess.run(["./shock-parental-controls-get-user-list"], shell=True, capture_output=True, text=True)
        output = output.stdout.strip()
        if not output.startswith("usernames = ['"):
            print("Attempted security exploit detected, exiting...")
            sys.exit()
        local_vars = {}
        exec(output, {}, local_vars)
        self.usernames = local_vars.get('usernames', [])
        self.full_names = local_vars.get('full_names', [])  
        for username in self.usernames:
            list_store.append(Gtk.StringObject.new(username))
        if args.verbose:
            print(f"USERS: {self.usernames}")

        # Obtain and show the main window
        self.win = builder.get_object("main_window")
        self.win.set_application(self)  # Application will close once it no longer has active windows attached to it
        self.win.present()

app = MyApp(application_id="net.ShockOS.ParentalControls")
app.run()

