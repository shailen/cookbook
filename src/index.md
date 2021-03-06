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

# Contents

- [Introduction](#introduction)
- [Strings](#strings)
    - [Concatenating strings](#concatenating_strings)
    - [Interpolating expressions inside strings](#interpolating_expressions_inside_strings)
    - [Converting between character codes and strings](#converting_between_character_codes_and_strings)
- [Testing](#testing)
    - [Running only a single test](#running_only_a_single_test)
    - [Filtering which tests are run](#filtering_which_tests_are_run)
- [HTML5](#html5)
    - [Geolocation](#geolocation)

# Introduction

# Strings

### <a id="concatenating_strings"></a>Concatenating strings

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

### <a id="interpolating_expressions_inside_strings"></a>Interpolating expressions inside strings

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


### <a id="converting_between_character_codes_and_strings"></a>Converting between character codes and strings

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

# Testing

### <a id="running_only_a_single_test"></a>Running only a single test

**pubspec dependencies**: _unittest, args_

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

### <a id="filtering_which_tests_are_run"></a>Filtering which tests are run
**pubspec dependencies**: _unittest, args_

#### Problem
You want to run just a subset of your tests, perhaps those  whose description
contains a word or a phrase, or that are collected together in a `group()`.

#### Solution

Use `filterTests()` with with a String or a RegExp argument; if a test's
description matches the argument, the test runs, otherwise, it doesn't. 

Before you use `filterTests()`, you need to disable the automatic running of
tests (create and use a simple custom configuration that sets `autoStart` to false)
and call `filterTests()` _after_ your `test()` and `group()` definitions. Here
is a simple recipe that takes the string argument to `filterTests()` from the
command line. 

MERGE(filtering_tests_code)

syntax. If the keyword is `four`, only one test run.

MERGE(filtering_tests_keyword_equals_four)

If it is `Betty`, all tests in `group()` run (same if it is `butter`).

MERGE(filtering_tests_keyword_equals_Betty)

If it is `banana`, 3 tests run.  Without a keyword, all tests run.

# HTML5

## Geolocation

#### Problem
You want to use the HTML5 Geolocation API to keep track of the distance you have
travelled from a starting position.

#### Solution

The Geolocation API can be accessed throught the browser's `navigator` property
and is generally well supported in modern browsers (see http://caniuse.com for
specifics).  A user's location information can only be accessed by an
application with the user's express consent. 

You access your starting location by accessing `navigator.geolocation.getStartPosition()`;
you monitor your location as it changes by  using `navigator.geolocation.watchPosition()`.
Both functions work asynchoronously and return a Dart `Geoposition` object. This
object's `coords` attribute contains the location's `latitude` and `longitude`,
the browser's sense of the `accuracy` of the data (defined in feet) and a few
other properties. 

Our recipe captures the starting data, the current data and tracks the distance
change. Our geodata consists of four points: the latitude, the longitude, the
timestamp, and the accuracy of the data. The accuracy is displayed in green if
it is less than 50 ft; otherwise it is displayed in red.

The markup is fairly straightforward: we dynamically inject data into a table as
it is made available and organize it under `Position Count`, `Lat`, `Long`,
`Timestamp` and `Accuracy` headings. And we dynamically update the distance
travelled every time we get new data. 

MERGE(distance_tracker_html)

In `distance_tracker.dart`, we define success and failure callbacks  for both
the `getCurrentPosition()` and `watchPosition()` `geolocation` properties. The
success callback for `getCurrentPosition()` initializes a `startPosition`
object and injects the starting data into the display; the success callback for
`watchPosition()` appends a row to the display table every time the browser
provides new geolocation data; in addition, the callback updates the overall
distance travelled using the familiar Haversine formula for determining the
distance between 2 global points:

MERGE(distance_tracker_haversine)

The entire recipe, with some refactoring and some helper functions, looks like
this:

MERGE(distance_tracker_dart)

#### Browser support
The recipe can be found under `recipes/html5/geolocation/distance_tracker`. The
app can be run using `Dartium`. The js code generated through `dart2js` allows for
the recipe to be run in Chrome (tested on Version 23.0.1271.95) and Safari (Version
6.0.2 (8536.26.17)). In all cases, the user must provide the application
approval to access geolocation data for this recipe to work (at this time, such
approval seems to be turned off by default in Safari).

#### Known issues
At this time, the recipe does not work in Firefox (Version 17.0) due to an error in the 
compiled javascript. See http://code.google.com/p/dart/issues/detail?id=7547.

</body>
</html>
