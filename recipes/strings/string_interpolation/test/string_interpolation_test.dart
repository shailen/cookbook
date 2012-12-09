import "package:unittest/unittest.dart";
import "package:string_interpolation/string_interpolation.dart";


void main() {
  test("simpleInterpolation", () {
    expect(simpleInterpolation(), equals("I said hello to Kathy"));
  });

  test("simpleInterpolationWithoutCurlies", () {
    expect(simpleInterpolationWithoutCurlies(), equals("I said hello to Kathy"));
  });

  test("callingToStringOnInt", () {
    expect(callingToStringOnInt(), equals('There are 5 people in this room'));
  });

  test("withoutToString", () {
    Book book = new Book("War and Peace");
    expect(withoutToString(), equals("The book is 'Instance of \'Book\''"));
  });

  test("withToString", () {
    Song song = new Song("You can call me Al");
    expect(withToString(), equals("The song is 'You can call me Al'"));
  });

  test ("useTernaryIfElse", () {
    expect(useTernaryIfElse(), equals("There are a few people in this room"));
  });

  test ("listAndMapOperations", () {
    List strings = listAndMapOperations();
    expect(strings[0], equals(
      "The list is [1, 2, 3, 4, 5], and when squared it is [1, 4, 9, 16, 25]"));
    expect(strings[1], equals("I live in sunny California"));
  });

  test("interpolateSelfCallingFunction", () {
      List names = ['John', 'Paul', 'George', 'Ringo'];
      String str = interpolateSelfCallingFunction();
      List<String> tokens = str.split(' ');
      test("interpolateSelfCallingFunction", () {
        expect(names.contains(tokens[0]), isTrue);
        expect(Strings.join(tokens.getRange(1, tokens.length - 1), " "), 
          equals("was the most important member of the Beatles"));
      });
  });
}
