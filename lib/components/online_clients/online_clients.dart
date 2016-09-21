@HtmlImport('online_clients_theme.html')
@HtmlImport('online_clients.html')
library online_clients;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('online-clients')
class OnlineClients extends PolymerElement {
  @Property(reflectToAttribute: true)
  String message;

  @Property(reflectToAttribute: true)
  Map details;

  @Property(reflectToAttribute: true, observer: 'clientsCountChanged')
  int clientsCount;

  OnlineClients.created() : super.created();

  @reflectable
  clientsCountChanged(int clientsCount, [_]) {
    details['OnlineClients'] = clientsCount;
    set('details.OnlineClients', clientsCount);
  }
}
