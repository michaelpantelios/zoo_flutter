import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

enum NewPostMode { newTopic, reply }

class ForumNewPost extends StatefulWidget {
  ForumNewPost({Key key, this.parentSize, @required this.newPostMode, @required this.info});

  final Size parentSize;
  final NewPostMode newPostMode;
  final info;

  ForumNewPostState createState() => ForumNewPostState();
}

class ForumNewPostState extends State<ForumNewPost>{
  ForumNewPostState({Key key});

  onCloseHandler(){

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.parentSize.width,
          height: widget.parentSize.height,
          decoration: BoxDecoration(
              color: new Color.fromRGBO(0, 0, 0, 0.8) // Specifies the background color and the opacity
          ),
        ),
        Container(
          width: widget.parentSize.width,
          height: widget.parentSize.height,
          child: Center(
              child: Container(
                  padding: EdgeInsets.all(5),
                  width: widget.parentSize.width * 0.5,
                  height: widget.parentSize.height * 0.5,
                  color: Colors.white,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     PopupContainerBar(title: widget.newPostMode == NewPostMode.newTopic
                         ? "app_forum_new_topic"
                         : "app_forum_topic_view_reply",
                         iconData: Icons.notes,
                          onCloseBtnHandler: onCloseHandler
                     ),
                      // Container(
                      //   padding: EdgeInsets.all(5),
                      //   child: Text(AppLocalizations.of(context).translate(widget.newPostMode == NewPostMode.newTopic
                      //   ? )
                      //    )
                      // )
                    ],
                  )
              )
          ),
        )

      ],
    );
  }
}