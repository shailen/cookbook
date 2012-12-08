Concatentating strings using a `+` works in a lot of languages, but not in Dart.
The following code throws a `NoSuchMethodError`:

MERGE(concatenating_strings_usePlusOperator)
     
So, how _do_ you concatenate strings in Dart? The easiest, most efficient way
is by using adjacent string literals:

MERGE(concatenating_strings_useAdjacentStringLiterals)

This still works if the adjacent strings are on different lines:

MERGE(concatenating_strings_useAdjacentStringLiteralsOnDifferentLines)

Dart also has a `StringBuffer` class; this can be used to build up a
`StringBuffer` object and convert it to a string by calling `toString()`
on it:

MERGE(concatenating_strings_useStringBuffer)
    
The `Strings` class (notice the plural) gives us 2 methods, `join()` and
`concatAll()` that can also be used. `Strings.join()` takes a delimiter as a
second argument.

MERGE(concatenating_strings_useJoin)
MERGE(concatenating_strings_useConcatAll)

All of the above work, but if you are looking for a `+` substitute, use
adjacent string literals; if you need to join a list of strings using a
delimiter, use `Strings.join()`. If you plan on building a very long string,
use `StringBuffer` to gather the components and convert them to a string
only when needed. 

You can also use string interpolation; that is the subject of different
recipe.
