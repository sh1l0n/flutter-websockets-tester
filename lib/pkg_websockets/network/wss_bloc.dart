//
// Created by sh1l0n
// Copyright Author 2021 All rights reserved.
//

import 'wss_message.dart';

abstract class BLoC {
  void dispose();
}

abstract class WssClientBLoC implements BLoC {
  bool connect(final String host, final String port) => false;
  bool disconnect() => false;
  bool get isConnected => false;
  String get url => "";

  void send(final WssClientMessage message);
  Stream<WssClientMessage> get stream => null;
}
