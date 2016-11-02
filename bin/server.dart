library server;

import 'package:whisper/whisper.dart' show Engine;

main() async {
  Engine engine = new Engine();
  await engine.setUpMicroservices();

  engine
    ..powerUpSockets()
    ..serveAssets(port:8000);
}
