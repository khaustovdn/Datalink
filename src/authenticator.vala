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

        public Authenticator (Gee.ArrayList<User> users) {
            Object (users: users);
        }

        construct {
            cancel_button.clicked.connect (force_close);
        }
    }
}