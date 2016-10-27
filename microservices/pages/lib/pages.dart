library pages;

import 'package:avalanche_events/avalanche_events.dart';

import 'src/page.dart';
import 'src/socket/socket.dart';
import 'src/database/database.dart';

part 'src/handlers.dart';

class Pages extends Object
    with
        DataBaseMixin,
        HandlersMixin,
        NotifyMixin,
        ObservableMixin,
        SubscriptionMixin {
  PagesSocket socket;

  Pages() {
    prepareEventsHandlers();

    socket = new PagesSocket();
    socket.observable(this);
    this.observable(socket);
  }
}
