import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class TaskManagerZLevelWidget extends StatefulWidget{
  TaskManagerZLevelWidget();

  TaskManagerZLevelWidgetState createState() => TaskManagerZLevelWidgetState();
}

class TaskManagerZLevelWidgetState extends State<TaskManagerZLevelWidget>{
  TaskManagerZLevelWidgetState();

  @override
  Widget build(BuildContext context) {
    var userPoints = context.select((UserProvider p) => p.userInfo.levelPoints);
    print("userPoints = "+userPoints.toString());
    print("levelTotal = "+UserProvider.instance.userInfo.levelTotal.toString());

    return Container(
      width: 250,
      height: 40,
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(AppLocalizations.of(context).translate("taskmanager_zlvl_label"),
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 24, fontWeight: FontWeight.w600)),
          Container(
              width: 190,
              height: 40,
              decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(9)),
                child: Stack(
                  children: [
                    Container(
                      width: (int.parse(userPoints.toString()) / int.parse(UserProvider.instance.userInfo.levelTotal.toString())) * 190,
                      height: 40,
                        decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(9.0),
                                topLeft: Radius.circular(9.0))
                        )
                    ),
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(UserProvider.instance.userInfo.level.toString(),
                              style: Theme.of(context).textTheme.headline1),
                          Text(userPoints.toString() +"/"+UserProvider.instance.userInfo.levelTotal.toString(),
                              style: Theme.of(context).textTheme.button)
                        ],
                      )
                    )
                  ],
                )
            ),
        ],
      )
    );
  }


}