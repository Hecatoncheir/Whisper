@TestOn('browser')
library administration_section_test;

import 'dart:html';
import 'dart:async';
import 'package:test/test.dart';
import 'package:polymer/init.dart';

import 'package:whisper/src/components/administration_section/administration_section.dart';

main() async {
  await initPolymer();

  AdministrationSection administrationSection;

  setUpAll(() {
    administrationSection = querySelector('administration-section');
  });

  group('Polymer component administration-section', () {
    test('can get message', () async {
      administrationSection.attributes['message'] = 'test message';
      expect(administrationSection.message, equals('test message'));
    });

    test('can show connected clients', () async {
      administrationSection.attributes['message'] = 'ClientConnected';
      administrationSection.attributes['details'] =
          {'OnlineClientsCount': 2}.toString();
      Element clients =
          administrationSection.querySelector('.online-clients-count');

      expect(clients, isNotNull);
    });
  });
}
