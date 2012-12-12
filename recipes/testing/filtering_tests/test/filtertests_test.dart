import 'package:unittest/unittest.dart';
import 'dart:io';

final String DART_SDK = Platform.environment['DART_SDK'];
final String testfile = "filtertests.dart";

void runTest(String keyword, var numTests, String output) {
  Process.run("${DART_SDK}/bin/dart", [testfile, keyword]).then((ProcessResult result) {
    if (result.exitCode != 0) throw new ExpectException("Something went wrong. Test not being run");
    
    test("$numTests tests should run if the keyword == $keyword", () {
      expect(result.stdout, equals(output));
    });
  });
}

void main() {
  runTest("four", 1,
           'unittest-suite-wait-for-done\n'
           'PASS: four\n\nAll 1 tests passed.\n'
           'unittest-suite-success\n');
  runTest("banana", 3,
          'unittest-suite-wait-for-done\n'
          'PASS: one banana\n'
          'PASS: two banana\n'
          'PASS: three banana\n\n'
          'All 3 tests passed.\nunittest-suite-success\n');
  runTest("Betty", 2,
          'unittest-suite-wait-for-done\n'
          'PASS: Betty Botter bought a bit of butter\n'
          'PASS: Betty Botter bought a bit of better butter\n\n'
          'All 2 tests passed.\nunittest-suite-success\n');
  runTest("", "all",
          'unittest-suite-wait-for-done\n'
          'PASS: one banana\n'
          'PASS: two banana\n'
          'PASS: three banana\n'
          'PASS: four\n'
          'PASS: Betty Botter bought a bit of butter\n'
          'PASS: Betty Botter bought a bit of better butter\n\n'
          'All 6 tests passed.\nunittest-suite-success\n');
}