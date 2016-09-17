@TestOn('vm')
library engine_test;

import 'dart:convert';

import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';

import 'package:whisper/engine.dart';

main() {
  group('Socket server', () {
    Engine engine = new Engine();

    test('can register clients', () async {
      await engine.socket.powerUp(ip: 'localhost', port: 8181);
      IOWebSocketChannel ioWebSocketChannel =
          await new IOWebSocketChannel.connect('ws://localhost:8181');

      ioWebSocketChannel.stream
          .listen(expectAsync((String messageFromSocketEngine) {
        Map data = JSON.decode(messageFromSocketEngine);
        expect(data['Message'], equals('Client connected'));
        expect(data['Online clients'], equals(1));
      }, count: 1));
    });
    // test('can get message');
    // test('can send message');
  });
}
