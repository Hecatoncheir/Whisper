library socket_server;

import 'dart:io';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:avalanche_events/avalanche_events.dart';

part 'clients.dart';
part 'listeners.dart';

class SocketEngine extends Object
    with NotifyMixin, ObservableMixin, EventsListeners {
  HttpServer httpServer;
  List<SocketClient> clients;

  SocketEngine();

  addClient(WebSocket socketClient) async {
    SocketClient client = new SocketClient(socketClient);
    client.observable(this);
    clients.add(client);
    dispatchEvent('SocketClientMustBeRegistered', client);
  }

  removeClient(SocketClient socketClient) async {
    clients.remove(socketClient);
  }

  writeToAllClients(String message, {Map details, SocketClient from}) async {
    clients.forEach((SocketClient client) async {
      if (client == from) return;
      client.write(message, details);
    });
  }

  _handleWebSocket(WebSocket socket) async {
    addClient(socket);
  }

  _serveRequest(HttpRequest request) async {
    request.response.statusCode = HttpStatus.FORBIDDEN;
    request.response.reasonPhrase = "WebSocket connections only";
    request.response.close();
  }

  powerUp({String ip, int port}) async {
    prepareEventsListeners();
    if (clients == null) clients = new List<SocketClient>();
    if (ip == null) ip = InternetAddress.LOOPBACK_IP_V4.host;
    if (port == null) port = 8181;

    httpServer = await HttpServer.bind(ip, port, shared: true);
    print('Socket listen on: http://$ip:$port');

    httpServer.listen((HttpRequest request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        _handleWebSocket(socket);
      } else {
        print("Regular ${request.method} request for: ${request.uri.path}");
        _serveRequest(request);
      }
    });
  }
}
