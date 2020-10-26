import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/models/user/user_info.dart';

import 'package:zoo_flutter/utils/app_localizations.dart';

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

class MessagesList extends StatefulWidget {
  MessagesList({Key key}) : super(key: key);

  MessagesListState createState() => MessagesListState(key: key);
}

class MessagesListState extends State<MessagesList>{
  MessagesListState({Key key});
  List<PublicChatMessage> publicChatMessages = new List<PublicChatMessage>();
  ScrollController _scrollController = new ScrollController();

  addPublicMessage(UserInfo userInfo, String message){
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

    for(int i=0; i<DataMocker.chatWelcomeMessages.length; i++){
      publicChatMessages.add(new PublicChatMessage("", DataMocker.chatWelcomeMessages[i], Colors.black));
    }

    Timer.periodic(new Duration(seconds: 2), (timer) {
      setState(() {
        final _random = new Random();
        UserInfo user = DataMocker.users[_random.nextInt(DataMocker.users.length-1)];
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
          // reverse:true,
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