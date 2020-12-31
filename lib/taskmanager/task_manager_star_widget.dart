import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

class TaskManagerStarWidget extends StatefulWidget{
  TaskManagerStarWidget();

  TaskManagerStarWidgetState createState() => TaskManagerStarWidgetState();
}

class TaskManagerStarWidgetState extends State<TaskManagerStarWidget>{
  TaskManagerStarWidgetState();

  bool _star;

  @override
  void initState() {
    _star = UserProvider.instance.userInfo.star == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: (){
        PopupManager.instance.show(context: context, popup: PopupType.Star);
      },
      child: Tooltip(
        message: AppLocalizations.of(context).translate(_star ? "taskmanager_star_tooltip_prompt_on" : "taskmanager_star_tooltip_prompt_off"),
        child: Container(
            width: 90,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(9),
            ),
            padding: EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.star, color: _star ?
                Theme.of(context).accentColor : Theme.of(context).canvasColor, size: 35),
                Text(AppLocalizations.of(context).translate(_star ? "taskmanager_star_widget_on" : "taskmanager_star_widget_off"),
                    style: TextStyle(color:Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
              ],
            )
        )
      )
    );


  }



}
