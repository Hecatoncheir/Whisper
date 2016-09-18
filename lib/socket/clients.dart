part of socket_server;

class SocketClient extends Object with NotifyMixin, ObservableMixin {
  IOWebSocketChannel channel;

  SocketClient(WebSocket client) {
    channel = new IOWebSocketChannel(client);

    channel.stream
        .listen(messageHandler, onError: errorHandler, onDone: finishedHandler);
  }

  messageHandler(String data) async {
    Map detailsFromClient = JSON.decode(data);
    String transaction = detailsFromClient['Transaction'];

    Map details = {'From': 'Socket engine'};
    if (transaction != null) details['Transaction'] = transaction;

    this.write('Message received', details);

    dispatchEvent(
        'Write to all clients', {'from': this, 'details': detailsFromClient});
  }

  void errorHandler(error) {
    dispatchEvent('Socket client must be removed', this);
    channel.sink.close();
  }

  void finishedHandler() {
    dispatchEvent('Socket client must be removed', this);
    channel.sink.close();
  }

  void write(String message, [Map details]) {
    Map detail = details;
    if (detail == null) {
      detail = new Map();
    }
    detail['Message'] = message;
    channel.sink.add(JSON.encode(detail));
  }
}
