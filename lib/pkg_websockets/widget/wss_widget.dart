//
// Created by sh1l0n
// Copyright Author 2021 All rights reserved.
//

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../network/wss_client.dart';

class WssWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WssWidgetState();
}

class _WssWidgetState extends State<WssWidget> {
  final _websocket = WssClient();

  final StreamController<bool> _loggingController = StreamController<bool>.broadcast();
  Sink<bool> get _loggingSink => _loggingController.sink;
  Stream<bool> get _loggingStream => _loggingController.stream;

  String _url;
  String _command;
  String _logs;

  @override
  void initState() {
    super.initState();
    _url = '';
    _logs = '';
    _command = '';
    _websocket.stream.listen((String message) {
      _logs += '< ' + message + "\n";
      _loggingSink.add(true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_websocket != null) {
      _websocket.dispose();
    }
    _loggingController.close();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = const TextStyle(color: Color(0xff000000), fontFamily: "Lucida Console", fontSize: 32, fontWeight: FontWeight.bold, package: '');
    final subtitleStyle = const TextStyle(color: Color(0xff000000), fontFamily: "Lucida Console", fontSize: 18, fontWeight: FontWeight.normal, package: '');
    final footerStyle = const TextStyle(color: Color(0xff000000), fontFamily: "Lucida Console", fontSize: 10, fontWeight: FontWeight.bold, package: '');
    
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.black12,
      child: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.start,
          primary: true,
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildMainText("Welcome to web socket tester", titleStyle),
                  _buildMainText("Introduce your url and connect", subtitleStyle),
                  _buildConnectForm(context),
                  _buildLoggingArea(context),
                  _buildMainText("Send custom commands", subtitleStyle),
                  _buildCommandForm(context),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text("Created by sh1l0n", style: footerStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainText(final String text, final TextStyle textStyle) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Text(
          text, 
          style: textStyle
        ),
      ),
    );
  }

  Widget _buildFlatButton(final String text, final Function onPressed, final Color color) {
    return FlatButton(
      autofocus: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      onPressed: onPressed, 
      color: color,
      child: Text(text),
    );
  }

  Widget _buildTextFieldForm(final String hintText, final Function onChanged) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white70,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 1,
          )
        )
      ),
      autocorrect: false,
      maxLines: 1,
      cursorColor: Colors.black,
      onChanged: onChanged,
    );
  }

  Widget _buildConnectForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final connectText = 'Connect';
    final disconnectText = 'Disconnect';
    final clearText = 'Clear logs';
    final hintText = 'Ex.: wss://127.0.0.1:1234';
    final isOnSmallScreen = size.width<600;

    if (!isOnSmallScreen) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.6, 
              child: _buildTextFieldForm(hintText, (final String onChanged){
                _url = onChanged;
              }),
            ),
            Container(width: 5),
            _buildFlatButton(connectText, (){
              _websocket.connect(_url);
            }, Colors.lightGreen),
            Container(width: 5),
            _buildFlatButton(disconnectText, (){
              _websocket.disconnect();
            }, Colors.amberAccent),
            Container(width: 5),
            _buildFlatButton(clearText, (){
              _logs = '';
              _loggingSink.add(true);
            }, Colors.orangeAccent),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTextFieldForm(hintText, (final String onChanged){
              _url = onChanged;
            }),
            Container(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFlatButton(disconnectText, (){
                  _websocket.connect(_url);
                }, Colors.amberAccent),
                _buildFlatButton(clearText, (){
                  _logs = '';
                  _loggingSink.add(true);
                }, Colors.orangeAccent),
                _buildFlatButton(connectText, (){
                  _websocket.disconnect();
                }, Colors.lightGreen),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildLoggingArea(BuildContext context) {
    return Container(
      height: 400,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1
        )
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          // controller: ScrollController(),
          dragStartBehavior: DragStartBehavior.start,
          primary: true,
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: StreamBuilder(
            initialData: true,
            stream: _loggingStream,
            builder: (BuildContext c, AsyncSnapshot<bool> a) {
              print('[+] Received message : $_logs');
              return Text(_logs);
            },
          ),
        ),
      )
    );
  }

  Widget _buildCommandForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hintText = 'Ex.: {"event":"subscribe","topic":"me"}"';
    final sendText = 'Send';
    final isOnSmallScreen = size.width<600;

    if (!isOnSmallScreen) {
      return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.75, 
            child: _buildTextFieldForm(hintText, (final String onChanged){
              _command = onChanged;
            }),
          ),
          Container(width: 5),
          _buildFlatButton(sendText, (){
            _logs += '> ' + _command + "\n";
            _loggingSink.add(true);
            _websocket.send(_command);
          }, Colors.lightGreen),
        ],
      ),
    );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTextFieldForm(hintText, (final String onChanged){
              _command = onChanged;
            }),
            Container(height: 5),
            _buildFlatButton(sendText, (){
              _logs += '> ' + _command + "\n";
              _loggingSink.add(true);
              _websocket.send(_command);
            }, Colors.lightGreen),
          ],
        ),
      );
    } 
  }
}
