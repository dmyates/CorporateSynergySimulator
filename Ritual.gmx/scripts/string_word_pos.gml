///string_word_pos(word_index, string)
// Returns the nth word in the string (words counted from 0).

var pos, str;

pos = 0;
n = argument0
str = argument1

repeat(n)
{
    pos += string_pos(" ", str)
    str = string_copy(str, pos+1, string_length(str)-pos)
}

if pos == 0
   pos = 1

return pos
