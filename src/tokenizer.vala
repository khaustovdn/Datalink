/* tokenizer.vala
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
    public class Tokenizer : Object {
        public Tokenizer() {
            Object();
        }

        public Gee.ArrayList<string> tokenize(string data) {
            Gee.ArrayList<string> result = new Gee.ArrayList<string> ();
            StringBuilder token = new StringBuilder();

            for (var i = 0; i < data.length; i++) {
                if (data.get(i).to_string() in @"{}[],") {
                    if (token.len > 0) {
                        result.add(token.str);
                        token = new StringBuilder();
                    }
                    result.add(data.get(i).to_string());
                } else if (data.get(i) != ' ') {
                    token.append(data.get(i).to_string());
                }
            }

            return result;
        }
    }
}