<!DOCTYPE html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
  <title>Dart Cookbook</title>
  <link rel="stylesheet"
  href="http://1-ps.googleusercontent.com/x/s.dart-lang.appspot.com/www.dartlang.org/css/W.style.css.pagespeed.cf.RjqwNm2LxS.css"
  />
  <style type="text/css">
    body {margin-left:20px;}
  </style>
</head>
<body>

# Dart Cookbook

## Contents

- [Introduction](#introduction)
- [Strings](#strings)
    - [Concatenating Strings](#concatenating_strings)
    - [Interpolating Expressions Inside Strings](#interpolating_expressions_inside_strings)
    - [Converting Between Character Codes and Strings](#converting_between_character_codes_and_strings)
- [Testing](#testing)
    - [Running Only a Single Test](#running_only_a_single_test)

## Introduction

## Strings

### <a id="concatenating_strings"></a>Concatenating Strings

#### Problem
String concatenation using a `+` works in a lot of languages, but not in Dart.
Since the `+` operator has not been defined for stings, the following code
throws a `NoSuchMethodError`:

MERGE(concatenating_strings_usePlusOperator)
     
So, how _do_ you concatenate strings in Dart?

#### Solution
The easiest, most efficient way is by using adjacent string literals:

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

### <a id="interpolating_expressions_inside_strings"></a>Interpolating Expressions Inside Strings

#### Problem
You want to use identifiers and Dart expressions in Strings.

#### Solution

You can access the value of an expression inside a string by using `${expression}`.

MERGE(string_interpolation_simple_interpolation)
  
If the expression is an identifier, the `{}` can be skipped.

MERGE(string_interpolation_simple_interpolation_without_curlies)
  
If the variable inside the `{}` isn't a string, the variable's
`toString()` method is called:

MERGE(string_interpolation_calling_toString_on_int)

The call to `toString()` is unnecessary (although harmless) in this case:
`toString()` is already defined for ints and Dart automatically calls
`toString()`. What this does mean, though, is that it is the user's
responsibility to define a `toString()` method when interpolating
user-defined objects.

This will not work as expected:

MERGE(string_interpolation_class_book)
MERGE(string_interpolation_without_toString)

But this will:

MERGE(string_interpolation_class_song)  
MERGE(string_interpolation_with_toString)

You can interpolate expressions of arbitrary complexity by placing them inside
`${}`:

A ternary `if..else`:

MERGE(string_interpolation_use_ternary_if_else)
  
List and Map operations:

MERGE(string_interpolation_list_and_map_operations)

Notice above that you can access `$list`(an identifier) without using `{}`,
but the call to `list.map`(an expression) needs to be inside `{}`. 

Expressions inside `${}` can be arbitrarily complex:

MERGE(string_interpolation_interpolate_self_calling_function)

The code above defines an anonymous function to pick a random name from a
list and then calls that function with `names` as an argument. All of
this is done as part of string interpolation.

Creating a function and immediately calling it is useful in a lot of
situations (it is a common practice in Javascript); but, watch out: 
doing this sort of thing can lead to hard to maintain code. An abudance
of caution is advised ;) 


### <a id="converting_between_character_codes_and_strings"></a>Converting Between Character Codes and Strings

#### Problem
You want to get the ascii character codes for a string, or to get the
string corresponding to ascii codes.

#### Solution

To get a list of character codes for a string, use `charCodes`:

MERGE(character_codes_use_charCodes)
  
To get a specific character code, you can either subscript `charCodes`, or 
use `charCodeAt`:

MERGE(character_codes_use_charCodeAt)
  
To assemble a string from a list of character codes, use the `String` factory,
`fromCharCodes`:

MERGE(character_codes_use_fromCharCodes)

  
If you are using a StringBuffer to build up a string, you can add individual
charCodes using `addCharCode` (use `add()` to add characters; use `addCharCode()`
to add charCodes):

MERGE(character_codes_use_StringBuffer)

Here is an implementation of the `rot13` algorithm, using the tools described above.
`rot13` is a simple letter substitution algorithm that rotates a string by 13
places by replacing each character in it by one that is 13 characters removed
('a' becomes 'n', 'N' becomes 'A', etc.):

MERGE(character_codes_rot13)

Running the code:
 
MERGE(character_codes_use_rot13)

and:

MERGE(character_codes_use_rot13_with_non_alpha)

## Testing

### <a id="running_only_a_single_test"></a>Running Only a Single Test

pubspec dependencies: _unittest, args_

#### Problem
You are coding away furiously and diligently writing tests for everything. But,
running all your tests takes time and you want to run just a single test,
perhaps the one for the code you are working on.

#### Solution
The easiest way to do this is to convert a `test()`s to a `solo_test()`:

MERGE(solo_test_code)

Run the tests now and you'll see that only the `solo_test()` runs; the `test()`
does not.

MERGE(solo_test_output)

You can also run a single test by passing the `id` of that test
to `setSoloTest()` (see `unittest/src/unittest.dart`), perhaps as a command-line
arg.

Since the default `unittest` ouput does not include the test `id`, you
need to extend the default Configuration class (see unittest/src/config.dart):

MERGE(setsolotest_extend_configuration)

Our custom configuration is pretty minimal: we modify the default
`Configuration`'s `onDone()` to include the test `id` on every line (`onDone()`
also outputs a summary of the entire test run; we skip that here).

Now we need code to use our new configuration and to initialize the test
framework (we put code for that in `useSingleTestConfiguration()` and call that function
from `main()`):

MERGE(setsolotest_use_configuration)

We use `ArgParser` to parse the command line arguments: if an id is provided
through the command line, only the test with that id runs:

MERGE(setsolotest_output_with_arg)

if no id is provided, all the tests run:
  
MERGE(setsolotest_output_without_arg)

Here is the complete example:

MERGE(setsolotest_complete_example)

</body>
</html>
