part of socket_server;

class EventsListeners {
  PagesSocket socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('NeedPageDescription', (Map data) async {
      print(data);
    });
  }
}
