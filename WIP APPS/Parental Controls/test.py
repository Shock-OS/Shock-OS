
import gi
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk, Gio

class LocationSelectionDialog(Gtk.Dialog):
    def __init__(self, parent):
        super().__init__(title="Select Location", transient_for=parent, use_header_bar=True)

        # Set the dialog size
        self.set_default_size(600, 400)

        # Create a box to hold the content
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10, margin=20)
        self.get_content_area().append(box)

        # Create a world map placeholder using Gtk.Image
        self.world_map_image = Gtk.Image.new_from_file("world_map.png")
        box.append(self.world_map_image)

        # Create a country selection combo box
        self.country_combo = Gtk.ComboBoxText()
        self.country_combo.set_placeholder_text("Select Country")
        self.load_countries()
        box.append(self.country_combo)

        # Create a timezone selection combo box
        self.timezone_combo = Gtk.ComboBoxText()
        self.timezone_combo.set_placeholder_text("Select Timezone")
        self.load_timezones()
        box.append(self.timezone_combo)

        # Create a button box for OK/Cancel buttons
        button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        ok_button = Gtk.Button(label="OK")
        cancel_button = Gtk.Button(label="Cancel")
        ok_button.connect("clicked", self.on_ok_clicked)
        cancel_button.connect("clicked", self.on_cancel_clicked)
        button_box.append(ok_button)
        button_box.append(cancel_button)
        box.append(button_box)

        self.show()

    def load_countries(self):
        # Populate the country combo box with a list of countries (static example)
        countries = ["United States", "Canada", "Mexico", "United Kingdom", "Germany"]
        for country in countries:
            self.country_combo.append_text(country)

    def load_timezones(self):
        # Populate the timezone combo box with a list of timezones (static example)
        timezones = ["UTC-12:00", "UTC-11:00", "UTC-10:00", "UTC-09:00", "UTC-08:00"]
        for timezone in timezones:
            self.timezone_combo.append_text(timezone)

    def on_ok_clicked(self, widget):
        selected_country = self.country_combo.get_active_text()
        selected_timezone = self.timezone_combo.get_active_text()
        print(f"Selected Country: {selected_country}")
        print(f"Selected Timezone: {selected_timezone}")
        self.close()

    def on_cancel_clicked(self, widget):
        self.close()

# Create a GTK application and show the location selection dialog
class MainWindow(Gtk.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="Location Selection Example")
        self.set_default_size(200, 200)

        # Button to show the location selection dialog
        button = Gtk.Button(label="Select Location")
        button.connect("clicked", self.show_location_dialog)
        self.set_child(button)

    def show_location_dialog(self, widget):
        dialog = LocationSelectionDialog(self)
        dialog.present()

# Main Application class
class LocationApp(Gtk.Application):
    def __init__(self):
        super().__init__(application_id="com.example.locationapp")
    
    def do_activate(self):
        window = MainWindow(self)
        window.present()

# Run the application
app = LocationApp()
app.run()
