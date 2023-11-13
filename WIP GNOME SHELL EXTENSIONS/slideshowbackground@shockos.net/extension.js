/* extension.js
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

/* exported init */

const { GObject, Gtk, Gio, Shell } = imports.gi;

var SlideshowSettings = class SlideshowSettings {
  constructor() {
    this.init();
  }

  init() {
    // Load settings
    this.settings = new Gio.Settings({ schema: 'org.gnome.shell.extensions.slideshowbackground' });

    // Create UI
    this.buildUI();
  }

  buildUI() {
    // Create a new Gtk.Box
    this.mainBox = new Gtk.Box({
      orientation: Gtk.Orientation.VERTICAL,
      margin: 10,
      spacing: 5,
    });

    // Toggle switch for slideshow
    this.playSlideshowSwitch = new Gtk.Switch();
    this.playSlideshowSwitch.connect('notify::active', () => {
      this.settings.set_boolean('play-slideshow', this.playSlideshowSwitch.active);
      this.updateWidgets();
    });

    // Directory file selection
    this.directoryChooser = new Gtk.FileChooserButton({
      title: 'Select Slideshow Directory',
      action: Gtk.FileChooserAction.SELECT_FOLDER,
    });
    this.directoryChooser.connect('file-set', () => {
      this.settings.set_string('slideshow-directory', this.directoryChooser.get_uri());
    });

    // Number input for delay
    this.delayInput = new Gtk.SpinButton({
      adjustment: new Gtk.Adjustment({
        lower: 1,
        upper: 60,
        step_increment: 1,
      }),
    });
    this.delayInput.connect('value-changed', () => {
      this.settings.set_int('slideshow-delay', this.delayInput.get_value());
    });

    // Toggle switch for shuffle
    this.shuffleSwitch = new Gtk.Switch();
    this.shuffleSwitch.connect('notify::active', () => {
      this.settings.set_boolean('shuffle-images', this.shuffleSwitch.active);
    });

    // Add widgets to the main box
    this.mainBox.add(new Gtk.Label({ label: 'Play background as slideshow' }));
    this.mainBox.add(this.playSlideshowSwitch);
    this.mainBox.add(new Gtk.Label({ label: 'Slideshow Directory' }));
    this.mainBox.add(this.directoryChooser);
    this.mainBox.add(new Gtk.Label({ label: 'Delay' }));
    this.mainBox.add(this.delayInput);
    this.mainBox.add(new Gtk.Label({ label: 'Shuffle images in random order' }));
    this.mainBox.add(this.shuffleSwitch);

    // Add main box to the appearance panel
    let appearanceSection = this.createAppearanceSection();
    appearanceSection.add(this.mainBox);
  }

  createAppearanceSection() {
    // Get the appearance section from GNOME settings
    let appearanceSettings = new Gio.Settings({ schema: 'org.gnome.desktop.background' });
    let appearanceSection = new Shell.GenericContainer({
      style_class: 'appearance',
      reactive: true,
    });
    appearanceSection.set_reactive(true);
    appearanceSettings.connect('changed', () => {
      appearanceSection.set_reactive(true);
    });

    return appearanceSection;
  }

  updateWidgets() {
    // Update widget states based on the 'play-slideshow' setting
    let slideshowEnabled = this.settings.get_boolean('play-slideshow');
    this.directoryChooser.sensitive = slideshowEnabled;
    this.delayInput.sensitive = slideshowEnabled;
    this.shuffleSwitch.sensitive = slideshowEnabled;
  }
};

var init = function () {
  return new SlideshowSettings();
};

