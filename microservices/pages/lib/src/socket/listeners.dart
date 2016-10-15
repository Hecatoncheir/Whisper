part of socket_server;

class ListenersMixin {
  PagesSocket socketEngine;

  prepareEventsListeners() async {
    socketEngine = this;

    socketEngine.on('NewPageAdded', (Map details) {
      socketEngine.writeToAllClients('NewPageAdded', details: details);
    });

    socketEngine.on('PageUpdated', (Map details) {
      socketEngine.writeToAllClients('PageUpdated', details: details);
    });
  }
}
