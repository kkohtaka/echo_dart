import 'package:echo/echo.dart';

void main() {
  EchoServer.bind('0.0.0.0', 8080)
    .then((echoServer) {
      echoServer.listen((message) {
        print(message);
      });
    });
}

