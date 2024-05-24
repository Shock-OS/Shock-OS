const { Gio, Gtk } = imports.gi;
const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

class Extension {
    constructor() {}

    enable() {
        this._injectLayoutSubmenu();
    }

    disable() {
        this._removeLayoutSubmenu();
    }

    _injectLayoutSubmenu() {
        let appSys = Gio.AppInfo.get_all();
        let app = appSys.find(app => app.get_name() === 'gnome-control-center.desktop');
        if (app) {
            let controlCenterPath = app.get_filename();
            let file = Gio.File.new_for_path(controlCenterPath);
            let fileContents = file.load_contents(null)[1];
            let fileContentsStr = fileContents.toString();
            let newContents = fileContentsStr.replace(/(id: 'appearance'.*?submenu:<Menu )/s, `$1id: 'layout', _submenuLayout(), `);
            file.replace_contents(newContents, null, false, Gio.FileCreateFlags.NONE, null);
        }
    }

    _removeLayoutSubmenu() {
        let appSys = Gio.AppInfo.get_all();
        let app = appSys.find(app => app.get_name() === 'gnome-control-center.desktop');
        if (app) {
            let controlCenterPath = app.get_filename();
            let file = Gio.File.new_for_path(controlCenterPath);
            let fileContents = file.load_contents(null)[1];
            let fileContentsStr = fileContents.toString();
            let newContents = fileContentsStr.replace(/(_submenuLayout\(\) \{[\s\S]*?^\}[\s\S]*?})/m, '');
            file.replace_contents(newContents, null, false, Gio.FileCreateFlags.NONE, null);
        }
    }

    _submenuLayout() {
        let section = new Gtk.MenuItem({ label: 'Layout', activate: () => {} });
        let submenu = new Gtk.Menu();

        let panelItem = new Gtk.MenuItem({ label: 'Panel', activate: () => this._handleMenuItemActivated('panel') });
        submenu.append(panelItem);

        let dockItem = new Gtk.MenuItem({ label: 'Dock', activate: () => this._handleMenuItemActivated('dock') });
        submenu.append(dockItem);

        let vanillaItem = new Gtk.MenuItem({ label: 'Vanilla', activate: () => this._handleMenuItemActivated('vanilla') });
        submenu.append(vanillaItem);

        section.set_submenu(submenu);

        return section;
    }

    _handleMenuItemActivated(layout) {
        // Execute your custom command here based on the selected layout
        global.log(`Layout ${layout} selected.`);
    }
}

function init() {
    return new Extension();
}

