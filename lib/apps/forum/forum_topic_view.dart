import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/models/forum/forum_topic.dart';
import 'package:zoo_flutter/models/forum/forum_reply.dart';
import 'package:zoo_flutter/models/user/user_info.dart';


class ForumTopicView extends StatefulWidget {
  ForumTopicView({Key key, @required this.topic});

  final ForumTopic topic;

  ForumTopicViewState createState() => ForumTopicViewState();
}

class ForumTopicViewState extends State<ForumTopicView>{
  ForumTopicViewState({Key key});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     width: double.infinity,
     child: Row(
       children: [
         Column(
           children: [
             Container()
           ],
         )
       ],
     ),
   );
  }
}

