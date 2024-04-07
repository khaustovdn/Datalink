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
        public Window (Gtk.Application app) {
            Object (application: app);
        }

        construct {
            FileReader file_reader = new FileReader ("src/file.txt");
            Tokenizer tokenizer = new Tokenizer ();
            Serializer serializer = new Serializer ();
            var file_text = file_reader.read_all_text ();
            if (file_text == null) return;
            var tokens = tokenizer.tokenize (file_text);
            var serials = (Gee.ArrayList<User>) serializer.deserialize (typeof (User), tokens);
            foreach (var item in serials) {
                print ("login: %s, password: %s, options: %s\n", item.login, item.password, item.option.name);
            }
        }
    }
}