part of socket_server;

class EventsListeners {
  SocketEngine socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('SocketClientMustBeRegistered',
        (SocketClient socketClient) async {
      Map detailsOfSocketClient = {
        'Message': 'ClientRegistered',
        'Identificator': socketClient.identificator
      };

      socketClient.write('ClientRegistered', detailsOfSocketClient);

      socketEngine.writeToAllClients('ClientConnected', details: {
        'OnlineClientsCount': socketEngine.clients.length,
        'ConnectedClientIdentificator': socketClient.identificator
      });
    });

    socketEngine.on('SocketClientMustBeRemoved',
        (SocketClient socketClient) async {
      socketEngine.writeToAllClients('ClientDisconnected',
          details: {'OnlineClientsCount': socketEngine.clients.length});
    });
  }
}
