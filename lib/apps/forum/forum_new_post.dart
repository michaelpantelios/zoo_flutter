import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/models/forum/forum_topic_model.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

typedef OnCloseBtnHandler = void Function();

enum NewPostMode { newTopic, reply }

class ForumNewPost extends StatefulWidget {
  ForumNewPost({Key key, this.parentSize, @required this.newPostMode, this.categoryName, this.topicInfo, @required this.onCloseBtnHandler});

  final Size parentSize;
  final NewPostMode newPostMode;
  final String categoryName;
  final ForumTopicModel topicInfo;
  final OnCloseBtnHandler onCloseBtnHandler;

  ForumNewPostState createState() => ForumNewPostState();
}

class ForumNewPostState extends State<ForumNewPost>{
  ForumNewPostState({Key key});

  String topicTitle;
  String postBody;
  bool sticky = false;
  bool acceptTerms = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    topicTitle = widget.newPostMode == NewPostMode.newTopic ? "" : widget.topicInfo.title;
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
                  height: widget.newPostMode == NewPostMode.newTopic
                      ? widget.parentSize.height * 0.6
                  : widget.parentSize.height * 0.45,
                  color: Colors.white,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     PopupContainerBar(title: widget.newPostMode == NewPostMode.newTopic
                         ? "app_forum_new_topic"
                         : "app_forum_topic_view_reply",
                         iconData: Icons.notes,
                          onCloseBtnHandler: widget.onCloseBtnHandler
                     ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(  widget.newPostMode == NewPostMode.newTopic ?
                        AppLocalizations.of(context).translateWithArgs(
                        "app_forum_new_post_new_topic_mode_prompt", [widget.categoryName])  :
                        AppLocalizations.of(context).translate("app_forum_new_post_reply_mode_prompt"),
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)
                         )
                      ),
                      widget.newPostMode == NewPostMode.newTopic ?
                        Padding(
                            padding:EdgeInsets.only(top:10, left: 5, right: 5),
                            child: Text(AppLocalizations.of(context).translate("app_forum_new_post_new_topic_title_label"),
                                style: TextStyle(color: Colors.black, fontSize:12, fontWeight: FontWeight.normal))
                        )
                      : Container(),
                      widget.newPostMode == NewPostMode.newTopic ?
                        Padding(
                            padding: EdgeInsets.only(left:5, right: 5, bottom: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                            )
                        ): Container(),
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(left:5, right:5, bottom: 10),
                            child: Scrollbar(
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder()
                                ),
                                maxLines: 10,
                              ),
                            )
                        )
                      ),
                      SizedBox(
                        height: 30, //text editor area
                      ),
                      widget.newPostMode == NewPostMode.newTopic ? Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: CheckboxListTile(
                          title: Text(AppLocalizations.of(context).translate("app_forum_new_post_new_topic_mode_want_sticky"),
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12), textAlign: TextAlign.left,),
                          value: sticky,
                          onChanged: (newValue) {
                            setState(() {
                              sticky = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        )
                      )
                      : Container(),
                      Padding(
                          padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                          child: CheckboxListTile(
                            title: Text(AppLocalizations.of(context).translate("app_forum_accept_terms"),
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12), textAlign: TextAlign.left,),
                            value: acceptTerms,
                            onChanged: (newValue) {
                              setState(() {
                                acceptTerms = newValue;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                  onPressed: (){
                                    widget.onCloseBtnHandler();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context).translate("app_forum_new_post_btn_save"),
                                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)
                                  )
                                ),
                                SizedBox(
                                  width: 5
                                ),
                                FlatButton(
                                    onPressed: (){
                                      widget.onCloseBtnHandler();
                                    },
                                    child: Text(
                                        AppLocalizations.of(context).translate("app_forum_new_post_btn_cancel"),
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)
                                    )
                                )
                              ],
                            )
                          )
                        ],
                      )
                    ],
                  )
              )
          ),
        )

      ],
    );
  }
}