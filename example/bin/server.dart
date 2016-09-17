library server;

import 'package:whisper/engine.dart';

main() async {
  new Engine()
    ..powerUpSockets()
    ..serveAssets(dirPath: 'example/web', mainHtmlFile: 'example.html');
}
