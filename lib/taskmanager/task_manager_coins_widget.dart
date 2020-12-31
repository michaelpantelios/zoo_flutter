import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

class TaskManagerCoinsWidget extends StatefulWidget{
  TaskManagerCoinsWidget();

  TaskManagerCoinsWidgetState createState() => TaskManagerCoinsWidgetState();
}

class TaskManagerCoinsWidgetState extends State<TaskManagerCoinsWidget>{
  TaskManagerCoinsWidgetState();

  int _coins;

  @override
  void initState() {
     _coins = UserProvider.instance.userInfo.coins;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: (){
          PopupManager.instance.show(context: context, popup: PopupType.Coins);
        },
        child: Tooltip(
            message: AppLocalizations.of(context).translate(_coins == 0  ? "taskmanager_coins_widget_no_coins" : "taskmanager_coins_widget_more_coins"),
            child: Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                padding: EdgeInsets.all(3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.copyright, color: Theme.of(context).accentColor, size: 35,),
                    Text(_coins.toString(),
                        style: TextStyle(color:Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                )
            )
        )
    );


  }



}
