part of socket_server;

class ListenersMixin {
  PagesSocket socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('NeedPageDescription', (Map data) async {
      SocketClient socketClient = data['SocketClient'];

      Map pageData = {
        'path': 'test',
        'description': 'Page not found',
        'title': '404'
      };

      socketClient.write('DescriptionForPage', {'Details': pageData});
    });
  }
}
