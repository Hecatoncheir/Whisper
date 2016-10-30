library socket_server;

import 'package:socket_system/socket.dart' as socket;

part 'listeners.dart';

class SocketEngine extends socket.SocketEngine with EventsListeners {
  SocketEngine() {
    prepareEventsListeners();
  }
}
