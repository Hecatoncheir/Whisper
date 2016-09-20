@HtmlImport('administration_section_theme.html')
@HtmlImport('administration_section.html')
library administration_section;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:web_socket_channel/html.dart';

import 'package:whisper/components/online_clients/online_clients.dart';

@PolymerRegister('administration-section')
class AdministrationSection extends PolymerElement {
  @Property(reflectToAttribute: true, observer: 'socketMessageChanged')
  String message;

  @Property(reflectToAttribute: true)
  Map details;

  @Property(reflectToAttribute: true)
  HtmlWebSocketChannel socket;

  AdministrationSection.created() : super.created();

  @reflectable
  socketMessageChanged(String newMessage, [_]) {
    if (newMessage == null) return;

    if (newMessage == 'Client connected' ||
        newMessage == 'Client disconnected') {
      set('onlineClients', details['Online clients']);
    }
  }
}
