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

	String s = "hello, " + "world!";
     
So, how _do_ you concatenate strings in Dart?

#### Solution
The easiest, most efficient way is by using adjacent string literals:

	String s =  "hello, " "world!";

This still works if the adjacent strings are on different lines:

	String s = "hello, "
	    "world!";

Dart also has a `StringBuffer` class; this can be used to build up a
`StringBuffer` object and convert it to a string by calling `toString()`
on it:

	var sb = new StringBuffer(); 
	["hello, ", "world!"].forEach((item) {
	  sb.add(item);
	  });
	String s = sb.toString();
    
The `Strings` class (notice the plural) gives us 2 methods, `join()` and
`concatAll()` that can also be used. `Strings.join()` takes a delimiter as a
second argument.

	String s = Strings.join(["hello", "world!"], ", "); 
	String s = Strings.concatAll(["hello, ", "world!"]); 

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

	String greeting = "hello";
	String person = "Kathy";
	String s = "I said ${greeting} to ${person}";
	// I said hello to Kathy
  
If the expression is an identifier, the `{}` can be skipped.

	String s = "I said $greeting to $person";
  
If the variable inside the `{}` isn't a string, the variable's
`toString()` method is called:

	int x = 5;
	String s = "There are ${x.toString()} people in this room";

The call to `toString()` is unnecessary (although harmless) in this case:
`toString()` is already defined for ints and Dart automatically calls
`toString()`. What this does mean, though, is that it is the user's
responsibility to define a `toString()` method when interpolating
user-defined objects.

This will not work as expected:

	class Book {
	  String title;
	  Book(this.title);
	}
	Book book = new Book("War and Peace");
	String s = "The book is '${book}'";
	// The book is "Instance of 'Book'"

But this will:

	class Song {
	  String title;
	  Song(this.title);
	  String toString() {
	    return this.title;
	  }
	}
	Song song = new Song("You can call me Al");
	String s = "The song is '${song}'"; // The song is 'You can call me Al'

You can interpolate expressions of arbitrary complexity by placing them inside
`${}`:

A ternary `if..else`:

	int x = 5;
	String s = "There are ${x < 10 ? "a few" : "many"} people in this room";
  
List and Map operations:

	List list = [1, 2, 3, 4, 5];
	String s1 = "The list is $list, and when squared it is ${list.map((i) {return
	i * i;})}";
	// The list is [1, 2, 3, 4, 5], and when squared it is [1, 4, 9, 16, 25]
	
	Map map = {"ca": "California", "pa": "Pennsylvania"};
	String s2 = "I live in sunny ${map['ca']}";
	// I live in sunny California

Notice above that you can access `$list`(an identifier) without using `{}`,
but the call to `list.map`(an expression) needs to be inside `{}`. 

Expressions inside `${}` can be arbitrarily complex:

	List names = ['John', 'Paul', 'George', 'Ringo'];
	String s = "${
	  ((names) {
	      return names[(new math.Random()).nextInt(names.length)];
	  })(names)} was the most important member of the Beatles";

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

	String s = "hello";
	List<int> charCodes = s.charCodes;
	// [104, 101, 108, 108, 111]
  
To get a specific character code, you can either subscript `charCodes`, or 
use `charCodeAt`:

	int charCode = s.charCodeAt(0); // 104
  
To assemble a string from a list of character codes, use the `String` factory,
`fromCharCodes`:

	List<int> charCodes = [104, 101, 108, 108, 111];
	String s = new String.fromCharCodes(charCodes);

  
If you are using a StringBuffer to build up a string, you can add individual
charCodes using `addCharCode` (use `add()` to add characters; use `addCharCode()`
to add charCodes):

	StringBuffer sb = new StringBuffer();
	List<int> charCodes = [104, 101, 108, 108, 111];
	charCodes.forEach((charCode) {
	  sb.addCharCode(charCode);
	});
	String s = sb.toString(); // "Hello" 

Here is an implementation of the `rot13` algorithm, using the tools described above.
`rot13` is a simple letter substitution algorithm that rotates a string by 13
places by replacing each character in it by one that is 13 characters removed
('a' becomes 'n', 'N' becomes 'A', etc.):

	String rot13(String s) {
	  List<int> rotated = [];
	
	  s.charCodes.forEach((charCode) {
	    final int numLetters = 26;
	    final int A = 65;
	    final int a = 97;
	    final int Z = A + numLetters;
	    final int z = a + numLetters;
	
	    if (charCode < A ||
	        charCode > z ||
	        charCode > Z && charCode < a) {
	      rotated.add(charCode);
	    }
	    else {
	      if ([A, a].some((item){
	        return item <= charCode && charCode < item + 13;
	      })) {
	        rotated.add(charCode + 13);
	      } else {
	        rotated.add(charCode - 13);
	      }   
	    }
	  });
	
	  return (new String.fromCharCodes(rotated));
	}

Running the code:
 
	var wordList = ["Jung", "be", "purely", "barf"];
	List rotated = wordList.map((word) {
	    return rot13(word);
	  });
	// ["What", "or", "cheryl", "ones"]

and:

	String str1 = "aMz####AmZ";
	String str2 = rot13(rot13(str1));
	// str1 == str2

# Testing

### <a id="running_only_a_single_test"></a>Running only a single test

**pubspec dependencies**: _unittest, args_

#### Problem
You are coding away furiously and diligently writing tests for everything. But,
running all your tests takes time and you want to run just a single test,
perhaps the one for the code you are working on.

#### Solution
The easiest way to do this is to convert a `test()`s to a `solo_test()`:

	import "package:unittest/unittest.dart";
	
	void main() {
	  test("test that's already running fine", () {
	    expect('foo', equals('foo'));
	  }); // this test will not run
	
	  solo_test("test I am working on now", () {
	    expect('bar', equals('bar'));
	  });
	}

Run the tests now and you'll see that only the `solo_test()` runs; the `test()`
does not.

	unittest-suite-wait-for-done
	PASS: test I am working on now
	
	All 1 tests passed.
	unittest-suite-success

You can also run a single test by passing the `id` of that test
to `setSoloTest()` (see `unittest/src/unittest.dart`), perhaps as a command-line
arg.

Since the default `unittest` ouput does not include the test `id`, you
need to extend the default Configuration class (see unittest/src/config.dart):

	import 'package:unittest/unittest.dart';
	import 'package:args/args.dart';
	
	class SingleTestConfiguration extends Configuration {
	  get autoStart => false;
	  void onDone(int passed, int failed, int errors, List<TestCase> testCases,
	              String uncaughtError) {
	    testCases.forEach((testCase){
	      // get the id of the testCase in there
	      print("${testCase.id}\t${testCase.result.toUpperCase()}: ${testCase.description}");
	      });
	   // skip the summary that is normally provided here...
	  }
	}

Our custom configuration is pretty minimal: we modify the default
`Configuration`'s `onDone()` to include the test `id` on every line (`onDone()`
also outputs a summary of the entire test run; we skip that here).

Now we need code to use our new configuration and to initialize the test
framework (we put code for that in `useSingleTestConfiguration()` and call that function
from `main()`):

	void useSingleTestConfiguration() {
	  configure(new SingleTestConfiguration());
	  ensureInitialized();  
	}

We use `ArgParser` to parse the command line arguments: if an id is provided
through the command line, only the test with that id runs:

	$ dart myFile.dart 2
	unittest-suite-wait-for-done
	2 FAIL: failing test

if no id is provided, all the tests run:
  
	$ dart myFile.dart
	unittest-suite-wait-for-done
	1 PASS: passing test
	2 FAIL: failing test
	3 PASS: another passing test

Here is the complete example:

	import 'package:unittest/unittest.dart';
	import 'package:args/args.dart';
	
	class SingleTestConfiguration extends Configuration {
	  get autoStart => false;
	  void onDone(int passed, int failed, int errors, List<TestCase> testCases,
	              String uncaughtError) {
	    testCases.forEach((testCase){
	      // get the id of the testCase in there
	      print("${testCase.id}\t${testCase.result.toUpperCase()}: ${testCase.description}");
	      });
	   // skip the summary that is normally provided here...
	  }
	}
	
	void useSingleTestConfiguration() {
	  configure(new SingleTestConfiguration());
	  ensureInitialized();  
	}
	
	void main() {
	  useSingleTestConfiguration();
	
	  // get the args from the command line
	  ArgParser argParser = new ArgParser();
	  Options options = new Options();
	  ArgResults results = argParser.parse(options.arguments);
	  List<String> args = results.rest;
	
	  // note that the second test is failing
	  test("passing test", () => expect(1, equals(1)));
	  test("failing test", () => expect(false, isTrue));
	  test("another passing test", () => expect(3, equals(3)));
	
	  if (!args.isEmpty) {
	    setSoloTest(int.parse(args[0]));
	  }
	
	  // run the tests (we turned off auto-running of tests, remember?
	  runTests();
	}

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

	import "package:unittest/unittest.dart";
	import "package:args/args.dart";
	
	class FilterTests extends Configuration {
	  get autoStart => false;
	}
	
	void useFilteredTests() {
	  configure(new FilterTests());
	  ensureInitialized();
	}
	
	void main() {
	  useFilteredTests();
	
	  // get the args from the command line
	  ArgParser argParser = new ArgParser();
	  Options options = new Options();
	  ArgResults results = argParser.parse(options.arguments);
	  List<String> args = results.rest;
	
	  test("one banana", () => expect(1, equals(1)));
	  test("two banana", () => expect(2, equals(2)));
	  test("three banana",()  => expect(3, equals(3)));
	  test("four", () => expect(4, equals(4)));
	
	  group("Betty Botter bought a bit of", () {
	    test("butter", () => expect("butter".length, equals(6)));
	    test("better butter", () => expect("better butter".length, equals(13)));
	  });
	
	  if (!args.isEmpty) {
	    filterTests(args[0]);
	  }
	  runTests();
	}
	

syntax. If the keyword is `four`, only one test run.

	unittest-suite-wait-for-done
	PASS: four
	
	All 1 tests passed.
	unittest-suite-success

If it is `Betty`, all tests in `group()` run (same if it is `butter`).

	unittest-suite-wait-for-done
	PASS: Betty Botter bought a bit of butter
	PASS: Betty Botter bought a bit of better butter
	
	All 2 tests passed.
	unittest-suite-success

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

	<!DOCTYPE html>
	<html>
	  <head>
	    <meta charset="utf-8">
	    <title>Distance Tracker</title>
	    <link rel="stylesheet" href="distance_tracker.css">
	  </head>
	  <body>
	    <h2>Distance Tracker</h2>
	    <table id="geo-data">
	      <tr>
	        <th>Position Count</th>
	        <th>Lat</th>
	        <th>Long</th>
	        <th>Timestamp</th>
	        <th>Accuracy</th>
	      </tr>
	    </table>
	
	    <br>
	
	    <table>
	      <tr>
	        <td>Distance travelled: </td>
	        <td id="distance"></td>
	      </tr>
	    </table>
	
	   <div id="error"></div>
	
	    <script type="application/dart" src="distance_tracker.dart"></script>
	    <script src="http://dart.googlecode.com/svn/branches/bleeding_edge/dart/client/dart.js"></script>
	  </body>
	</html>
	

In `distance_tracker.dart`, we define success and failure callbacks  for both
the `getCurrentPosition()` and `watchPosition()` `geolocation` properties. The
success callback for `getCurrentPosition()` initializes a `startPosition`
object and injects the starting data into the display; the success callback for
`watchPosition()` appends a row to the display table every time the browser
provides new geolocation data; in addition, the callback updates the overall
distance travelled using the familiar Haversine formula for determining the
distance between 2 global points:

	num _calculateDistance(lat1, long1, lat2, long2) {
	  const num EARTH_RADIUS = 6371; // in km
	  const num MILES_PER_KM = .6;
	  var LatDiff = _toRad((lat2-lat1));
	  var LongDiff = _toRad((long2-long1));
	  var a = pow(sin(LatDiff/2), 2) +
	          cos(_toRad(lat1)) * cos(_toRad(lat2)) *
	          pow(sin(LongDiff/2), 2);
	  var c = 2 * atan2(sqrt(a), sqrt(1-a));
	  var distance = EARTH_RADIUS * c;
	  return distance * MILES_PER_KM;
	}

The entire recipe, with some refactoring and some helper functions, looks like
this:

	import 'dart:html';
	import 'dart:math';
	
	// This uses the Haversine formula for calculating the distance between 
	// 2 points on the globe (http://en.wikipedia.org/wiki/Haversine_formula)
	num _calculateDistance(lat1, long1, lat2, long2) {
	  const num EARTH_RADIUS = 6371; // in km
	  const num MILES_PER_KM = .6;
	  var LatDiff = _toRad((lat2-lat1));
	  var LongDiff = _toRad((long2-long1));
	  var a = pow(sin(LatDiff/2), 2) +
	          cos(_toRad(lat1)) * cos(_toRad(lat2)) *
	          pow(sin(LongDiff/2), 2);
	  var c = 2 * atan2(sqrt(a), sqrt(1-a));
	  var distance = EARTH_RADIUS * c;
	  return distance * MILES_PER_KM;
	}
	
	num _toRad(num x) => x * PI / 180;
	
	String _getTime(timestamp) {
	  Date date = new Date.fromMillisecondsSinceEpoch(timestamp);
	  return date.toString().split(" ").last.split(".")[0];
	}
	
	String _displayData(String subject, Geoposition position) {
	  return """<td><b>$subject</b></td>
	  <td>${position.coords.latitude}&deg;</td>
	  <td>${position.coords.longitude}&deg;</td>
	  <td>${_getTime(position.timestamp)}</td>
	  <td class=${position.coords.accuracy > 100 ? "red" : "green"}>${position.coords.accuracy} feet</td>""";
	}
	
	void _displayErrorMessage(String error_message) {
	  var error_div = query("#error");
	  error_div.text = error_message; 
	}
	
	void displayCurrentPositionData(Geoposition position) {
	  var elem = new TableRowElement();
	  elem.innerHtml = _displayData("Starting", position);
	  query("#geo-data").children.add(elem);
	}
	
	void displayWatchPositionData(Geoposition startPosition, Geoposition currentPosition) {
	  var elem = new TableRowElement();
	  elem.innerHtml = _displayData("Current", currentPosition);
	  query("#geo-data").children.add(elem);
	
	  num distance = _calculateDistance(
	    startPosition.coords.latitude,
	    startPosition.coords.longitude,
	    currentPosition.coords.latitude,
	    currentPosition.coords.longitude);
	
	  query("#distance").text = "${distance.toStringAsFixed(4)} miles";
	}
	
	void handleError(PositionError error) {
	  var error_div = query("#error");
	  switch (error.code) {
	    case PositionError.PERMISSION_DENIED:
	      _displayErrorMessage("The user did not grant permission to access location data."); break;
	    case PositionError.POSITION_UNAVAILABLE:
	      _displayErrorMessage("The browser could not determine your location"); break;
	    case PositionError.TIMEOUT:
	      _displayErrorMessage("The browser timed out before fetching your location"); break;
	    default:
	      _displayErrorMessage("There was an error in retreiving your location: ${error.message}"); break;
	  }
	}
	
	void main(){
	
	  Geoposition startPosition;
	  // raise error for requests longer than 10 seconds; filter out inaccurate readings
	  var optional_params = {'timeout': 10000, 'enableHighAccuracy': true};
	
	  window.navigator.geolocation.getCurrentPosition(
	    (Geoposition position) {
	      startPosition = position;
	      displayCurrentPositionData(position);
	    },
	    (error) => handleError(error), optional_params
	  );
	
	  window.navigator.geolocation.watchPosition((Geoposition position) {
	    displayWatchPositionData(startPosition, position);
	    },
	    (error) => handleError(error), optional_params
	  );
	}
	

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

