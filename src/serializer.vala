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

        public Object ? deserialize (Type object_type, Gee.ArrayList<string> tokens, ref int index) {
            var result = Object.new (object_type);

            while (index < tokens.size) {
                switch (tokens.get (index)) {
                case "{" :
                    result = Object.new (object_type);
                    Serializer serializer = new Serializer ();
                    index++;
                    result = serializer.deserialize (object_type, tokens, ref index);
                    return result;
                case "[":
                    var result_array = new Gee.ArrayList<Object> ();
                    Serializer serializer = new Serializer ();
                    do {
                        index++;
                        var object = serializer.deserialize (object_type, tokens, ref index);
                        result_array.add (object);
                        if (tokens.get (index + 1) == ",") {
                            index++;
                            continue;
                        } else break;
                    } while (tokens.get (index) != "]");
                    return result_array;
                default:
                    string field_name = tokens[index];
                    if (field_name == "}")return result;

                    var class_ref = (ObjectClass) object_type.class_ref ();
                    ParamSpec[] properties = class_ref.list_properties ();

                    foreach (var property in properties) {
                        string regex_pattern = "(?<=\"" + property.get_name () + "\")(\\s*:\\s*\")(.*)(?=\")";
                        string regex_pattern_short = "(?<=\"" + property.get_name ().replace ("-", "_") + "\")(\\s*:\\s*)";
                        try {
                            MatchInfo? match_info;

                            if (new Regex (regex_pattern).match (field_name, 0, out match_info)) {
                                string property_value = match_info.fetch (2);
                                result.set_property (property.get_name (), property_value);
                                break;
                            } else if (new Regex (regex_pattern_short).match (field_name, 0, out match_info)) {
                                Serializer serializer = new Serializer ();
                                index++;
                                Object property_value;
                                if (property.value_type == typeof (Gee.ArrayList)) {
                                    property_value = (Gee.ArrayList) serializer.deserialize (property.owner_type, tokens, ref index);
                                } else {
                                    property_value = serializer.deserialize (property.value_type, tokens, ref index);
                                }
                                result.set_property (property.get_name (), property_value);
                                break;
                            }
                        } catch (RegexError e) {
                            stderr.printf ("Regex error: %s\n", e.message);
                        }
                    }
                    break;
                }
                index++;
            }

            return null;
        }
    }
}