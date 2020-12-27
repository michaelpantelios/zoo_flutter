import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/forum/models/forum_reply_record_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class ForumResultsReplyRow extends StatefulWidget{
  ForumResultsReplyRow({Key key, this.onReplyClick}) : super(key: key);

  final Function onReplyClick;

  static double myHeight = 30;
  static double myWidth = 300;
  ForumResultsReplyRowState createState() => ForumResultsReplyRowState(key: key);
}

class ForumResultsReplyRowState extends State<ForumResultsReplyRow>{
  ForumResultsReplyRowState({Key key});

  int dayMilliseconds = 86400000;
  int twoDayMilliseconds = 172800000;
  int weekMilliseconds = 604800000;

  int _serialNumber = 0;
  dynamic _id;
  dynamic _parentId;
  ForumUserModel _from;
  String _date;
  int _read = 0;

  update(int serialNum, ForumReplyRecordModel data){
    setState(() {
      _serialNumber = serialNum;
      _id = data.id;
      _parentId = data.parent;
      _from = ForumUserModel.fromJSON(data.from);
      _date = data.date;
      _read = data.read;
    });
  }

  clear(){
    setState(() {
      _id = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ForumResultsReplyRow.myWidth,
      height: ForumResultsReplyRow.myHeight,
      child: _id == null ? Container() : Row(
        children: [
          Text((_serialNumber + 1).toString()+".",
            style: TextStyle(color: Colors.blue, fontSize: 9)),
          Expanded(
            child: _from == null ? Container() : ForumUserRenderer(userInfo : _from)
          ),
         Padding(
           padding: EdgeInsets.symmetric(horizontal: 3),
           child: _date == null ? Text("") : Text(getReplyDate(context, _date), style: TextStyle(color: Colors.black, fontWeight: _read == 0 ? FontWeight.bold : FontWeight.normal, fontSize: 12))
         ),
         Container(
           height: ForumResultsReplyRow.myHeight,
           width: ForumResultsReplyRow.myHeight*1.2,
           child:  ZButton(
             clickHandler: (){
               widget.onReplyClick(_id);
             },
             iconData: Icons.arrow_forward,
             iconColor: Colors.purple,
             iconSize: ForumResultsReplyRow.myHeight * 0.8,
           )
         )
        ],
      )
    );
  }

  getReplyDate(BuildContext context, String date){
    var serviceDate = new DateTime.utc(int.parse(date.substring(0,4)), int.parse(date.substring(4,6)), int.parse(date.substring(6,8)), int.parse(date.substring(9,11)), int.parse(date.substring(12,14)));

    var today = new DateTime.now();
    today = DateTime.utc(today.year, today.month, today.day, 23, 59);
    var datesDifferenceInMillis = today.millisecondsSinceEpoch - serviceDate.millisecondsSinceEpoch;
    String replyDate = "";

    if (  datesDifferenceInMillis < dayMilliseconds )
      replyDate += date.substring(9,14);
    else if ( datesDifferenceInMillis < twoDayMilliseconds && datesDifferenceInMillis > dayMilliseconds)
      replyDate +=  AppLocalizations.of(context).translate("app_forum_yesterday");
    else if (datesDifferenceInMillis > twoDayMilliseconds && datesDifferenceInMillis < weekMilliseconds )
      replyDate += AppLocalizations.of(context).translate("weekDays").split(",")[ serviceDate.weekday-1 ];
    else if (datesDifferenceInMillis > weekMilliseconds ){
      if (today.year == serviceDate.year)
        replyDate +=serviceDate.day.toString()+" "+ AppLocalizations.of(context).translate("monthsCut").split(",")[ serviceDate.month - 1];
      else replyDate += serviceDate.day.toString()+"/"+serviceDate.month.toString()+"/"+serviceDate.year.toString();
    } else if (today.year - serviceDate.year >= 1)
      replyDate += serviceDate.day.toString()+"/"+(serviceDate.month).toString()+"/"+serviceDate.year.toString();

    return replyDate;
  }


}