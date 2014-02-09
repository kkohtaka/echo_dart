library test_runner;

import 'package:unittest/unittest.dart' as unittest;
import 'echo_test.dart';

void testCore(unittest.Configuration config) {
  unittest.unittestConfiguration = config;
  unittest.groupSep = ' - ';

  main();
}

void main() {
  unittest.group('echo', () {
    EchoTest test = new EchoTest();
    test.run();
  });
}

