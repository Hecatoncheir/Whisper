@TestOn('vm')
library socket_test;

import 'package:test/test.dart';

import 'package:whisper/share/socket/socket.dart';

main() {
  group('Socket share library', () {
    SocketEngine socketEngine;
    setUpAll(() async {
      socketEngine = new SocketEngine();
      await socketEngine.powerUp();
    });

    test('can create socket server', () {
      expect(socketEngine.httpServer, isNotNull);
    });
  });
}
