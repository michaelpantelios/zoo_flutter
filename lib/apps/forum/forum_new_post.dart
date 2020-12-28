import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ForumNewPost extends StatefulWidget {
  ForumNewPost({Key key, this.parentSize, this.forumId, this.parent, @required this.onCloseBtnHandler});

  final Size parentSize;
  final dynamic forumId;
  final dynamic parent;
  final Function onCloseBtnHandler;

  static List<String> chatFontFaces = [
    "Arial",
    "Arial Black",
    "Comic Sans MS",
    "Courier New",
    "Georgia",
    "Impact",
    "Times New Roman",
    "Trebuchet MS",
    "Verdana",
  ];

  static List<int> chatFontSizes = [
    12,
    13,
    14,
    15,
    16,
  ];

  ForumNewPostState createState() => ForumNewPostState();
}

class ForumNewPostState extends State<ForumNewPost> {
  ForumNewPostState({Key key});

  RPC _rpc;
  String _forumTitle;
  String postBody;
  bool sticky = false;
  bool acceptTerms = false;
  bool _isTopic;

  TextEditingController _subjectTextController = TextEditingController();
  TextEditingController _bodyTextController = TextEditingController();

  Color pickerColor = Color(0xff000000);
  Color currentColor = Color(0xff000000);
  List<bool> boldItalicSelection = List.generate(2, (index) => false);
  List<DropdownMenuItem<String>> _fontFaces;
  List<DropdownMenuItem<int>> _fontSizes;
  String _fontFaceSelected;
  int _fontSizeSelected;

  @override
  void initState() {
    super.initState();
    _rpc = RPC();
    _isTopic = widget.parent == null;

    _fontFaces = [];
    _fontSizes = [];
    _fontFaceSelected = "Verdana";
    _fontSizeSelected = 12;

    ForumNewPost.chatFontFaces.forEach((val) {
      _fontFaces.add(
        DropdownMenuItem(
          child: Text(
            val,
            style: TextStyle(fontSize: 12, fontFamily: val),
          ),
          value: val,
        ),
      );
    });

    ForumNewPost.chatFontSizes.forEach((val) {
      _fontSizes.add(
        DropdownMenuItem(
          child: Text(
            val.toString(),
            style: TextStyle(fontSize: 12),
          ),
          value: val,
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    _forumTitle = _isTopic ? AppLocalizations.of(context).translate("app_forum_category_" + widget.forumId.toString()) : "";
    print("_forumTitle = " + _forumTitle);
    super.didChangeDependencies();
  }

  onSend(BuildContext context) async {
    if(acceptTerms == false)
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_forum_noAgree"));
    else if(_bodyTextController.text.length == 0)
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_forum_noBody"));
    else if(_subjectTextController.text.length == 0 && _isTopic)
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_forum_noSubject"));
    // else if(chkCheckSticky.selected) {
    // var obj:Object = {
    // coins: ZCoinsCost.STICKY_FORUM,
    // text: locBundle.getString("protector_header", ZCoinsCost.STICKY_FORUM),
    // allowCollectibles: true
    // };
    //
    // var def:ZWindowDefinition = ZWindowDefaults.protector();
    // def.id = "forum_sticky_protector";
    //
    // var win:ZWindow = Application.application.winManager.create( def, obj );
    // win.addEventListener(ZWindowEvent.ON_CLOSE, handleProtector);
    // win.addEventListener(ZWindowEvent.ON_MODULE_SERVICE_STATUS, handleProtector);
    // }
    else {
      print("let's send");
      var data = {};
      data["forumId"] = widget.forumId;
      if (!_isTopic) data["parent"] = widget.parent;
      data["sticky"] = sticky ? 1 : 0;
      data["subject"] = _subjectTextController.text == "" ? "replyTo" + widget.parent.toString() : _subjectTextController.text;
      data["body"] = '<font color="#000000">'+_bodyTextController.text + '</font>';

      var res = await _rpc.callMethod("OldApps.Forum.newMessage", data);

      if (res["status"] == "ok") {
        print("new message data:");
        print(res["data"]);
        widget.onCloseBtnHandler("ok");
      } else {
        print("ERROR");
        print(res["status"]);
        widget.onCloseBtnHandler(res["status"]);
      }
    }
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
              padding: EdgeInsets.all(5),
              width: widget.parentSize.width * 0.5,
              height: _isTopic ? widget.parentSize.height * 0.6 : widget.parentSize.height * 0.45,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black45,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 3,
                    offset: Offset(2, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PopupContainerBar(title: _isTopic ? "app_forum_new_topic" : "app_forum_topic_view_reply", iconData: Icons.notes, onClose: ()=>{widget.onCloseBtnHandler(null) }),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Text(widget.parent == null ? AppLocalizations.of(context).translateWithArgs("app_forum_new_post_new_topic_mode_prompt", [_forumTitle]) : AppLocalizations.of(context).translate("app_forum_new_post_reply_mode_prompt"), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold))),
                  _isTopic ? Padding(padding: EdgeInsets.only(top: 10, left: 5, right: 5), child: Text(AppLocalizations.of(context).translate("app_forum_new_post_new_topic_title_label"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal))) : Container(),
                  _isTopic
                      ? Padding(
                          padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                          child: TextField(
                            controller: _subjectTextController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                          ))
                      : Container(),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                          child: Scrollbar(
                            child: TextField(
                              controller: _bodyTextController,
                              decoration: InputDecoration(border: OutlineInputBorder()),
                              maxLines: 10,
                            ),
                          ))),
                 Padding(
                   padding: EdgeInsets.all(5),
                   child: Row(
                     children: [
                       GestureDetector(
                         onTap: () {
                           showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   title: Text(AppLocalizations.of(context).translate("pick_color")),
                                   content: SingleChildScrollView(
                                     child: ColorPicker(
                                       paletteType: PaletteType.hsl,
                                       pickerColor: pickerColor,
                                       onColorChanged: changeColor,
                                       enableAlpha: false,
                                       showLabel: false,
                                       pickerAreaHeightPercent: 0.8,
                                     ),
                                   ),
                                   actions: <Widget>[
                                     FlatButton(
                                       child: Text(AppLocalizations.of(context).translate("ok")),
                                       onPressed: () {
                                         setState(() => currentColor = pickerColor);
                                         Navigator.of(context).pop();
                                       },
                                     ),
                                   ],
                                 );
                               });
                         },
                         child: Container(
                           width: 25,
                           height: 25,
                           decoration: BoxDecoration(
                             color: currentColor,
                             border: Border.all(color: Colors.grey, width: 0),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 20,
                       ),
                       Container(
                         height: 25,
                         child: ToggleButtons(
                           children: <Widget>[
                             Icon(FontAwesomeIcons.bold, size: 15),
                             Icon(FontAwesomeIcons.italic, size: 15),
                           ],
                           onPressed: (int index) {
                             setState(() {
                               boldItalicSelection[index] = !boldItalicSelection[index];
                             });
                           },
                           isSelected: boldItalicSelection,
                         ),
                       ),
                       SizedBox(
                         width: 20,
                       ),
                       Container(
                         height: 40,
                         child: DropdownButton(
                           value: _fontFaceSelected,
                           items: _fontFaces,
                           onChanged: (value) {
                             setState(() {
                               _fontFaceSelected = value;
                             });
                           },
                         ),
                       ),
                       SizedBox(
                         width: 20,
                       ),
                       Container(
                         height: 40,
                         child: DropdownButton(
                           value: _fontSizeSelected,
                           items: _fontSizes,
                           onChanged: (value) {
                             setState(() {
                               _fontSizeSelected = value;
                             });
                           },
                         ),
                       )
                     ],
                   )
                 ),
                  _isTopic
                      ? Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: CheckboxListTile(
                            title: Text(
                              AppLocalizations.of(context).translate("app_forum_new_post_new_topic_mode_want_sticky"),
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12),
                              textAlign: TextAlign.left,
                            ),
                            value: sticky,
                            onChanged: (newValue) {
                              setState(() {
                                sticky = newValue;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                          ))
                      : Container(),
                  Padding(
                      padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      child: CheckboxListTile(
                        title: Text(
                          AppLocalizations.of(context).translate("app_forum_accept_terms"),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                        value: acceptTerms,
                        onChanged: (newValue) {
                          setState(() {
                            acceptTerms = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                              onPressed: () {
                                onSend(context);
                              },
                              child: Text(AppLocalizations.of(context).translate("app_forum_new_post_btn_save"), style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold))),
                          SizedBox(width: 5),
                          FlatButton(
                              onPressed: () {
                                widget.onCloseBtnHandler(null);
                              },
                              child: Text(AppLocalizations.of(context).translate("app_forum_new_post_btn_cancel"), style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)))
                        ],
                      ))
                    ],
                  )
                ],
              ));
  }
}
