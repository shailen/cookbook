import 'package:unittest/unittest.dart';
import 'dart:io';

void main() {
  var DART_SDK = Platform.environment['DART_SDK'];
  if (DART_SDK == null) {
    throw("DART_SDK is not defined. Perhaps you were trying to run the tests in the Editor?");
  }
  var testfile = "test/use_setsolotest.dart";
  Process.run("${DART_SDK}/bin/dart", [testfile, "2"]).then((ProcessResult result) {
    if (result.exitCode != 0) throw new ExpectException("Something went wrong. Test not being run");
    
    test("only 1 test should run with setSoloTest", () {
      expect(result.stdout,
        equals('unittest-suite-wait-for-done\n2'
            '\tFAIL: failing test\n\n'
            'We\'re skipping the summary that normally goes in onDone() in this example.\n'));
    });
  });
}