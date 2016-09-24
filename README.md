[![Whisper logotype](https://raw.githubusercontent.com/Rasarts/Whisper/master/web/assets/logotype/whisper_logotype_red.png)](https://travis-ci.org/Rasarts/Whisper)
================
Engine of real time content management

[![Build Status](https://img.shields.io/travis/Rasarts/Whisper/master.svg?style=flat-square)](https://travis-ci.org/Rasarts/Whisper) [![WIP](https://img.shields.io/badge/Work%20in%20progress-4%25-red.svg?style=flat-square)](https://github.com/Rasarts/Whisper) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://raw.githubusercontent.com/Rasarts/Whisper/master/LICENSE)

For start up engine just import 'engine' library:

```dart

import 'package:whisper/engine.dart';

main() async {
  new Engine()
    ..powerUpSockets()
    ..serveAssets();
}

```