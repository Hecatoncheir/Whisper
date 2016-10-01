part of socket_server;

class ListenersMixin {
  PagesSocket socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('NeedPageDescription', (Map data) async {
      SocketClient socketClient = data['SocketClient'];
      /// For test
      Map pageData = {'path': 'test', 'description': '...', 'title': '...'};
      socketClient.write('DescriptionForPage', {'Details': pageData});
    });
  }
}
