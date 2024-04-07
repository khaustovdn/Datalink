/* authenticator.vala
 *
 * Copyright 2024 khaustov
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
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
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Datalink {
    [GtkTemplate (ui = "/io/github/Datalink/authenticator.ui")]
    public class Authenticator : Adw.Dialog {
        public Gee.ArrayList<User> users { get; set; }

        [GtkChild]
        private unowned Gtk.Button cancel_button;
        [GtkChild]
        private unowned Gtk.Button apply_button;
        [GtkChild]
        private unowned Adw.EntryRow login_entry_row;
        [GtkChild]
        private unowned Adw.PasswordEntryRow password_entry_row;

        public signal void apply (User user);

        public Authenticator (Gee.ArrayList<User> users) {
            Object (users: users);
        }

        construct {
            cancel_button.clicked.connect (force_close);
            apply_button.clicked.connect (() => {
                string login_text = login_entry_row.get_text ();
                string password_text = password_entry_row.get_text ();
                bool found_user = false;

                foreach (var user in users) {
                    if ((login_text != null && login_text.length > 0) && (password_text != null && password_text.length > 0)) {
                        if (user.login == login_text && user.password == password_text) {
                            apply (user);
                            force_close ();
                            found_user = true;
                            break;
                        }
                    } else {
                        stderr.printf ("Error: Login or password text is empty\n");
                    }
                }
            });
        }
    }
}