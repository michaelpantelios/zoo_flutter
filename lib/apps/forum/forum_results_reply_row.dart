import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/models/forum_reply_record_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class ForumResultsReplyRow extends StatefulWidget{
  ForumResultsReplyRow({Key key, this.onReplyClick}) : super(key: key);

  final Function onReplyClick;

  static double myHeight = 40;
  static double myWidth = 300;
  ForumResultsReplyRowState createState() => ForumResultsReplyRowState(key: key);
}

class ForumResultsReplyRowState extends State<ForumResultsReplyRow>{
  ForumResultsReplyRowState({Key key});

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
           child: _date == null ? Text("") : Text(Utils.instance.getNiceForumDate(dd: _date.toString(),hours: true), style: TextStyle(color: Colors.black, fontWeight: _read == 0 ? FontWeight.bold : FontWeight.normal, fontSize: 12))
         ),
         Container(
           height: ForumResultsReplyRow.myHeight,
           width: ForumResultsReplyRow.myHeight*1.1,
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


}