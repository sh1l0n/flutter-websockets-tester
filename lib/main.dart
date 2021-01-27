//
// Created by sh1l0n
// Copyright Author 2021 All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_network/pkg_websockets/widget/wss_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebSocket app',
      home: MyHomePage(title: 'Flutter WebSocket app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WssWidget(),
      ),
    );
  }
}
