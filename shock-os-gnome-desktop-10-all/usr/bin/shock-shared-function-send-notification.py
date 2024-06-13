import argparse
import notify2
import dbus
import dbus.mainloop.glib
from gi.repository import GLib

def notification_action(bus, message):
    if message.get_member() == "ActionInvoked":
        print("0")
        loop.quit()  # Stop the main loop
    elif message.get_member() == "NotificationClosed":
        print("1")
        loop.quit()  # Stop the main loop

# Create the argument parser
parser = argparse.ArgumentParser(description="SHOCK OS SHARED FUNCTION: SEND NOTIFCATION")

parser.epilog = "This program is used to send a notifcation, and return a '0' if the notification was clicked on, and a '1' if it was closed/dismissed."

# Define the arguments
parser.add_argument('--title', help='Specify the title')
parser.add_argument('--text', help='Specify the text')
parser.add_argument('--icon', help='Specify the icon')
parser.add_argument('--idfile', help='Specify the file to export the notifiction ID to')

# Parse the arguments
args = parser.parse_args()

# Fill empty arguments
if not args.title:
    args.title = "TITLE GOES HERE"

if not args.text:
    args.text = "TEXT GOES HERE"

if not args.icon:
    args.icon = "dialog-information"

# Initialize the D-Bus connection and loop
dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
bus = dbus.SessionBus()
bus.add_match_string_non_blocking("interface='org.freedesktop.Notifications',member='ActionInvoked'")
bus.add_match_string_non_blocking("interface='org.freedesktop.Notifications',member='NotificationClosed'")
bus.add_message_filter(notification_action)

# Initialize the notification system
notify2.init("Example Notification")

# Create a notification
n = notify2.Notification(args.title, args.text, args.icon)
n.add_action("default", "action", lambda n, action: print("0"))
n.show()

if args.idfile:
    notification_id = str(n.id)
    with open(args.idfile, 'w') as file:
        file.write(notification_id)

# Run the main loop to listen for events
loop = GLib.MainLoop()
loop.run()

