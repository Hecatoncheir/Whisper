Whisper
================
Engine of real time content management

[![Build Status](https://travis-ci.org/Rasarts/Whisper.svg?branch=master)](https://travis-ci.org/Rasarts/Whisper) [![WIP](https://img.shields.io/badge/Work%20in%20progress-4%25-red.svg?style=flat)](https://github.com/Rasarts/Whisper) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/Rasarts/Whisper/master/LICENSE)

See example and tests.

For start up engine just import 'engine' library:

```dart

import 'package:whisper/engine.dart';

main() async {
  new Engine()
    ..powerUpSockets()
    ..serveAssets();
}

```