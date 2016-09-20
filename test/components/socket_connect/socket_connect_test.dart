@TestOn('browser')
library socket_connect_test;

import 'dart:html';
import 'package:test/test.dart';
import 'package:polymer/init.dart';

import 'package:whisper/components/socket_connect/socket_connect.dart';

main() async {
  await initPolymer();

  SocketConnect socketConnect;
  String socketServerIri;

  setUpAll(() {
    socketServerIri = 'ws://0.0.0.0:8181';
    socketConnect = querySelector('socket-connect');
  });

  group('Polymer component socket-connect', () {
    test('has socketServerIri attribute', () async {
      socketConnect.socketServerIri = socketServerIri;
      expect(socketConnect.socketServerIri, isNotNull);
    });
  });
}
