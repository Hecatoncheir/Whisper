part of socket_server;

class EventsListeners {
  SocketEngine socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('Write to all clients', (Map data) async {
      socketEngine.writeToAllClients(data['details']['Message'],
          from: data['from'], details: data['details']);
    });

    socketEngine.on('Socket client must be registered',
        (SocketClient socketClient) async {
      socketEngine.writeToAllClients('Client connected',
          details: {'Online clients': socketEngine.clients.length});
    });

    socketEngine.on('Socket client must be removed',
        (SocketClient socketClient) async {
      await socketEngine.removeClient(socketClient);
      socketEngine.writeToAllClients('Client disconnected',
          from: socketClient,
          details: {'Online clinets': socketEngine.clients.length});
    });
  }
}
