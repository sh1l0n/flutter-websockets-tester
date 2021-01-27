//
// Created by sh1l0n
// Copyright Author 2021 All rights reserved.
//

abstract class BLoC {
  void dispose();
}

abstract class WssClientBLoC implements BLoC {
  bool connect(final String host) => false;
  bool disconnect() => false;
  bool get isConnected => false;
  String get url => "";

  void send(final String message);
  Stream<String> get stream => null;
}
