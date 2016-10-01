part of socket_server;

class EventsListeners {
  SocketEngine socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('WriteToAllClients', (Map data) async {
      socketEngine.writeToAllClients(data['Details']['forAllClientsMessage'],
          from: data['SocketClient'], details: data);
    });

    socketEngine.on('SocketClientMustBeRegistered',
        (SocketClient socketClient) async {
      socketEngine.writeToAllClients('ClientConnected',
          details: {'OnlineClientsCount': socketEngine.clients.length});
    });

    socketEngine.on('SocketClientMustBeRemoved',
        (SocketClient socketClient) async {
      socketEngine.writeToAllClients('ClientDisconnected',
          from: socketClient,
          details: {'OnlineClientsCount': socketEngine.clients.length});
    });
  }
}
