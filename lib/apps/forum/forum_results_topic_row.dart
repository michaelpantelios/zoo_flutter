import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_record_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';


class ForumResultsTopicRow extends StatefulWidget{
  ForumResultsTopicRow({Key key, this.onSubjectTap}) : super(key: key);

  final Function onSubjectTap;

  static double myHeight = 30;
  static int minHotReplies = 60;

  ForumResultsTopicRowState createState() => ForumResultsTopicRowState(key: key);
}

class ForumResultsTopicRowState extends State<ForumResultsTopicRow>{
  ForumResultsTopicRowState({Key key});
  
  int dayMilliseconds = 86400000;
  int twoDayMilliseconds = 172800000;
  int weekMilliseconds = 604800000;

  double _iconSize = ForumResultsTopicRow.myHeight * 0.5;

  dynamic _topicId;
  ForumUserModel _userInfo;
  String _subject = "";
  String _date;
  int _repliesNo = 0;
  int _read = 0;
  int _lastReplyRead = 0;
  bool _hot;
  int _sticky;
  bool _isNew = false;

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

      var now = new DateTime.now();
      String today = now.year.toString()+(now.month < 10? "0":"")+(now.month.toString())+(now.day < 10? "0":"")+now.day.toString();
      _isNew = (today == _date.toString().substring(0,8));

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
        // decoration: BoxDecoration(
        //   border: Border( right: BorderSide(
        //       color: Colors.black26, width: 1),
        //     left: BorderSide(
        //         color: Colors.black26, width: 1),
        //     bottom: BorderSide(
        //         color: Colors.black26, width: 1)
        //   ),
        // ),
        child: _topicId == null ? Container() : Row(
            children:[
              Expanded(
                  flex: 1,
                  child: Container(
                      // decoration: BoxDecoration(
                      //   border:  Border(
                      //       right: BorderSide(
                      //           color: Colors.black26, width: 1)
                      //   ),
                      // ),
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
                          // decoration: BoxDecoration(
                          //   border:  Border(
                          //       right: BorderSide(
                          //           color: Colors.black26, width: 1)),
                          // ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              !_isNew ? Container() :
                              Container(
                                  width: _iconSize,
                                  margin: EdgeInsets.symmetric(horizontal: 3),
                                  child: Tooltip(
                                    textStyle: TextStyle(
                                        fontSize: 14
                                    ),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[900],
                                      border: Border.all(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        new BoxShadow(color: Color(0xaa000000), offset: new Offset(2.0, 2.0), blurRadius: 6, spreadRadius: 3),
                                      ],
                                    ),
                                    message: AppLocalizations.of(context).translate("app_forum_topic_row_new_topic_tooltip"),
                                    child: FaIcon(FontAwesomeIcons.bahai, color: Colors.yellow[600],size: _iconSize),
                                  )
                              ),
                              !_hot ? Container() :
                              Container(
                                  width: _iconSize,
                                  margin: EdgeInsets.symmetric(horizontal: 3),
                                  child: Tooltip(
                                      textStyle: TextStyle(
                                          fontSize: 14
                                      ),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[900],
                                        border: Border.all(color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          new BoxShadow(color: Color(0xaa000000), offset: new Offset(2.0, 2.0), blurRadius: 6, spreadRadius: 3),
                                        ],
                                      ),
                                    message: AppLocalizations.of(context).translate("app_forum_topic_row_hot_topic_tooltip"),
                                    child: FaIcon(FontAwesomeIcons.hotjar, color: Colors.deepOrange[800], size: _iconSize)
                                  )
                              ),
                              _sticky == 0 ? Container() :
                              Container(width: _iconSize,
                                  margin: EdgeInsets.symmetric(horizontal: 3),
                                  child: Tooltip(
                                      textStyle: TextStyle(
                                          fontSize: 14
                                      ),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[900],
                                        border: Border.all(color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          new BoxShadow(color: Color(0xaa000000), offset: new Offset(2.0, 2.0), blurRadius: 6, spreadRadius: 3),
                                        ],
                                      ),
                                    message: AppLocalizations.of(context).translate("app_forum_topic_row_sticky_topic_tooltip"),
                                    child: FaIcon(FontAwesomeIcons.thumbtack, color: Colors.blue[600],size: _iconSize)
                                  )
                              ),
                              Flexible(
                                child: Text(_subject,
                                  style: TextStyle(color: Colors.black, fontWeight: _read == 0 ? FontWeight.bold : FontWeight.normal, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis
                                )
                              )
                            ],
                          )

                      )
                    )
              ),
              Expanded(
                  flex:1,
                  child: Container(
                      height: ForumResultsTopicRow.myHeight,
                      decoration: BoxDecoration(
                        border:  Border(
                            right: BorderSide(
                                color: Colors.black26, width: 1)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: _date == null ? Text("") :
                          Align(
                            alignment: Alignment.centerLeft,
                            child:  Text( getSubjectDate(context, _date),
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13),
                            ),
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


  getSubjectDate(BuildContext context, String date) {
    var serviceDate = new DateTime.utc(int.parse(date.substring(0,4)), int.parse(date.substring(4,6)), int.parse(date.substring(6,8)), int.parse(date.substring(9,11)), int.parse(date.substring(12,14)));

    var today = new DateTime.now();
    today = DateTime.utc(today.year, today.month, today.day, 23, 59);
    var datesDifferenceInMillis = today.millisecondsSinceEpoch - serviceDate.millisecondsSinceEpoch;
    String subjectDate = "";

    if (  datesDifferenceInMillis < dayMilliseconds )
      subjectDate += AppLocalizations.of(context).translate("app_forum_today");
    else if ( datesDifferenceInMillis < twoDayMilliseconds && datesDifferenceInMillis > dayMilliseconds)
      subjectDate +=  AppLocalizations.of(context).translate("app_forum_yesterday");
    else if (datesDifferenceInMillis > twoDayMilliseconds && datesDifferenceInMillis < weekMilliseconds )
      subjectDate += AppLocalizations.of(context).translate("weekDays").split(",")[ serviceDate.weekday - 1 ];
    else if (datesDifferenceInMillis > weekMilliseconds ){
      if (today.year == serviceDate.year)
        subjectDate += serviceDate.day.toString()+" "+ AppLocalizations.of(context).translate("monthsCut").split(",")[ serviceDate.month - 1];
      else subjectDate += serviceDate.day.toString()+"/"+serviceDate.month.toString()+"/"+serviceDate.year.toString();
    } else if ( today.year - serviceDate.year >= 1)
      subjectDate += serviceDate.day.toString()+"/"+(serviceDate.month).toString()+"/"+serviceDate.year.toString();

    subjectDate += " "+ date.substring(9,14);

    return subjectDate;
  }

}