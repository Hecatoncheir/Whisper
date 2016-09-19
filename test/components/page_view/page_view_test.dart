@TestOn('browser')
library page_view_test;

import 'dart:html';
import 'package:test/test.dart';
import 'package:polymer/init.dart';

import 'package:whisper/components/page_view/page_view.dart';

main() async {
  await initPolymer();

  PageView pageView;

  setUpAll(() {
    pageView = querySelector('page-view');
  });

  group('Polymer component page-view', () {
    test('can show page', () async {
      Element element = pageView.querySelector('section[name="admin"]');
      pageView.set('route.path', 'admin');
      expect(element.classes.contains('iron-selected'), isTrue);
    }, skip: '');
  });
}
