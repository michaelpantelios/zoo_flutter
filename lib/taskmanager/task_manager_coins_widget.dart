import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class TaskManagerCoinsWidget extends StatefulWidget {
  TaskManagerCoinsWidget({@required this.coins});
  final int coins;

  TaskManagerCoinsWidgetState createState() => TaskManagerCoinsWidgetState();
}

class TaskManagerCoinsWidgetState extends State<TaskManagerCoinsWidget> {
  TaskManagerCoinsWidgetState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          PopupManager.instance.show(context: context, popup: PopupType.Coins);
        },
        child: Tooltip(
            message: AppLocalizations.of(context).translate(widget.coins == 0 ? "taskmanager_coins_widget_no_coins" : "taskmanager_coins_widget_more_coins"),
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
                    Icon(
                      Icons.copyright,
                      color: Theme.of(context).accentColor,
                      size: 35,
                    ),
                    Text(widget.coins.toString(), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ))));
  }
}
