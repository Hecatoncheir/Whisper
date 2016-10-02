part of socket_server;

class ListenersMixin {
  PagesSocket socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('NeedPageDescription', (Map data) async {
      Map pageData = {
        'path': 'test',
        'description': 'Page not found',
        'title': '404'
      };

      SocketClient socketClient =
          socketEngine.clients[data['ClientIdentificator']];

      socketClient.write('DescriptionForPage', {'Details': pageData});
    });
  }
}
