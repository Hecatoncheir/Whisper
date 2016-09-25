![Whisper logotype](https://raw.githubusercontent.com/Rasarts/Whisper/master/web/assets/logotype/whisper_logotype_black.png)
================
#### Engine of real time content management

[![Build Status](https://img.shields.io/travis/Rasarts/Whisper/master.svg?style=flat-square)](https://travis-ci.org/Rasarts/Whisper) [![codecov](https://img.shields.io/codecov/c/github/Rasarts/Whisper/master.svg?style=flat-square)](https://codecov.io/gh/Rasarts/Whisper) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://raw.githubusercontent.com/Rasarts/Whisper/master/LICENSE)

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
