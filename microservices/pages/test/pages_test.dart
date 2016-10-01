@TestOn('vm')
library pages_test;

import 'dart:convert';

import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';

import 'package:pages/pages.dart';

main() {
  Pages pages;
  IOWebSocketChannel ioWebSocketChannel;

  setUpAll(() async {
    pages = new Pages();
    await pages.socket.powerUp(ip: 'localhost', port: 8182);
  });

  setUp(() async {
    ioWebSocketChannel =
        await new IOWebSocketChannel.connect('ws://localhost:8182');
  });

  group("Pages service", () {
    test('must get page desrtiption for path', () async {
      Map data = {'Message': 'NeedPageDescription', 'Path': 'test'};
      String dataJSON = JSON.encode(data);

      ioWebSocketChannel.stream.listen(expectAsync((String dataFromServer) {
        ioWebSocketChannel.sink.add(dataJSON);
        Map detailsFromServer = JSON.decode(dataFromServer);
        expect(detailsFromServer, isNotEmpty);
        if (detailsFromServer['Message'] != 'MessageReceived') {
          expect(detailsFromServer['Message'], 'DescriptionForPage');
          expect(detailsFromServer['Details']['title'], isNotEmpty);
          expect(detailsFromServer['Details']['path'], isNotEmpty);
          expect(detailsFromServer['Details']['description'], isNotEmpty);
        }
      }, count: 3));

      ioWebSocketChannel.sink
          .add(JSON.encode({'Message': 'Connect from client'}));
    });
  });
}
