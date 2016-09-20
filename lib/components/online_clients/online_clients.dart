@HtmlImport('online_clients_theme.html')
@HtmlImport('online_clients.html')
library online_clients;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('online-clients')
class OnlineClients extends PolymerElement {
  @Property(reflectToAttribute: true)
  int clients;

  OnlineClients.created() : super.created();
}
