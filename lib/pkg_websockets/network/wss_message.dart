//
// Created by sh1l0n
// Copyright Author 2021 All rights reserved.
//

import 'dart:convert';

import 'package:flutter/foundation.dart';

class WssClientMessage {
  const WssClientMessage({@required this.event, @required this.topic, @required this.data});

  final String event;
  final String topic;
  final Map<String, dynamic> data;

  // Message keys
  static final String eventKey = 'event';
  static final String topicKey = 'topic';
  static final String dataKey = 'data';

  // Data params
  static final String errorKey = 'error';
  static final String statusKey = 'status';
  static final String messageKey = 'msg';

  // Status message types
  static final String statusStartKey = 'start';
  static final String statusStopKey = 'stop';
  static final String statusCheckKey = 'check';

  static WssClientMessage fromString(String message) {
    String event = '';
    String topic = '';
    Map<String, dynamic> data = {};
    try {
      final Map<String, dynamic> wsmessage = jsonDecode(message);
      if (wsmessage.containsKey(eventKey)) {
        event = wsmessage[eventKey];
      }
      if (wsmessage.containsKey(topicKey)) {
        topic = wsmessage[topicKey];
      }
      if (wsmessage.containsKey(dataKey)) {
        data = wsmessage[dataKey];
      }
    } catch (e) {}
    return WssClientMessage(event: event, topic: topic, data: data);
  }

  String get dumps {
    try {
      return jsonEncode({eventKey: event, topicKey: topic, dataKey: data});
    } catch (e) {
      return "{}";
    }
  }

  bool get isEmpty => event == "" && topic == "" && data.isEmpty;
  bool get hasError => data.isNotEmpty && data.containsKey(errorKey) && data[errorKey];
  int get status => data.isNotEmpty && data.containsKey(statusKey) ? data[statusKey] : statusStopKey;
  String get message => data.isNotEmpty && data.containsKey(messageKey) ? data[messageKey] : "";
}
