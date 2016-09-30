@TestOn('browser')
library page_view_test;

import 'dart:html';
import 'package:test/test.dart';
import 'package:polymer/init.dart';

import 'package:whisper/src/components/page_view/page_view.dart';

main() async {
  await initPolymer();

  PageView pageView;

  setUpAll(() {
    pageView = querySelector('page-view');
  });

  group('Polymer component page-view', () {
    test('has route property', () async {
      String routePath = pageView.route['path'];
      String path = pageView.get('route.path');
      expect(routePath, equals(path));
    });

    // test('can show page', () async {
    //   Element element = pageView.querySelector('section[name="main"]');
    //   expect(element.classes.contains('iron-selected'), isTrue);
    // }, skip: 'page-view can show pages');
  });
}
