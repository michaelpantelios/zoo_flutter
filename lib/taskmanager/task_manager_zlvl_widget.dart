import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/taskmanager/task_manager_zlvl_dropdown_item.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';

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

  GlobalKey _key;
  bool isMenuOpen = false;
  Offset myPosition;
  Size mySize;
  OverlayEntry _overlayEntry;
  Size _overlaySize = new Size(270, 140);

  _openPointsHistory(BuildContext context) {
    PopupManager.instance.show(context: context, popup: PopupType.PointsHistory, callbackAction: (retValue) {});
  }

  _openHelp() async {
    if (await canLaunch(Utils.zooLevelHelp)) {
      await launch(Utils.zooLevelHelp);
    } else {
      throw 'Could not launch $Utils.instance.zooLevelHelp()';
    }
  }

  @override
  void initState() {
    super.initState();
    _key = LabeledGlobalKey("zlvl_widget");
  }

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    mySize = renderBox.size;
    myPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }

  openMenu() {
    if (isMenuOpen) {
      closeMenu();
      return;
    }
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(builder: (context) {
      return Positioned(
          top: myPosition.dy + mySize.height,
          left: myPosition.dx - _overlaySize.width + mySize.width,
          width: _overlaySize.width,
          child: Material(
              color: Colors.transparent,
              child: MouseRegion(
                  onExit: (e) => closeMenu(),
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        // border: Border.all(color: Colors.deepOrange, width: 3),
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          new BoxShadow(color: Color(0x15000000), offset: new Offset(-3.0, 4.0), blurRadius: 3, spreadRadius: 3),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TaskManagerZlvlDropdownItem(
                            text: AppLocalizations.of(context).translate("taskmanager_zlvl_item_weekly_zpoints") + widget.points.toString(),
                            iconPath: "assets/images/taskmanager/zlvl/points_icon.png",
                            onTapHandler: () {},
                          ),
                          TaskManagerZlvlDropdownItem(
                            text: AppLocalizations.of(context).translate("taskmanager_zlvl_item_zpoints_history"),
                            iconPath: "assets/images/taskmanager/zlvl/history_icon.png",
                            onTapHandler: () => {_openPointsHistory(context)},
                          ),
                          TaskManagerZlvlDropdownItem(
                            text: AppLocalizations.of(context).translate("taskmanager_zlvl_item_help"),
                            iconPath: "assets/images/taskmanager/zlvl/help_icon.png",
                            onTapHandler: _openHelp,
                          ),
                        ],
                      )))));
    });
  }

  @override
  Widget build(BuildContext context) {
    double percW = Math.max(10, (int.parse(widget.levelPoints.toString()) / widget.levelTotal) * 190);
    return GestureDetector(
        key: _key,
        onTap: openMenu,
        child: Container(
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
            )));
  }
}
