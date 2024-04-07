/* window.vala
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
    [GtkTemplate (ui = "/io/github/Datalink/window.ui")]
    public class Window : Adw.ApplicationWindow {
        private User user { get; set; }

        [GtkChild]
        public unowned Adw.HeaderBar header_bar;
        [GtkChild]
        public unowned Gtk.Button authentication_button;
        [GtkChild]
        public unowned Gtk.MenuButton options_menu;

        public unowned Menu options_menu_model;

        public Window (Gtk.Application app) {
            Object (application: app);
        }

        construct {
            FileReader file_reader = new FileReader ("src/file.txt");
            Tokenizer tokenizer = new Tokenizer ();
            Serializer serializer = new Serializer ();
            var file_text = file_reader.read_all_text ();
            if (file_text != null) {
                var tokens = tokenizer.tokenize (file_text);
                var users = (Gee.ArrayList<User>) serializer.deserialize (typeof (User), tokens);
                authentication_button.clicked.connect(() => {
                    var authenticator = new Authenticator(users);
                    authenticator.present(this);
                });
            }
        }
    }
}