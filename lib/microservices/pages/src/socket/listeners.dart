part of socket_server;

class EventsListeners {
  SocketEngine socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('NeedPageDescription', (Map data) async {
      print(data);
    });
  }
}
