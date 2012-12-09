import 'package:unittest/unittest.dart';
import 'package:character_codes/character_codes.dart';

void main() {
  test("useCharCodes", () {
    expect(useCharCodes(), equals([104, 101, 108, 108, 111]));
  });

  test("useCharCodeAt", () {
    expect(useCharCodeAt(), equals(104));
  });

  test("useFromCharCodes", () {
    expect(useFromCharCodes(), equals("hello"));  
  });

  test("useStringBuffer", () {
    expect(useStringBuffer(), equals("hello"));  
  });

  test("useRot13", () {
    expect(useRot13(), equals(["What", "or", "cheryl", "ones"]));
  });

  test("useRot13WithNonAlpha", () {
    expect(useRot13WithNonAlpha(), isTrue);
  });
}
