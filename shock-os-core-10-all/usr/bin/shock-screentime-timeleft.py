import argparse
import multiprocessing
import os
import subprocess
import sys
import gi
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

username = os.getlogin()

parser = argparse.ArgumentParser(description="View remaining screen time.")
parser.add_argument("--debug", action="store_true", help="Run in debug mode (print variables).")
args = parser.parse_args()

class AppWindow(Gtk.Application):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.connect('activate', self.on_activate)

    def on_activate(self, app):
        # Create a Builder
        builder = Gtk.Builder()
        builder.add_from_file("/usr/share/shock-screentime-timeleft/shock-screentime-timeleft.ui")

        # Get label and progess bar
        label = builder.get_object("label")
        progress_bar = builder.get_object("progress_bar")

        def get_remaining_time():
            total_minutes = subprocess.run([f"cat /usr/share/shock-screentime/{username}/dailylimit"], shell=True, capture_output=True, text=True)
            total_minutes = int(total_minutes.stdout)
            date = subprocess.run(["date", "+%F"], capture_output=True, text=True)
            date = date.stdout
            used_minutes = subprocess.run([f"cat /usr/share/shock-screentime/{username}/today-limit/{date}"], shell=True, capture_output=True, text=True)
            used_minutes = int(used_minutes.stdout)
            remaining_minutes = total_minutes - used_minutes
            remaining_minutes_pretty = subprocess.run(["/bin/bash", "/usr/bin/shock-shared-function-pretty-time", str(remaining_minutes)], capture_output=True, text=True)
            remaining_minutes_pretty = remaining_minutes_pretty.stdout
            percentage = remaining_minutes / total_minutes
            progress_bar.set_fraction(percentage)
            progress_bar.set_text(f"{remaining_minutes_pretty} remaining")
            if args.debug:
                print("TOTAL_MINUTES:", total_minutes)
                print("DATE:", date)
                print("USED_MINUTES:", used_minutes)
                print("REMAINING_MINUTES:", remaining_minutes)
                print("REMAINING_MINUTES_PRETTY:", remaining_minutes_pretty)
                print("PERCENTAGE:", percentage)

        class EventHandler(FileSystemEventHandler):
            def on_modified(self, event):
                get_remaining_time()

        path = f"/usr/share/shock-screentime/{username}/today-limit"
        event_handler = EventHandler()
        observer = Observer()
        observer.schedule(event_handler, path, recursive=False)
        observer.start()

        def background_checker():
            observer.join()

        background_process = multiprocessing.Process(target=background_checker)
        background_process.start()

        # Get time limit and set bar text
        time_limit_minutes = subprocess.run([f"cat /usr/share/shock-screentime/{username}/dailylimit"], shell=True, capture_output=True, text=True)
        time_limit_minutes = time_limit_minutes.stdout
        time_limit_pretty = subprocess.run(["/bin/bash", "/usr/bin/shock-shared-function-pretty-time", time_limit_minutes], capture_output=True, text=True)
        time_limit_pretty = time_limit_pretty.stdout
        label.set_text(f"Your parent/guardian/administrator has set a time limit of {time_limit_pretty} on your profile.")
        get_remaining_time()
        if args.debug:
            print("TIME_LIMIT_MINUTES:", time_limit_minutes)
            print("TIME_LIMIT_PRETTY:", time_limit_pretty)
        
        # Get close button
        close_button = builder.get_object("close_button")
        close_button.connect("clicked", self.close)

        # Obtain and show main window
        self.win = builder.get_object("main_window")
        self.win.set_application(self)  # Application will close once it no longer has active windows attached to it
        self.win.present()

    def close(self, app):
        self.win.destroy()

app = AppWindow(application_id="net.ShockOS.Screentime.Timeleft")
app.run()
