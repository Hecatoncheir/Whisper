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
      Map data = {'Message': 'NeedPageDescription'};
      String dataJSON = JSON.encode(data);

      ioWebSocketChannel.stream.listen(expectAsync((String dataFromServer) {
        Map detailsFromServer = JSON.decode(dataFromServer);
        expect(detailsFromServer, isNotEmpty);
        expect(detailsFromServer['Message'], 'DescriptionForPage');
        expect(detailsFromServer['Details']['title'], isNotEmpty);
        expect(detailsFromServer['Details']['path'], isNotEmpty);
        expect(detailsFromServer['Details']['description'], isNotEmpty);
      }, count: 1));

      ioWebSocketChannel.sink.add(dataJSON);
    });
  });
}
