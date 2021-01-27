//
// Created by sh1l0n
// Copyright Author 2021 All rights reserved.
//

import 'dart:async';

import 'package:web_socket_channel/html.dart';

import 'wss_bloc.dart';
// import 'dart:html' show Event, MessageEvent, CloseEvent, WebSocket;


class WssClient extends WssClientBLoC {
  // WebSocket _webSocket;
  HtmlWebSocketChannel _websocket;
  bool _isConnected = false;
  String _url = "";
  final StreamController<String> _messageHandlingController = StreamController<String>.broadcast();
  Sink<String> get _sink => _messageHandlingController.sink;

  // void sleep(Duration duration) {
  //   var ms = duration.inMilliseconds;
  //   var start = new DateTime.now().millisecondsSinceEpoch;
  //   while (true) {
  //     var current = new DateTime.now().millisecondsSinceEpoch;
  //     if (current - start >= ms) {
  //       break;
  //     }
  //   }
  // }

  void _onMessage(String message) {
    // print("_onMessage $message");
    _sink.add(message);
  }

  @override
  void connect(final String host) {
    if (isConnected) {
      disconnect();
    }

    try {
      final url = Uri.parse(host);
      _websocket = HtmlWebSocketChannel.connect(url);
      _websocket.sink.done.then((value) {
        _isConnected = false;
        _sink.add('Closed by server');
      });

      _websocket.stream.listen((message) {
        _isConnected = true;
        _onMessage(message);
      });
    } catch(e) {
      _sink.add('Cannot connect to $host');
      _isConnected = false;
    }
  }

  @override
  bool disconnect() {
    if (isConnected) {
      _isConnected = false;
      _url = "";
      _sink.add('Closed by client');
      _websocket.sink.close(1000, 'Closed by client');
      _websocket = null;
    }
    return !_isConnected;
  }

  @override
  bool get isConnected => _isConnected;
  // _websocket!=null && _websocket.sink.done.
  //_webSocket != null && _webSocket.readyState == WebSocket.OPEN;

  @override
  String get url => _url;

  @override
  void send(final String message) {
    if (isConnected) {
      _websocket.sink.add(message);
      // _webSocket.send(message.dumps);
    }
  }

  @override
  Stream<String> get stream => _messageHandlingController.stream;

  @override
  void dispose() {
    _messageHandlingController.close();
    disconnect();
  }
}
