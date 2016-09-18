library app;

import 'dart:html';
import 'dart:convert';

import 'package:web_socket_channel/html.dart';

import 'package:polymer/polymer.dart';

import 'package:polymer_elements/app_route.dart';

import 'package:whisper/components/administration_section/administration_section.dart';

main() async {
  await initPolymer();

  String server = 'ws://localhost:8181';
  HtmlWebSocketChannel socket = new HtmlWebSocketChannel.connect(server);
  // socket.sink.add(JSON.encode({'message': 'test'}));

  socket.stream.listen((e) {
    print(e);
  });
}
