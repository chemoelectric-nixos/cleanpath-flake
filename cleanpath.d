//
// Remove empty and duplicate entries from a colon-separated path.
//
// For example: ":a:b:b:::c:a::" --> "a:b:c"
//
//
// Copyright © 2025 Barry Schwartz
//
// This program is free software: you can redistribute it and/or
// modify it under the terms of the GNU General Public License, as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received copies of the GNU General Public License
// along with this program. If not, see
// <https://www.gnu.org/licenses/>.
//

import std.stdio: stdout, stderr;
import std.conv: to;

private const delimiter = ':';

private size_t
skip_chars (string s, size_t i, bool function (char) pred)
{
  auto n = s.length;
  while (i < n && pred (s[i]))
    i++;
  return i;
}

private size_t
skip_delimiters (string s, size_t i)
{
  return skip_chars (s, i, (char c) => c == delimiter);
}

private size_t
skip_nondelimiters (string s, size_t i)
{
  return skip_chars (s, i, (char c) => c != delimiter);
}

private string[]
split_on_delimiters (string s)
{
  auto split = new string[0];
  const n = s.length;
  auto i = skip_delimiters (s, 0);
  while (i < n)
    {
      auto j = skip_nondelimiters (s, i);
      split.length += 1;
      split[split.length - 1] = s[i..j];
      i = skip_delimiters (s, j);
    }
  return split;
}

private string
join_with_delimiters (string[] split, char delim)
{
  string s;
  if (split.length == 0)
    {
      s = "";
    }
  else
    {
      const delim1 = [delim];
      char[] array = to!(char[]) (split[0]);
      foreach (entry; split[1..split.length])
        array = array ~ delim1 ~ to!(char[]) (entry);
      s = to!string (array);
    }
  return s;
}

private string
join_with_delimiters (string[] split)
{
  return join_with_delimiters (split, delimiter);
}

private string[]
delete_duplicates (string[] array)
{
  string[] result = [];
  bool[string] found;
  foreach (entry; array)
    if ((entry in found) is null)
      {
        result ~= entry;
        found[entry] = true;
      }
  return result;
}

private string
clean (string dirty_path)
{
  auto split = split_on_delimiters (dirty_path);
  split = delete_duplicates (split);
  return join_with_delimiters (split);
}

int
main (string[] argv)
{
  int exit_status;
  if (argv.length != 2)
    {
      stderr.write (argv[0]);
      stderr.writeln (": command line error");
      stderr.write ("Usage: ");
      stderr.write (argv[0]);
      stderr.writeln (" PATH");
      stderr.flush ();
      exit_status = 1;
    }
  else
    {
      stdout.write (clean (argv[1]));
      stdout.flush ();
      exit_status = 0;
    }

  return exit_status;
}

// local variables:
// mode: d
// c-basic-offset: 2
// coding: utf-8
// end:
