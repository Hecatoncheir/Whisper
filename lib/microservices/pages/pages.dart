library pages;

import 'src/socket/socket.dart';

part 'src/page.dart';

class Pages {
  SocketEngine socket;

  Pages() {
    socket = new SocketEngine();
    socket.on('NeedPageDescription', (Map data) {
      print('NeedPageDescription');
    });
  }
}
