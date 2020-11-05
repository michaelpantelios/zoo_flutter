import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';

import 'package:zoo_flutter/utils/app_localizations.dart';

enum ChatMode {public, private}

class PublicChatMessage {
  final String username;
  final String message;
  final Color color;

  PublicChatMessage(
    this.username,
    this.message,
    this.color
  );
}

class ChatMessagesList extends StatefulWidget {
  ChatMessagesList({Key key, @required this.chatMode}) : super(key: key);

 final ChatMode chatMode;

  ChatMessagesListState createState() => ChatMessagesListState(key: key);
}

class ChatMessagesListState extends State<ChatMessagesList>{
  ChatMessagesListState({Key key});
  List<PublicChatMessage> publicChatMessages = new List<PublicChatMessage>();
  ScrollController _scrollController = new ScrollController();

  addPublicMessage(UserInfoModel userInfo, String message){
    setState(() {
      publicChatMessages.add(new PublicChatMessage(userInfo.username, message, Colors.black));
      _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent
      );
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.chatMode == ChatMode.public)
      for(int i=0; i<DataMocker.chatWelcomeMessages.length; i++){
        publicChatMessages.add(new PublicChatMessage("", DataMocker.chatWelcomeMessages[i], Colors.black));
      }

    // autoGenerateMessages();

  }

  autoGenerateMessages(){
    Timer.periodic(new Duration(seconds: 2), (timer) {
      setState(() {
        final _random = new Random();
        UserInfoModel user = DataMocker.users[_random.nextInt(DataMocker.users.length-1)];
        String message = DataMocker.fixedChatMessages[_random.nextInt(DataMocker.fixedChatMessages.length-1)];
        Color color = DataMocker.fixedChatMessageColors[_random.nextInt(DataMocker.fixedChatMessageColors.length-1)];
        publicChatMessages.add(new PublicChatMessage(user.username, message, color));
        _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        controller: _scrollController,
          shrinkWrap: true,
          itemCount: publicChatMessages.length,
          itemBuilder: (BuildContext context, int index) {
            String username = publicChatMessages[index].username;
            String message = publicChatMessages[index].message;
            Color color = publicChatMessages[index].color;
            return new Container(
              color: index % 2 == 0 ? Colors.white : Colors.cyan[50],
              padding: EdgeInsets.symmetric(vertical: 3),
              child:  RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: username + (username == "" ? "" : ": "), style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                      TextSpan(text: message, style: TextStyle(fontWeight: FontWeight.normal, color: color)),
                    ],
                  )
              )
            ) ;
          }),
    );
  }
}