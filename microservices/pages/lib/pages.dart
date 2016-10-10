library pages;

import 'src/socket.dart';
import 'src/database/database.dart';

part 'src/page.dart';

class Pages extends Object with DataBaseMixin {
  PagesSocket socket;

  Pages() {
    socket = new PagesSocket();
  }
}
