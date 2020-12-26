import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/apps/chat/chat_controller.dart';
import 'package:zoo_flutter/apps/chat/chat_emoticons_layer.dart';

enum ChatMode { public, private }

class ChatMessage {
  final String username;
  final ChatInfo chatInfo;

  ChatMessage({this.username, this.chatInfo});
}

class ChatMessagesList extends StatefulWidget {
  ChatMessagesList({Key key, @required this.chatMode}) : super(key: key);

  final ChatMode chatMode;

  ChatMessagesListState createState() => ChatMessagesListState(key: key);
}

class ChatMessagesListState extends State<ChatMessagesList> {
  final int _buffer = 100;
  ChatMessagesListState({Key key});
  List<ChatMessage> chatListMessages = [];
  ScrollController _scrollController = new ScrollController();

  addMessage(String username, ChatInfo chatInfo) {
    var formatedMsg = _replaceWithEmoticons(chatInfo.msg);
    chatInfo.msg = formatedMsg;
    setState(() {
      chatListMessages
          .add(new ChatMessage(username: username, chatInfo: chatInfo));

      if (chatListMessages.length > _buffer) {
        chatListMessages =
            chatListMessages.skip(chatListMessages.length - _buffer).toList();
      }

      Future.delayed(
          const Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    });
  }

  _replaceWithEmoticons(String message) {
    var msg = message;
    ChatEmoticonsLayer.emoticons.forEach((emoItem) {
      for (var i = 0; i < emoItem["keys"].length; i++) {
        var key = emoItem["keys"][i];
        var code = emoItem["code"];
        msg = msg.replaceAll(
            key, "<img src='${ChatEmoticonsLayer.getEmoPath(code)}'></img>");
      }
    });

    return msg;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: chatListMessages.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
            color: index % 2 == 0 ? Colors.white : Colors.cyan[50],
            padding: EdgeInsets.symmetric(vertical: 3),
            child: _htmlMessageBuilder(chatListMessages[index]),
          );
        },
      ),
    );
  }

  _htmlMessageBuilder(ChatMessage msg) {
    var htmlData = msg.username != ""
        ? """
          <span>
            <b>${msg.username}</b> ${(msg.username == "" ? "" : ": ")}
          </span>
          <span style='color: ${msg.chatInfo.colour}; font-weight: normal'>
            ${msg.chatInfo.msg}
          </span>
          """
        : """
          <span style='font-weight: normal'>
            ${msg.chatInfo.msg}
          </span>
         """;

    return Html(
      data: htmlData,
      style: {
        "span": msg.username != ""
            ? Style(
                color: msg.chatInfo.colour,
                fontFamily: msg.chatInfo.fontFace,
                fontWeight:
                    msg.chatInfo.bold ? FontWeight.bold : FontWeight.normal,
                fontSize: FontSize(msg.chatInfo.fontSize?.toDouble()),
                fontStyle:
                    msg.chatInfo.italic ? FontStyle.italic : FontStyle.normal,
              )
            : Style(
                color: msg.chatInfo.colour,
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
