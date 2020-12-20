import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

enum ChatMode { public, private }

class PublicChatMessage {
  final String username;
  final String message;
  final Color color;
  final String fontFamily;
  final FontSize fontSize;
  final bool bold;
  final bool italics;

  PublicChatMessage({this.username, this.message, this.color, this.fontFamily = "Verdana", this.fontSize = FontSize.small, this.bold = false, this.italics = false});
}

class ChatMessagesList extends StatefulWidget {
  ChatMessagesList({Key key, @required this.chatMode}) : super(key: key);

  final ChatMode chatMode;

  ChatMessagesListState createState() => ChatMessagesListState(key: key);
}

class ChatMessagesListState extends State<ChatMessagesList> {
  ChatMessagesListState({Key key});
  List<PublicChatMessage> publicChatMessages = new List<PublicChatMessage>();
  ScrollController _scrollController = new ScrollController();

  addPublicMessage(String username, String message, Color color) {
    setState(() {
      publicChatMessages.add(new PublicChatMessage(username: username, message: message, color: color));
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.chatMode == ChatMode.public)
      for (int i = 0; i < DataMocker.chatWelcomeMessages.length; i++) {
        publicChatMessages.add(new PublicChatMessage(username: "", message: DataMocker.chatWelcomeMessages[i], color: Colors.black));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: publicChatMessages.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
            color: index % 2 == 0 ? Colors.white : Colors.cyan[50],
            padding: EdgeInsets.symmetric(vertical: 3),
            child: _htmlMessageBuilder(publicChatMessages[index]),
          );
        },
      ),
    );
  }

  _htmlMessageBuilder(PublicChatMessage msg) {
    var htmlData = msg.username != ""
        ? """
          <span style='font-weight: bold'>
            ${msg.username + (msg.username == "" ? "" : ": ")}
          </span>
          <span style='color: ${msg.color}; font-weight: normal'>
            ${msg.message}
          </span>
          """
        : """
          <span style='font-weight: normal'>
            ${msg.message}
          </span>
         """;

    return Html(
      data: htmlData,
      style: {
        "span": msg.username != ""
            ? Style(
                color: msg.color,
                fontFamily: msg.fontFamily,
                fontWeight: msg.bold ? FontWeight.bold : FontWeight.normal,
                fontSize: msg.fontSize,
              )
            : Style(
                color: msg.color,
              ),
      },
      onLinkTap: (url) async {
        print("Open $url");
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      onImageTap: (src) {
        print(src);
      },
      onImageError: (exception, stackTrace) {
        print(exception);
      },
    );
  }
}
