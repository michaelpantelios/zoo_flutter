import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_html_css/simple_html_css.dart';
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
  final ChatMode chatMode;
  final Function(String username) onUserMessageClicked;

  ChatMessagesList({Key key, @required this.chatMode, this.onUserMessageClicked}) : super(key: key);

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
      chatListMessages.add(new ChatMessage(username: username, chatInfo: chatInfo));

      if (chatListMessages.length > _buffer) {
        chatListMessages = chatListMessages.skip(chatListMessages.length - _buffer).toList();
      }

      Future.delayed(const Duration(milliseconds: 300), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    });
  }

  _replaceWithEmoticons(String message) {
    var msg = message;
    int indexFound = -1;
    List<dynamic> eligibleEmos = [];
    ChatEmoticonsLayer.emoticons.forEach((emoItem) {
      for (var i = 0; i < emoItem["keys"].length; i++) {
        var key = emoItem["keys"][i];
        var code = emoItem["code"];
        indexFound = msg.indexOf(key);
        if (indexFound != -1) {
          eligibleEmos.add({"index": indexFound.toString(), "key": key, "code": ChatEmoticonsLayer.getEmoPath(code)});
        }
      }
    });

    if (eligibleEmos.length > 0) {
      var msgLen = msg.length;
      var max = -1;
      String wantedKey = "";
      String wantedEmoPath = "";
      for (var i = 0; i < msgLen; i++) {
        max = -1;
        wantedKey = "";
        wantedEmoPath = "";
        for (dynamic item in eligibleEmos) {
          if (item["index"].toString() == i.toString()) {
            if (item["key"].length > max) {
              max = item["key"].length;
              wantedKey = item["key"];
              wantedEmoPath = item["code"];
            }
          }
        }
        if (wantedKey != "") msg = msg.replaceAll(wantedKey, "<img src='${wantedEmoPath}'></img>");
      }
    }

    return msg;
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

  _onMessageClicked(String username) {
    if (username.trim().isEmpty) return;
    print("show user: ${username}");
    widget.onUserMessageClicked(username);
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

    return GestureDetector(
      onTap: () => _onMessageClicked(msg.username),
      child: HTML.toRichText(
        context,
        htmlData,
        overrideStyle: {
          "span": msg.username != ""
              ? TextStyle(
                  color: msg.chatInfo.colour,
                  fontFamily: msg.chatInfo.fontFace,
                  fontWeight: msg.chatInfo.bold ? FontWeight.bold : FontWeight.normal,
                  fontSize: msg.chatInfo.fontSize?.toDouble(),
                  fontStyle: msg.chatInfo.italic ? FontStyle.italic : FontStyle.normal,
                )
              : TextStyle(
                  color: msg.chatInfo.colour,
                ),
        },
        linksCallback: (url) async {
          print("Open $url");
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
  }
}
