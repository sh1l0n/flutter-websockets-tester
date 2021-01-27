//
// Created by sh1l0n
// Copyright Author 2021 All rights reserved.
//

import 'dart:async';

import 'package:web_socket_channel/html.dart';
// import 'dart:html' show Event, MessageEvent, CloseEvent, WebSocket;

import 'wss_bloc.dart';
import 'wss_message.dart';

class WssClient extends WssClientBLoC {
  // WebSocket _webSocket;
  HtmlWebSocketChannel _websocket;
  bool _isConnected = false;
  String _url = "";
  final StreamController<WssClientMessage> _messageHandlingController = StreamController<WssClientMessage>.broadcast();
  Sink<WssClientMessage> get _sink => _messageHandlingController.sink;

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

  void _onMessage(WssClientMessage message) {
    if (message.event == 'connection' && message.topic == WssClientMessage.statusKey && message.data.containsKey('readyState') && message.data['readyState']) {
      _isConnected = true;
    } else if (message.event == 'subscribe') {
      print("subscribe");
    } else if (message.event == 'unsubscribe') {
      print("unsubscribe");
    }
  }

  @override
  connect(final String host, final String port) {
    if (isConnected) {
      disconnect();
    }

    final url = Uri.parse("ws://" + host + ":" + port);
    _websocket = HtmlWebSocketChannel.connect(url);
    _websocket.sink.done.then((value) {
      _isConnected = false;
      print("[+] Close websocket");
    });

    _websocket.stream.listen((event) {
      final message = WssClientMessage.fromString(event.toString());
      print('[+] Received ${message.dumps}');
      _onMessage(message);
    });
    // sleep(Duration(seconds: 20));
    return isConnected;
  }

  @override
  bool disconnect() {
    if (isConnected) {
      _isConnected = false;
      _url = "";
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
  void send(final WssClientMessage message) {
    if (isConnected) {
      _websocket.sink.add(message.dumps);
      // _webSocket.send(message.dumps);
    }
  }

  @override
  Stream<WssClientMessage> get stream => _messageHandlingController.stream;

  @override
  void dispose() {
    _messageHandlingController.close();
    disconnect();
  }
}
