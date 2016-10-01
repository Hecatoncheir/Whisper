library pages;

import 'src/socket/socket.dart';

part 'src/page.dart';

class Pages {
  PagesSocket socket;

  Pages() {
    socket = new PagesSocket();
    socket.on('NeedPageDescription', (Map data) {
      print('NeedPageDescription');
    });
  }
}
