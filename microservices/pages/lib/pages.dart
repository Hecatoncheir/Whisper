library pages;

import 'src/socket.dart';

part 'src/page.dart';

class Pages extends Object {
  PagesSocket socket;

  Pages() {
    socket = new PagesSocket();
  }
}
