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
        public Serializer() {
            Object();
        }

        public Object ? deserialize(Type object_type, Gee.ArrayList<string> tokens) {
            int index = 0;
            return deserialize_field(object_type, tokens, ref index);
        }

        public Object ? deserialize_field(Type object_type, Gee.ArrayList<string> tokens, ref int index) {
            var result = Object.new(object_type);

            while (index < tokens.size) {
                switch (tokens.get(index)) {
                case "{" :
                    return deserialize_object(object_type, tokens, ref index);
                case "[" :
                    return deserialize_array(object_type, tokens, ref index);
                default:
                    if (tokens.get(index) == "}")return result;
                    deserialize_property(object_type, tokens, ref index, ref result);
                    break;
                }
                index++;
            }

            return null;
        }

        private Object deserialize_object(Type object_type, Gee.ArrayList<string> tokens, ref int index) {
            index++;
            Serializer serializer = new Serializer();
            return serializer.deserialize_field(object_type, tokens, ref index);
        }

        private Gee.ArrayList<Object> deserialize_array(Type object_type, Gee.ArrayList<string> tokens, ref int index) {
            index++;
            var serializer = new Serializer();
            var result = new Gee.ArrayList<Object> ();
            do {
                var object = serializer.deserialize_field(object_type, tokens, ref index);
                result.add(object);
                if (tokens.get(index + 1) == ",") {
                    index++;
                    continue;
                }
            } while (tokens.get(index + 1) != "]");
            return result;
        }

        private void deserialize_property(Type object_type, Gee.ArrayList<string> tokens, ref int index, ref Object result) {
            string field_name = tokens.get(index);

            var class_ref = (ObjectClass) object_type.class_ref();
            ParamSpec[] properties = class_ref.list_properties();

            foreach (var property in properties) {
                string regex_pattern = "(?<=\"" + property.get_name() + "\")(\\s*:\\s*\")(.*)(?=\")";
                string regex_pattern_short = "(?<=\"" + property.get_name().replace("-", "_") + "\")(\\s*:\\s*)";
                try {
                    MatchInfo? match_info = null;

                    if (new Regex(regex_pattern).match(field_name, 0, out match_info)) {
                        string property_value = match_info.fetch(2);
                        result.set_property(property.get_name(), property_value);
                        break;
                    } else if (new Regex(regex_pattern_short).match(field_name, 0, out match_info)) {
                        index++;
                        Serializer serializer = new Serializer();
                        var property_value = serializer.deserialize_field(
                            (property.value_type == typeof (Gee.ArrayList))
                                ? property.owner_type
                                : property.value_type,
                            tokens,
                            ref index);
                        result.set_property(property.get_name(), property_value);
                        break;
                    }
                } catch (RegexError e) {
                    stderr.printf("Regex error: %s\n", e.message);
                }
            }
        }
    }
}