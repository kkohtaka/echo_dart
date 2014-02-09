library echo_test;

import 'package:echo/echo.dart';
import 'package:unittest/unittest.dart';

class EchoTest {
  void testSomeMethod() {
    Echo echo = new Echo();
    expect(echo, isNotNull);
    expect(echo.someMethod(), equals('Hello, Unit Test'));
  }

  void run() {
    test('Echo', testSomeMethod);
  }
}

