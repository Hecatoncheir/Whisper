@TestOn('vm')
library socket_test;

import 'dart:io';
import 'package:test/test.dart';

import 'package:socket_system/socket.dart';

main() {
  SocketEngine socketEngine;

  setUpAll(() async {
    socketEngine = new SocketEngine();
    await socketEngine.powerUp(port:8811);
  });

  group('Socket share library', () {
    test('can create socket server', () {
      expect(socketEngine.httpServer, isNotNull);
    });

    test('can handle socket connection', () async {
      WebSocket webSocket = await WebSocket.connect('ws://localhost:8811');

      expect(socketEngine.clients.length, equals(1));
      await webSocket.close();
    });
  });

  group('SocketClients', () {
    test('must have identificator', () async {
      WebSocket webSocket = await WebSocket.connect('ws://localhost:8811');
      SocketClient socketClient = new SocketClient(webSocket);

      expect(socketClient.identificator, isNotNull);
      expect(socketClient.identificator, isNotEmpty);
      await webSocket.close();
    });
  });
}
