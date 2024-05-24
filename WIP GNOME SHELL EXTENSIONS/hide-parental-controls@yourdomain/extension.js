const { Shell, Meta } = imports.gi;
const Main = imports.ui.main;
const Util = imports.misc.util;

class Extension {
    constructor() {
        this._windowAddedId = null;
    }

    enable() {
        this._windowAddedId = global.display.connect('window-created', this._onWindowCreated.bind(this));
    }

    disable() {
        if (this._windowAddedId) {
            global.display.disconnect(this._windowAddedId);
            this._windowAddedId = null;
        }
    }

    _onWindowCreated(display, win) {
        if (!(win instanceof Meta.Window)) {
            return;
        }

        if (win.get_wm_class() === 'gnome-control-center') {
            win.connect('notify::title', () => {
                this._hideParentalControls(win);
            });
        }
    }

    _hideParentalControls(win) {
        const actor = win.get_compositor_private();
        if (!actor) {
            return;
        }

        actor.connect('actor-added', () => {
            let controlCenter = actor.get_children().find(child => child.get_name() === 'GnomeControlCenter');
            if (controlCenter) {
                controlCenter.connect('actor-added', () => {
                    this._searchAndHideParentalControls(controlCenter);
                });
            }
        });
    }

    _searchAndHideParentalControls(container) {
        let usersPanel = container.get_children().find(child => child.get_name && child.get_name().includes('user-accounts'));
        if (usersPanel) {
            usersPanel.connect('actor-added', () => {
                let otherUsersSection = usersPanel.get_children().find(child => child.get_name && child.get_name().includes('other-users-section'));
                if (otherUsersSection) {
                    otherUsersSection.connect('actor-added', () => {
                        let adminToggle = otherUsersSection.get_children().find(child => child.get_name && child.get_name().includes('admin-toggle'));
                        if (adminToggle) {
                            adminToggle.connect('actor-added', () => {
                                let parentalControlsItem = adminToggle.get_children().find(child => child.get_text && child.get_text() === 'Parental Controls');
                                if (parentalControlsItem) {
                                    parentalControlsItem.hide();
                                }
                            });
                        }
                    });
                }
            });
        }
    }
}

function init() {
    return new Extension();
}

