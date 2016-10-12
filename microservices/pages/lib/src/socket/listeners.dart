part of socket_server;

class ListenersMixin {
  PagesSocket socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('DescriptionForPageReady', (Map data) {
      SocketClient socketClient =
          socketEngine.clients[data['ClientIdentificator']];

      socketClient.write(
          'DescriptionForPage', {'PageDescription': data['PageDescription']});
    });

    socketEngine.on('NeededDetailsOfPageReady', (Map data) {});
  }
}
