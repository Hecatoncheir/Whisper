library socket_connect;

import 'dart:convert';
import 'package:web_socket_channel/html.dart';

import 'package:polymer/polymer.dart';

@PolymerRegister('socket-connect')
class SocketConnect extends PolymerElement {
  @Property(
      reflectToAttribute: true,
      notify: true,
      observer: 'socketServerIriChanged')
  String socketServerIri;

  @Property(reflectToAttribute: true, notify: true)
  HtmlWebSocketChannel socket;

  @Property(reflectToAttribute: true, notify: true)
  String message;

  @Property(reflectToAttribute: true, notify: true)
  Map details;

  @Property(observer: 'socketDataChanged')
  Map socketData;

  SocketConnect.created() : super.created();

  @reflectable
  socketDataChanged(Map newData, [_]) async {
    Map details = new Map.from(newData);
    details.remove('Message');

    set('details', details);
    set('message', null);
    set('message', newData['Message']);
  }

  @reflectable
  socketServerIriChanged(String newSocketServerIri, [_]) async {
    socket = new HtmlWebSocketChannel.connect(newSocketServerIri);
    set('socket', socket);

    socket.stream.listen((String dataFromSocket) {
      set('socketData', JSON.decode(dataFromSocket));
    });
  }
}
