// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ForumBodyFrame extends StatefulWidget {
  final String itemId;
  final String body;

  ForumBodyFrame({Key key, this.itemId, this.body}) : super(key: key);

  @override
  ForumBodyFrameState createState() => ForumBodyFrameState();
}

class ForumBodyFrameState extends State<ForumBodyFrame> {
  Widget _bodyFrameWidget;
  html.IFrameElement _bodyFrameElement = html.IFrameElement();

  ForumBodyFrameState();

  String _parseHtmlString(String htmlString) {
    String input = htmlString;
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    // input = input.replaceAll('<TEXTFORMAT LEADING="2">', "").replaceAll("</TEXTFORMAT>", "");
    input = input.replaceAll(exp, '');
    print('============================================ ');
    print(input);
    print('============================================ ');

    return input;
  }

  @override
  void initState() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory('gameIframeElement' + widget.itemId.toString(), (int viewId) => _bodyFrameElement);
    _bodyFrameWidget = HtmlElementView(key: UniqueKey(), viewType: 'gameIframeElement' + widget.itemId.toString());
    _bodyFrameElement.srcdoc =
        "<p style='font-size:14px; font-family:Verdana'>" + _parseHtmlString(widget.body) + "</p>";

    _bodyFrameElement.style.border = "none";
    _bodyFrameElement.style.padding = "0";
    _bodyFrameElement.style.backgroundColor = "#ffffff";
    _bodyFrameElement.style.alignContent = "center";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _bodyFrameWidget;
  }
}
