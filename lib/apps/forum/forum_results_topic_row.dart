import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_record_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/utils/utils.dart';


class ForumResultsTopicRow extends StatefulWidget{
  ForumResultsTopicRow({Key key, this.onSubjectTap}) : super(key: key);

  final Function onSubjectTap;

  static double myHeight = 40;
  static int minHotReplies = 60;

  ForumResultsTopicRowState createState() => ForumResultsTopicRowState(key: key);
}

class ForumResultsTopicRowState extends State<ForumResultsTopicRow>{
  ForumResultsTopicRowState({Key key});

  dynamic _topicId;
  ForumUserModel _userInfo;
  String _subject = "";
  String _date;
  int _repliesNo = 0;
  int _read = 0;
  int _lastReplyRead = 0;
  bool _hot;
  int _sticky;

  getTopicId(){
    return _topicId;
  }

  setRead(bool value){
    setState(() {
      _read = value ? 1 : 0;
    });
  }

  update(ForumTopicRecordModel data){
    setState(() {
      _topicId = data.id;
      _userInfo = ForumUserModel.fromJSON(data.from);
      _subject = data.subject;
      _date = data.date;
      _repliesNo = data.repliesNo;
      _lastReplyRead = data.lastReplyRead;
      _read = data.read;
      _hot = data.repliesNo >= ForumResultsTopicRow.minHotReplies;
      _sticky = data.sticky;
    });
  }

  clear(){
    setState(() {
      _topicId = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: ForumResultsTopicRow.myHeight,
        decoration: BoxDecoration(
          border: Border( right: BorderSide(
              color: Colors.black26, width: 1),
            left: BorderSide(
                color: Colors.black26, width: 1),
            bottom: BorderSide(
                color: Colors.black26, width: 1)
          ),
        ),
        child: _topicId == null ? Container() : Row(
            children:[
              Expanded(
                  flex: 2,
                  child: Container(
                      decoration: BoxDecoration(
                        border:  Border(
                            right: BorderSide(
                                color: Colors.black26, width: 1)
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: _userInfo == null ? Container() : ForumUserRenderer(userInfo : _userInfo),
                 )
              ),
              Expanded(
                  flex: 6,
                  child:  FlatButton(
                      onPressed: (){
                        if (_topicId != null)
                          widget.onSubjectTap(_topicId);
                      },
                      child:  Container(
                          decoration: BoxDecoration(
                            border:  Border(
                                right: BorderSide(
                                    color: Colors.black26, width: 1)),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Container( width: ForumResultsTopicRow.myHeight, child: FaIcon(FontAwesomeIcons.bahai, color: Colors.yellow[600],size: ForumResultsTopicRow.myHeight) ),
                              !_hot ? Container() : Container( width: ForumResultsTopicRow.myHeight, child: FaIcon(FontAwesomeIcons.hotjar, color: Colors.deepOrange[800], size: ForumResultsTopicRow.myHeight) ),
                              _sticky == 0 ? Container() : Container(width: ForumResultsTopicRow.myHeight, child: FaIcon(FontAwesomeIcons.thumbtack, color: Colors.blue[600],size: ForumResultsTopicRow.myHeight)),
                              Text(_subject, style: TextStyle(color: Colors.black, fontWeight: _read == 0 ? FontWeight.bold : FontWeight.normal, fontSize: 13) )
                            ],
                          )

                      )
                    )
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                      decoration: BoxDecoration(
                        border:  Border(
                            right: BorderSide(
                                color: Colors.black26, width: 1)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: _date == null ? Text("") :
                      Text(Utils.instance.getNiceForumDate(dd: _date.toString(),hours: true),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13),
                      )
                  )
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(_repliesNo.toString(), style: TextStyle(color: Colors.black, fontWeight:  _lastReplyRead == 0 ? FontWeight.bold: FontWeight.normal, fontSize: 13),
                      )
                  )
              )
            ]
        )
    );
  }


}