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
    await pages.setUpDataBase();
    await pages.socket.powerUp(ip: 'localhost', port: 8182);
  });

  setUp(() async {
    ioWebSocketChannel =
        await new IOWebSocketChannel.connect('ws://localhost:8182');
  });

  group("Pages service", () {
    test('can save page', () async {
      String socketMessage = 'PageMustBeSaved';

      Map pageDetails = {
        'title': 'Test page',
        'description': 'Test description text',
        'path': 'test'
      };

      ioWebSocketChannel.stream.listen(expectAsync((messageFromSocket) {
        Map detailsFromServer = JSON.decode(messageFromSocket);
        String message = detailsFromServer['Message'];
        pageDetails['id'] = detailsFromServer['Page']['id'];

        expect(message, equals('NewPageAdded'));
        expect(detailsFromServer['Page'], equals(pageDetails));
        ioWebSocketChannel.sink.close();
      }));

      Map detailsForServer = {'Message': socketMessage, 'Page': pageDetails};
      ioWebSocketChannel.sink.add(JSON.encode(detailsForServer));
    });

    test('can update page', () async {
      String socketMessage = 'PageMustBeUpdated';

      Map pageDetails = {
        'title': 'Updated test page',
        'description': 'Test description text',
        'path': 'test'
      };

      ioWebSocketChannel.stream.listen(expectAsync((messageFromSocket) {
        Map detailsFromServer = JSON.decode(messageFromSocket);
        String message = detailsFromServer['Message'];
        pageDetails['id'] = detailsFromServer['Page']['id'];

        expect(message, equals('PageUpdated'));
        expect(detailsFromServer['Page'], equals(pageDetails));
        ioWebSocketChannel.sink.close();
      }));

      Map detailsForServer = {'Message': socketMessage, 'Page': pageDetails};
      ioWebSocketChannel.sink.add(JSON.encode(detailsForServer));
    });

    test('can get page', () async {
      ioWebSocketChannel.stream.listen(expectAsync((messageFromSocket) {
        Map detailsFromServer = JSON.decode(messageFromSocket);
        String message = detailsFromServer['Message'];

        Map pageDetails = {
          'title': 'Updated test page',
          'description': 'Test description text',
          'path': 'test'
        };
        pageDetails['id'] = detailsFromServer['Page']['id'];

        expect(message, equals('PageDetailsReady'));
        expect(detailsFromServer['Page'], equals(pageDetails));
        ioWebSocketChannel.sink.close();
      }));

      Map pageForCompare = {'path': 'test'};
      Map detailsForServer = {
        'Message': 'NeedPageDetails',
        'Page': pageForCompare
      };
      ioWebSocketChannel.sink.add(JSON.encode(detailsForServer));
    });

    test('can remove page', () async {
      ioWebSocketChannel.stream.listen(expectAsync((messageFromSocket) {
        Map detailsFromServer = JSON.decode(messageFromSocket);
        String message = detailsFromServer['Message'];

        detailsFromServer['Page']['id'] = detailsFromServer['Page']['id'];

        expect(message, equals('PageRemoved'));
        expect(detailsFromServer['Page']['id'], isNotNull);
        ioWebSocketChannel.sink.close();
      }));

      Map pageForCompare = {'path': 'test'};
      Map detailsForServer = {
        'Message': 'PageShouldBeRemoved',
        'Page': pageForCompare
      };
      ioWebSocketChannel.sink.add(JSON.encode(detailsForServer));
    });
  });
}
