/* file-reader.vala
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
    public class FileReader : Object {
        public unowned string file_path { get; construct; }

        public FileReader (string file_path) {
            Object (file_path: file_path);
        }

        public string ? read_all_text () {
            File file = File.new_for_path (file_path);
            try {
                StringBuilder result = new StringBuilder ();

                FileInputStream @is = file.read ();
                DataInputStream dis = new DataInputStream (@is);
                string line;

                while ((line = dis.read_line ()) != null) {
                    result.append (line.strip ());
                }

                return result.str;
            } catch (Error e) {
                print ("Error: %s\n", e.message);
                return null;
            }
        }
    }
}