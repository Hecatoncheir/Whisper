@HtmlImport('page_view_theme.html')
@HtmlImport('page_view.html')
library page_view;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:polymer_elements/app_location.dart';
import 'package:polymer_elements/app_route.dart';
import 'package:polymer_elements/iron_pages.dart';

import 'package:whisper/components/socket_connect/socket_connect.dart';
import 'package:whisper/components/administration_section/administration_section.dart';

@PolymerRegister('page-view')
class PageView extends PolymerElement {
  @Property(observer: 'routeChanged')
  Map route;

  PageView.created() : super.created();

  attached() async {
    set('socketServerIri', 'ws://localhost:8181');
  }

  @reflectable
  routeChanged(Map newRoute, [details]) async {
    if (route['path'] == '') {
      set('route.path', 'main');
    }
  }
}
