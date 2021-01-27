//
// Created by sh1l0n
// Copyright Author 2021 All rights reserved.
//

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../network/wss_client.dart';

class WssWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WssWidgetState();
}

class _WssWidgetState extends State<WssWidget> {
  // final _websocket = WssClient();

  @override
  void initState() {
    super.initState();
    // _websocket.stream.listen((WssClientMessage message) {
    //   print('[+] Received message : ${message.dumps}');
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // if (_websocket != null) {
    //   _websocket.dispose();
    // }
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
      //onChanged: onChanged,
    );
  }

  Widget _buildConnectForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final connectText = 'Connect';
    final disconnectText = 'Disconnect';
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
              child: _buildTextFieldForm(hintText, (){}),
            ),
            Container(width: 5),
            _buildFlatButton(connectText, (){}, Colors.lightGreen),
            Container(width: 5),
            _buildFlatButton(disconnectText, (){}, Colors.amberAccent),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTextFieldForm(hintText, (){}),
            Container(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFlatButton(disconnectText, (){}, Colors.amberAccent),
                _buildFlatButton(connectText, (){}, Colors.lightGreen),
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
          child: Text("asdasd\n\n\n\n\n\n\n\n\n\n\n\ewen\n\n\n\n\n\n\n\qn\n\n\n\n\n\n\n\n\n\n\n\n\a\na\na\na\na\na\na\na\na\n\n\n\n\n\n\n\n\n\n\nvi\n\n\n\n\n\n\n\n\nii\n\n\n\n\n\n\n\n\n\ni\n"),
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
            child: _buildTextFieldForm(hintText, (){}),
          ),
          Container(width: 5),
          _buildFlatButton(sendText, (){}, Colors.lightGreen),
        ],
      ),
    );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTextFieldForm(hintText, (){}),
            Container(height: 5),
            _buildFlatButton(sendText, (){}, Colors.lightGreen),
          ],
        ),
      );
    } 
  }
}
