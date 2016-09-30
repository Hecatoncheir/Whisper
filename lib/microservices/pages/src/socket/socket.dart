library socket_server;

import 'package:whisper/share/socket/socket.dart' as share;
import 'package:whisper/share/socket/socket.dart' show SocketClient;

part 'listeners.dart';

class SocketEngine extends share.SocketEngine with EventsListeners {
  SocketEngine() {
    prepareEventsListeners();
  }

  @override
  powerUp({String ip, int port: 8182}) {
    super.powerUp(port: port);
  }
}
