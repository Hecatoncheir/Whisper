library server;

import 'package:whisper/engine.dart';

main() async {
  new Engine()
    ..powerUpSockets()
    ..serveAssets(dirPath: 'web', mainHtmlFile: 'example.html');
}
