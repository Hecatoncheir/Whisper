@TestOn('vm')
library engine_test;

import 'dart:convert';

import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';

import 'package:whisper/src/engine/engine.dart';

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
        if (data['Message'] == 'ClientConnected') return;

        expect(data['Message'], equals('ClientRegistered'));
        expect(data['Identificator'], isNotNull);
        expect(data['Identificator'], isNotEmpty);
      }, count: 2));

      ioWebSocketChannel.sink.close();
    });

    test('can send clients count', () async {
      ioWebSocketChannel.stream
          .listen(expectAsync((String messageFromSocketEngine) {
        Map data = JSON.decode(messageFromSocketEngine);
        if (data['Message'] == 'ClientRegistered') return;

        expect(data['Message'], equals('ClientConnected'));
        expect(data['OnlineClientsCount'], equals(1));
      }, count: 2));

      ioWebSocketChannel.sink.close();
    });
  });
}
