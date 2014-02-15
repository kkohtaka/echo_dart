part of echo;

class EchoServer extends Stream<String> {
  ServerSocket _server;
  StreamController<String> _controller;
  StreamSubscription<Socket> _subscription;

  static Future<EchoServer> bind(
      var address,
      int port,
      { int backlog: 0,
        bool v6Only: false }) {
    var completer = new Completer();
    var futureServer = ServerSocket.bind(
        address,
        port,
        backlog: backlog,
        v6Only: v6Only);
    futureServer.then((server) {
      completer.complete(new EchoServer._internal(server));
    });
    return completer.future;
  }

  EchoServer._internal(ServerSocket server) :
    _server = server {
    _controller = new StreamController<String>(
        onListen: _onListen,
        onPause: _onPause,
        onResume: _onResume,
        onCancel: _onCancel);
  }

  StreamSubscription<String> listen(
      void onData(String line),
      { void onError(Error error),
        void onDone(),
        bool cancelOnError }) {
    return _controller.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError);
  }

  Future<EchoServer> close() {
    var completer = new Completer();
    var future = _server.close();
    future.then((server) {
      completer.complete(this);
    });
    return completer.future;
  }

  void _onListen() {
    _subscription = _server.listen(
        _onData,
        onError: _controller.addError,
        onDone: _onDone);
  }

  void _onCancel() {
    _subscription.cancel();
    _subscription = null;
  }

  void _onPause() {
    _subscription.pause();
  }

  void _onResume() {
    _subscription.resume();
  }

  void _onData(Socket client) {
    client.transform(UTF8.decoder).listen((data) {
      _controller.add(data);
      client.write(data);
    });
  }

  void _onDone() {
    _controller.close();
  }
}

