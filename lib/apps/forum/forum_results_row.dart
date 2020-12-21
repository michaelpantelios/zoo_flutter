import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_record_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';

class ForumResultsRow extends StatefulWidget{
  ForumResultsRow({Key key, this.onSubjectTap}) : super(key: key);

  final Function onSubjectTap;

  static double myHeight = 40;
  ForumResultsRowState createState() => ForumResultsRowState(key: key);
}

class ForumResultsRowState extends State<ForumResultsRow>{
  ForumResultsRowState({Key key});

  dynamic _topicId;
  ForumUserModel _userInfo;
  String _subject = "";
  String _date;
  int _repliesNo = 0;
  int _read = 0;
  int _lastReplyRead = 0;
  bool _hot;
  int _sticky;

  update(ForumTopicRecordModel data){
    setState(() {
      _topicId = data.id;
      _userInfo = ForumUserModel.fromJSON(data.from);
      _subject = data.subject;
      _date = data.date;
      _repliesNo = data.repliesNo;
      _lastReplyRead = data.lastReplyRead;
      _read = data.read;
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
        height: ForumResultsRow.myHeight,
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
                          child: Text(_subject, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13) )
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
                      child: _date == null ? Text("") : Text(Utils.instance.getNiceForumDate(dd: _date.toString(),hours: true), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                      )
                  )
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(_repliesNo.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                      )
                  )
              )
            ]
        )
    );
  }


}