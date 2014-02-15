library echo_test;

import 'package:echo/echo.dart';
import 'package:unittest/unittest.dart';

import 'dart:convert';
import 'dart:io';

class EchoTest {
  static const String _address = '0.0.0.0';
  static const int _port = 8080;

  static const String _message = 'Hello, EchoServer';

  var _futureEchoServer;

  void run() {
    group('EchoServer', () {
      setUp(() {
        _futureEchoServer = EchoServer.bind(_address, _port);
      });
      test('static bind', testStaticBind);
      test('listen', testListen);
      test('close', testClose);
    });
  }

  void testStaticBind() {
    expect(_futureEchoServer, new isInstanceOf<Future<EchoServer>>());
    _futureEchoServer.then(expectAsync1((echoServer) {
      expect(echoServer, new isInstanceOf<EchoServer>());
      echoServer.close();
    }));
  }

  void testListen() {
    _futureEchoServer.then(expectAsync1((echoServer) {
      expect(echoServer, new isInstanceOf<EchoServer>());
      echoServer.listen(expectAsync1((message) {
        expect(message, equals(_message));
        echoServer.close().then(expectAsync1((innerEchoServer) {
          expect(innerEchoServer, same(echoServer));
        }));
      }));
    }));
    Socket.connect(_address, _port)
      .then(expectAsync1((echoServer) {
        expect(echoServer, new isInstanceOf<Socket>());
        echoServer.write(_message);
        echoServer.transform(UTF8.decoder)
          .listen(
            expectAsync1((message) {
              expect(message, equals(_message));
              echoServer.close().then(expectAsync1((innerEchoServer) {
                expect(innerEchoServer, same(echoServer));
              }));
            }));
      }));
  }

  void testClose() {
    _futureEchoServer.then(expectAsync1((echoServer) {
      expect(echoServer, new isInstanceOf<EchoServer>());
      var future = echoServer.close();
      expect(future, new isInstanceOf<Future<EchoServer>>());
      future.then(expectAsync1((innerEchoServer) {
        expect(innerEchoServer, same(echoServer));
      }));
    }));
  }
}

