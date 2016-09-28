@TestOn('vm')
library http_test;

import 'dart:io';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:whisper/engine/engine.dart';

main() {
  group('Http server', () {
    Engine engine = new Engine();

    test('can be started', () async {
      await engine.serveAssets();
      expect(engine.status, equals('Http server online'));
    });
    test('can serve main html file', () async {
      HttpClient httpClient;
      HttpClientRequest httpClientRequest;
      HttpClientResponse httpClientResponse;

      await engine.serveAssets(
          ip: 'localhost',
          port: 8080,
          dirPath: 'test/engine/http/',
          mainHtmlFile: 'http_test_asset.html');

      httpClient = new HttpClient();
      httpClientRequest =
          await httpClient.get('localhost', 8080, '/http_test_asset.html');
      httpClientResponse = await httpClientRequest.close();

      expect(httpClientResponse.statusCode, equals(200));

      httpClientResponse
          .transform(UTF8.decoder)
          .listen(expectAsync((String htmlContent) {
        expect(htmlContent.contains('http_test_asset'), isTrue);
        expect(htmlContent, isNotEmpty);
      }));
    });
  });
}
