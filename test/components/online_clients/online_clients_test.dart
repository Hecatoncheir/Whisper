@TestOn('browser')
library online_clients_test;

import 'dart:html';
import 'package:test/test.dart';
import 'package:polymer/init.dart';

import 'package:whisper/components/online_clients/online_clients.dart';

main() async {
  await initPolymer();

  OnlineClients onlineClients;

  setUpAll(() {
    onlineClients = querySelector('online-clients');
  });

  group('Polymer component online-clients', () {
    test('can show connected online clients', () async {
      onlineClients.attributes['clients-count'] = 3.toString();
      Element clients = onlineClients.querySelector('.all-online-clients');
      expect(clients.innerHtml, equals('3'));
    });
  });
}
