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
        expect(data['Message'], equals('ClientConnected'));
        expect(data['OnlineClients'], equals(1));
      }, count: 1));

      ioWebSocketChannel.sink.close();
    });

    test('can get message', () async {
      ioWebSocketChannel.stream.listen(expectAsync((String details) {
        Map data = JSON.decode(details);

        if (data['Message'] == 'ClientConnected') {
          ioWebSocketChannel.sink
              .add(JSON.encode({'Message': 'Test message from client'}));
        }

        if (data['Message'] != 'ClientConnected') {
          expect(data['Message'], equals('MessageReceived'));

          ioWebSocketChannel.sink.close();
        }
      }, count: 2));
    });

    test('can send message', () async {
      IOWebSocketChannel secondIoWebSocketChannel =
          await new IOWebSocketChannel.connect('ws://localhost:8181');

      secondIoWebSocketChannel.stream.listen(expectAsync((String details) {
        Map data = JSON.decode(details);
        if (data['Message'] == 'ClientConnected' &&
            data['OnlineClients'] == 2) {
          secondIoWebSocketChannel.sink
              .add(JSON.encode({'Message': 'Hello from second client'}));
        }

        if (data['From'] == 'SocketEngine') {
          expect(data['Message'], equals('MessageReceived'));
          secondIoWebSocketChannel.sink.close();
        }
      }, count: 2, max: 3));

      ioWebSocketChannel.stream.listen(expectAsync((String details) async {
        Map data = JSON.decode(details);
        if (data['Message'] != 'ClientDisconnected' &&
            data['Message'] != 'ClientConnected') {
          expect(data['Message'], equals('Hello from second client'));
          ioWebSocketChannel.sink.close();
        }
      }, count: 3, max: 4));
    });
  });
}
