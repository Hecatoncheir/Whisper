@HtmlImport('administration_section_theme.html')
@HtmlImport('administration_section.html')
library administration_section;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:web_socket_channel/html.dart';

import 'package:whisper/src/components/online_clients/online_clients.dart';

@PolymerRegister('administration-section')
class AdministrationSection extends PolymerElement {
  @Property(reflectToAttribute: true)
  String message;

  @Property(reflectToAttribute: true)
  Map details;

  @Property(reflectToAttribute: true)
  HtmlWebSocketChannel socket;

  AdministrationSection.created() : super.created();
}
