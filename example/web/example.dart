library app;

import 'dart:html';
import 'dart:convert';

import 'package:web_socket_channel/html.dart';

main() async {
  String server = 'ws://localhost:8181';
  HtmlWebSocketChannel socket = new HtmlWebSocketChannel.connect(server);
  // socket.sink.add(JSON.encode({'message': 'test'}));

  socket.stream.listen((e) {
    print(e);
  });
}
