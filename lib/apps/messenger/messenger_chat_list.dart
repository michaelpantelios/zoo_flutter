import 'dart:html';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/apps/chat/chat_emoticons_layer.dart';
import 'package:zoo_flutter/js/zoo_lib.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class MessengerMsg {
  final Map<String, dynamic> from;
  String text;
  final int colour;
  final String fontFace;
  final int fontSize;
  final bool bold;
  final bool italic;
  final int dateMillis; //millis from epoch

  MessengerMsg({this.from, this.text, this.dateMillis, this.colour, this.fontFace, this.fontSize, this.bold, this.italic});

  @override
  String toString() {
    return "from: ${from['username']}, ${from['mainPhoto']}, ${from['sex']}, text: $text, dateMillis: $dateMillis, colour: $colour, fontFace: $fontFace, fontSize: $fontSize, bold: $bold, italic: $italic";
  }

  factory MessengerMsg.fromJSON(dynamic data) {
    return MessengerMsg(
      from: data["from"],
      text: data["text"],
      dateMillis: data["dateMillis"],
      colour: int.parse(data["colour"].toString()),
      fontFace: data["fontFace"],
      fontSize: int.parse(data["fontSize"].toString()),
      bold: data["bold"] is bool ? data["bold"] : int.parse(data["bold"].toString()) == 1,
      italic: data["italic"] is bool ? data["italic"] : int.parse(data["italic"].toString()) == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'from': this.from,
        'text': this.text,
        'dateMillis' : this.dateMillis,
        'colour': this.colour,
        'fontFace': this.fontFace,
        'fontSize': this.fontSize,
        'bold': this.bold,
        'italic': this.italic,
      };
}

class MessengerChatList extends StatefulWidget {
  MessengerChatList({Key key}) : super(key: key);

  MessengerChatListState createState() => MessengerChatListState(key: key);
}

class MessengerChatListState extends State<MessengerChatList> {
  MessengerChatListState({Key key});

  List<MessengerMsg> chatListMessages = [];
  ScrollController _scrollController = new ScrollController();

  addMessage(MessengerMsg msg) {
    var formatedMsg = _replaceWithEmoticons(msg.text);
    msg.text = formatedMsg;
    setState(() {
      chatListMessages.add(msg);

      if (chatListMessages.length > UserProvider.maxMessengerHistory) {
        chatListMessages = chatListMessages.skip(chatListMessages.length - UserProvider.maxMessengerHistory).toList();
      }
    });
    Future.delayed(const Duration(milliseconds: 300), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
  }

  addMessages(List<MessengerMsg> msgs) {
    List<MessengerMsg> lst = chatListMessages;
    for (MessengerMsg msg in msgs) {
      var formatedMsg = _replaceWithEmoticons(msg.text);
      msg.text = formatedMsg;

      lst.add(msg);

      if (lst.length > UserProvider.maxMessengerHistory) {
        lst = lst.skip(lst.length - UserProvider.maxMessengerHistory).toList();
      }
    }

    setState(() {
      chatListMessages = lst;
    });

    Future.delayed(const Duration(milliseconds: 600), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 25));
  }

  List<MessengerMsg> getHistory() {
    return chatListMessages;
  }

  clearAll() {
    setState(() {
      chatListMessages = [];
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
          eligibleEmos.add({"index": indexFound.toString(), "key": key, "code": getEmoPath(code)});
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

  static getIndexFromCode(String code) {
    return int.parse(code.split('_')[1]);
  }

  static getEmoPath(String code) {
    var index = getIndexFromCode(code);
    if (window.location.href.contains("localhost")) {
      var s = window.location.href.split('?')[0];
      return "${s}assets/images/emoticons/$index.gif";
    }
    return Zoo.relativeToAbsolute("assets/assets/images/emoticons/$index.gif");
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: chatListMessages.length,
        itemBuilder: (BuildContext context, int index) {
          var item = chatListMessages[index];
          var username = item.from["username"];
          var userPhoto = item.from["mainPhoto"];
          var userSex = int.parse(item.from["sex"].toString());
          var dateMillis = item.dateMillis != null ? item.dateMillis : DateTime.now().millisecondsSinceEpoch;
          return username == UserProvider.instance.userInfo.username
              ? Padding(
                  padding: const EdgeInsets.only(top: 25, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Bubble(
                        margin: BubbleEdges.only(top: 10),
                        alignment: Alignment.topRight,
                        nip: BubbleNip.rightTop,
                        color: Color(0xffbfdcff),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _htmlMessageBuilder(
                              chatListMessages[index],
                            ),
                            SizedBox(height: 5),
                            Text(_formatDate(dateMillis), style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w300))
                          ],
                        )
                      ),
                      ClipOval(
                        child: userPhoto != null
                            ? Image.network(Utils.instance.getUserPhotoUrl(photoId: userPhoto["image_id"].toString()), height: 35, width: 35, fit: BoxFit.cover)
                            : Image.asset(userSex == 1 ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 35, width: 35, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 25, left: 20),
                  child: Row(
                    children: [
                      ClipOval(
                        child: userPhoto != null
                            ? Image.network(Utils.instance.getUserPhotoUrl(photoId: userPhoto["image_id"].toString()), height: 35, width: 35, fit: BoxFit.cover)
                            : Image.asset(userSex == 1 ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 35, width: 35, fit: BoxFit.cover),
                      ),
                      Bubble(
                        margin: BubbleEdges.only(top: 10),
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftTop,
                        color: Color(0xffe4e6e9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _htmlMessageBuilder(
                              chatListMessages[index],
                            ),
                            SizedBox(height: 5),
                            Text(_formatDate(dateMillis), style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w300))
                          ],
                        )
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  _formatDate(int dateMillis){
    DateTime _msgDate = DateTime.fromMillisecondsSinceEpoch(dateMillis);
    DateTime _now = DateTime.now();
    if (_now.day - _msgDate.day == 0){
      return _msgDate.hour.toString() + ":" + _msgDate.minute.toString().padLeft(2, "0");
    } else {
      String weekDay = AppLocalizations.of(context).translate("weekDays").split(',')[int.parse(_msgDate.weekday.toString()) - 1];
      String month = AppLocalizations.of(context).translate("monthsCut").split(',')[int.parse(_msgDate.weekday.toString()) - 1];
      return weekDay + ", " + _msgDate.day.toString() + " " + month + " " + _msgDate.year.toString() + ", " + _msgDate.hour.toString()+ ":" + _msgDate.minute.toString().padLeft(2, "0");
    }
  }

  _htmlMessageBuilder(MessengerMsg msg) {
    var htmlData = "";
    final exp = new RegExp(r'http(?:s?)://(?:www\.)?youtu(?:be\.com/watch\?v=|\.be/)([\w\-]+)(&(amp;)?[\w\?=]*)?');
    final text = msg.text.replaceAllMapped(exp, (Match m) => "<a href='${m[0]}'>${m[0]}</a>");

    htmlData = """
      <span>$text</span>
    """;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: HtmlWidget(
        htmlData,
        textStyle: TextStyle(
          color: Color(msg.colour),
          fontFamily: msg.fontFace,
          fontWeight: msg.bold ? FontWeight.bold : FontWeight.normal,
          fontSize: msg.fontSize?.toDouble(),
          fontStyle: msg.italic ? FontStyle.italic : FontStyle.normal,
        ),
        onTapUrl: (url) async {
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
