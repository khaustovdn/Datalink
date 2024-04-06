/* serializer.vala
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
    public class Serializer : Object {
        public Serializer () {
            Object ();
        }

        public Object deserialize (Type object_type, Gee.ArrayList<string> tokens, int index = 0) {
            var result = Object.new (object_type);
            int type = ((result as Gee.ArrayList<Object>) != null) ? 1 : 0;

            while (index < tokens.size) {
                switch (tokens.get (index)) {
                case "{":
                    Serializer serializer = new Serializer ();
                    var object = serializer.deserialize (object_type, tokens, index + 1);
                    return object;
                default:
                    switch (type) {
                    case 0:
                        string field_name = tokens[index];

                        var class_ref = (ObjectClass) object_type.class_ref ();
                        ParamSpec[] properties = class_ref.list_properties ();

                        foreach (var property in properties) {
                            string regex_pattern = "(?<=" + property.get_name () + ")(\\s*:\\s*\")(.*)(?=\")";
                            try {
                                MatchInfo? match_info;

                                if (new Regex (regex_pattern).match (field_name, 0, out match_info)) {
                                    string property_value = match_info.fetch (2);
                                    result.set_property (property.get_name (), property_value);
                                    break;
                                }
                            } catch (RegexError e) {
                                stderr.printf ("Regex error: %s\n", e.message);
                            }
                        }

                        break;
                    case 1 :
                        break;
                    }
                    break;
                }
                index++;
            }

            return result;
        }
    }
}