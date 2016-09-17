@TestOn('vm')
library engine_test;

import 'dart:convert';

import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';

import 'package:whisper/engine.dart';

main() {
  group('Socket server', () {
    Engine engine;
    IOWebSocketChannel ioWebSocketChannel;

    setUpAll(() async {
      engine = new Engine();
      await engine.socket.powerUp(ip: 'localhost', port: 8181);
    });

    setUp(() async {
      ioWebSocketChannel =
          await new IOWebSocketChannel.connect('ws://localhost:8181');
    });

    test('can register clients', () async {
      ioWebSocketChannel.stream
          .listen(expectAsync((String messageFromSocketEngine) {
        Map data = JSON.decode(messageFromSocketEngine);
        expect(data['Message'], equals('Client connected'));
        expect(data['Online clients'], equals(1));
      }, count: 1));

      ioWebSocketChannel.sink.close();
    });

    test('can get message', () async {
      ioWebSocketChannel.stream.listen(expectAsync((String data) {
        Map messageFromSocket = JSON.decode(data);
        if (messageFromSocket['Message'] == 'Client connected') {
          ioWebSocketChannel.sink
              .add(JSON.encode({'Message': 'Test message from client'}));
        }

        if (messageFromSocket['Message'] != 'Client connected') {
          expect(messageFromSocket['Message'], equals('Message received'));

          ioWebSocketChannel.sink.close();
        }
      }, count: 2));
    });
    // test('can send message');
  });
}
