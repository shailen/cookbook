import 'package:unittest/unittest.dart';
import 'dart:io';

void main() {
  var DART_SDK = Platform.environment['DART_SDK'];
  var testfile = "test/use_solo_test.dart";
  Process.run("${DART_SDK}/bin/dart", [testfile]).then((ProcessResult result) {
    if (result.exitCode != 0) throw new ExpectException("Something went wrong. Test not being run");
    
    test("only 1 test should run with solo_test", () {
      expect(result.stdout,
        equals('unittest-suite-wait-for-done\n'
               'PASS: test I am working on now\n\n'
               'All 1 tests passed.\nunittest-suite-success\n'));
    });
  });
}