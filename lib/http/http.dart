library http_server;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mime;

class ServerEngineMixin {
  io.HttpServer httpServer;
  String status;

  serveAssets(
      {String ip, int port, String dirPath, String mainHtmlFile}) async {
    if (ip == null) ip = io.InternetAddress.LOOPBACK_IP_V4.host;
    if (port == null) port = 8080;
    if (dirPath == null) dirPath = 'build/web/';
    if (mainHtmlFile == null) mainHtmlFile = 'index.html';
    httpServer = await io.HttpServer.bind(ip, port, shared: true);
    _requestslistener(httpServer, dirPath: dirPath, mainHtmlFile: mainHtmlFile);
    status = 'Http server online';
    print('Http on: http://$ip:$port');
  }
}

_requestslistener(io.HttpServer server,
    {String dirPath, String mainHtmlFile}) async {
  await for (io.HttpRequest request in server) {
    String iri = request.uri.toFilePath() == '/'
        ? '$mainHtmlFile'
        : request.uri.path.replaceFirst('/', '');

    final io.File file = new io.File(path.join(dirPath, iri));

    if (await file.exists()) {
      String mimeType = mime.lookupMimeType(file.path);
      request.response.headers.set(io.HttpHeaders.CONTENT_TYPE, mimeType);
      file.openRead().pipe(request.response);
    } else {
      request.response.statusCode = io.HttpStatus.NOT_FOUND;
      request.response.close();
    }
  }
}
