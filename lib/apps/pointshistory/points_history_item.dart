import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/models/pointshistory/points_history_model.dart';
import 'package:zoo_flutter/utils/utils.dart';

class PointsHistoryItem extends StatefulWidget {
  PointsHistoryItem({Key key}): super(key: key);

  static double myHeight = 30;

  PointsHistoryItemState createState() => PointsHistoryItemState(key: key);
}

class PointsHistoryItemState extends State<PointsHistoryItem>{
  PointsHistoryItemState({Key key});

  PointsHistoryModel _data;
  int _index = 0;
  String _text = "";

  update(PointsHistoryModel data, int index){
    setState(() {
      _index = index;
      String _date = Utils.instance.getNiceDate(int.parse(data.date["__datetime__"].toString()));
      _text = AppLocalizations.of(context).translateWithArgs("app_pointshistory_activity_"+data.action, [_date, data.points.toString()]);
    });
  }

  clear(){
    setState(() {
      _index = -1;
      _text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return _index == -1 ? Container()
        : Container(
      padding: EdgeInsets.only(left: 10),
      height: PointsHistoryItem.myHeight,
      color: _index%2 == 0 ? Colors.white : Color(0xfff8f8f9),
      child: Text(
        _text,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.w500),
        textAlign: TextAlign.left,
      )
    );
  }


}
