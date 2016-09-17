part of socket_server;

class EventsListeners {
  SocketEngine socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('Socket client must be registered', (socketClient) async {
      socketEngine.writeToAllClients('Client connected',
          details: {'Online clients': socketEngine.clients.length});
    });

    socketEngine.on('Socket client must be removed',
        (SocketClient socketClient) async {
      await socketEngine.removeClient(socketClient);
      socketEngine.writeToAllClients('Client disconnected',
          details: {'Online clinets': socketEngine.clients.length});
    });

    socketEngine.on('test', (e) {
      print('from mixin $e');
    });
  }
}
