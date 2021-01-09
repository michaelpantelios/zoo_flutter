import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class TaskManagerZLevelWidget extends StatefulWidget {
  TaskManagerZLevelWidget({@required this.points, @required this.level, @required this.levelTotal, @required this.levelPoints});
  final int points;
  final int level;
  final int levelTotal;
  final int levelPoints;

  TaskManagerZLevelWidgetState createState() => TaskManagerZLevelWidgetState();
}

class TaskManagerZLevelWidgetState extends State<TaskManagerZLevelWidget> {
  TaskManagerZLevelWidgetState();

  @override
  Widget build(BuildContext context) {
    double percW = Math.max(10, (int.parse(widget.levelPoints.toString()) / widget.levelTotal) * 190);
    return Container(
        width: 250,
        height: 40,
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              AppLocalizations.of(context).translate("taskmanager_zlvl_label"),
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
                width: 190,
                height: 40,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(9)),
                child: Stack(
                  children: [
                    Container(
                      width: percW,
                      height: 40,
                      decoration: percW > 180
                          ? BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(9.0),
                              ),
                            )
                          : BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(9.0),
                                topLeft: Radius.circular(9.0),
                              ),
                            ),
                    ),
                    Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.level.toString(), style: Theme.of(context).textTheme.headline1),
                            Text(
                              widget.levelPoints.toString() + "/" + UserProvider.instance.userInfo.levelTotal.toString(),
                              style: Theme.of(context).textTheme.button,
                            ),
                          ],
                        ))
                  ],
                )),
          ],
        ));
  }
}
