library server;

import 'package:whisper/whisper.dart' show Engine;

main() async {
  new Engine()
    ..powerUpSockets()
    ..serveAssets(port: 3000, dirPath: 'web');
}
