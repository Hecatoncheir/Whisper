library engine;

import 'http/http.dart';
import 'socket/socket.dart';

import 'package:whisper/microservices/pages/pages.dart' as PagesService;

class Engine extends Object with EngineMixin {
  SocketEngine socket;
  PagesService.Pages pages;

  Engine() {
    socket = new SocketEngine();
    pages = new PagesService.Pages();
  }

  powerUpSockets({String ip, int port}) {
    socket.powerUp();
    pages.socket.powerUp();
  }
}
