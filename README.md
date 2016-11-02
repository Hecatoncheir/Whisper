![Whisper logotype](https://raw.githubusercontent.com/Rasarts/Whisper/master/web/assets/logotype/whisper_logotype_black.png)
================
#### Engine of real time content management

[![Build Status](https://img.shields.io/travis/Rasarts/Whisper/master.svg?style=flat-square)](https://travis-ci.org/Rasarts/Whisper) [![GitHub issues](https://img.shields.io/github/issues/Rasarts/Whisper.svg?style=flat-square)](https://github.com/Rasarts/Whisper/issues) [![codecov](https://img.shields.io/codecov/c/github/Rasarts/Whisper/master.svg?style=flat-square)](https://codecov.io/gh/Rasarts/Whisper)

<br>
For start up engine just import 'engine' library:

```dart

import 'package:whisper/engine.dart';

main() async {
  new Engine()
    ..powerUpSockets()
    ..serveAssets();
}

```

<br>
With microservices

```dart
library server;

import 'package:whisper/whisper.dart' show Engine;

main() async {
  Engine engine = new Engine();
  await engine.setUpMicroservices();

  engine
    ..powerUpSockets()
    ..serveAssets(port:8000);
}

```

[![GitHub stars](https://img.shields.io/github/stars/Rasarts/Whisper.svg?style=flat-square)](https://github.com/Rasarts/Whisper/stargazers) [![GitHub forks](https://img.shields.io/github/forks/Rasarts/Whisper.svg?style=flat-square)](https://github.com/Rasarts/Whisper/network) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://raw.githubusercontent.com/Rasarts/Whisper/master/LICENSE)
