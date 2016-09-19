library server;

import 'package:whisper/engine.dart';

main() async {
  new Engine()
    ..powerUpSockets()
    ..serveAssets(port: 3000, dirPath: 'web');
}
