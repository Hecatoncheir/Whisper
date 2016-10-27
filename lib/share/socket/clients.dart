part of socket_server;

class SocketClient extends Object
    with NotifyMixin, ObservableMixin, SubscriptionMixin {
  IOWebSocketChannel channel;
  String identificator;

  SocketClient(WebSocket client) {
    channel = new IOWebSocketChannel(client);
    identificator = new Uuid().v4();

    channel.stream
        .listen(messageHandler, onError: errorHandler, onDone: finishedHandler);
  }

  messageHandler(String data) async {
    Map detailsFromClient = JSON.decode(data);
    detailsFromClient['ClientIdentificator'] = identificator;
    dispatchEvent(detailsFromClient['Message'], detailsFromClient);
  }

  void errorHandler(error) {
    dispatchEvent('SocketClientMustBeRemoved', this);
    channel.sink.close();
  }

  void finishedHandler() {
    dispatchEvent('SocketClientMustBeRemoved', this);
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
