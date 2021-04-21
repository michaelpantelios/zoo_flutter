import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/notifications/notification_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/taskmanager/task_manager_coins_widget.dart';
import 'package:zoo_flutter/taskmanager/task_manager_settings_button.dart';
import 'package:zoo_flutter/taskmanager/task_manager_star_widget.dart';
import 'package:zoo_flutter/taskmanager/task_manager_zlvl_widget.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

import '../main.dart';

class TaskManager extends StatefulWidget {
  TaskManager(Key key) : super(key: key);

  TaskManagerState createState() => TaskManagerState();
}

class TaskManagerState extends State<TaskManager> {
  TaskManagerState();

  int _unreadMails = 0;
  // int _unreadMessages = 0;
  int _unreadNotifications = 0;
  int _newCoins = 0;
  int _points = 0;
  int _levelPoints = 0;
  int _level = 0;
  int _levelTotal = 0;
  bool _userLogged = false;
  RPC _rpc;
  String _chatUsers = "--";
  String _onlineUsers = "--";
  bool _notificationsLayerOpened = false;

  @override
  void initState() {
    NotificationsProvider.instance.addListener(_onNotification);
    UserProvider.instance.addListener(_onUserProvider);

    super.initState();
  }

  @override
  void dispose() {
    NotificationsProvider.instance.removeListener(_onNotification);
    UserProvider.instance.removeListener(_onUserProvider);
    super.dispose();
  }

  _onUserProvider() async {
    if (UserProvider.instance.userInfo != null) {
      setState(() {
        _newCoins = int.parse(UserProvider.instance.userInfo.coins.toString());
        _points = int.parse(UserProvider.instance.userInfo.points.toString());
        _level = int.parse(UserProvider.instance.userInfo.level.toString());
        _levelPoints = int.parse(UserProvider.instance.userInfo.levelPoints.toString());
        _levelTotal = int.parse(UserProvider.instance.userInfo.levelTotal.toString());
        _userLogged = UserProvider.instance.logged;
        _unreadMails = int.parse(UserProvider.instance.userInfo.unreadMail.toString());
      });

      var totalUnreadNotifications = await Root.feedsManager.fetchAlerts();

      setState(() {
        _unreadNotifications = totalUnreadNotifications;
      });
    }
  }

  _onNotification() {
    var newCountersNotification = NotificationsProvider.instance.notifications.firstWhere((element) => element.name == NotificationType.ON_UPDATE_COUNTERS, orElse: () => null);
    if (newCountersNotification != null) {
      setState(() {
        _onlineUsers = newCountersNotification.args["online"].toString();
        _chatUsers = newCountersNotification.args["chat"]["el_GR"].toString();
      });
    }
  }

  _onOpenMail() {
    PopupManager.instance.show(context: context, popup: PopupType.Mail, callbackAction: (r) {});
  }

  resetNotificationButton() {
    setState(() {
      _notificationsLayerOpened = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Root.AppSize.width,
      height: GlobalSizes.taskManagerHeight,
      alignment: Alignment.topCenter,
      child: Container(
        height: GlobalSizes.taskManagerHeight - 10,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            new BoxShadow(color: Color(0x15000000), offset: new Offset(0.0, 5.0), blurRadius: 4, spreadRadius: 5),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(margin: EdgeInsets.only(left: 10), child: Image.asset("assets/images/taskmanager/zoo_logo.png")),
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("panelHeader_online_counter"),
                          style: TextStyle(
                            color: Color(0xff9598a4),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            _onlineUsers,
                            style: TextStyle(
                              color: Color(0xff9598a4),
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("panelHeader_chat_counter"),
                          style: TextStyle(
                            color: Color(0xff9598a4),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            _chatUsers,
                            style: TextStyle(
                              color: Color(0xff9598a4),
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Expanded(child: Container()),
            _userLogged
                ? Container()
                :  FlatButton(
                onPressed: () {
                  PopupManager.instance.show(context: context, popup: PopupType.Signup);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  width: 145,
                  height: 40,
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/popup_app_icons/signup_icon.png", width: 30, height: 30,),
                        SizedBox(width:10),
                        Text(AppLocalizations.of(context).translate("taskmanager_btn_signup"),
                        style: Theme.of(context).textTheme.headline2
                        )
                      ],
                    )
                  )
                )
            ),
                // : ZButton(
                //     minWidth: 145,
                //     height: 40,
                //     buttonColor: Theme.of(context).buttonColor,
                //     label: AppLocalizations.of(context).translate("taskmanager_btn_signup"),
                //     labelStyle: Theme.of(context).textTheme.headline2,
                //     // iconData: Icons.person_add_alt_1_rounded,
                //     iconPath: "assets/images/popup_app_icons/signup_icon.png",
                //     iconSize: 30,
                //     // iconColor: Theme.of(context).backgroundColor,
                //     iconPosition: ZButtonIconPosition.right,
                //     clickHandler: () {
                //       PopupManager.instance.show(context: context, popup: PopupType.Signup);
                //     },
                //   ),
            SizedBox(width: 10),
            _userLogged
                ? Container()
                : FlatButton(
                    onPressed: () {
                      PopupManager.instance.show(context: context, popup: PopupType.Login, callbackAction: (retValue) {});
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        width: 145,
                        height: 40,
                        child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/popup_app_icons/login_icon.png", color: Theme.of(context).primaryColor, width: 30, height: 30,),
                                SizedBox(width:10),
                                Text(AppLocalizations.of(context).translate("taskmanager_btn_login"),
                                    style: Theme.of(context).textTheme.headline3
                                )
                              ],
                            )
                        )
                    )
                  ),
                // : ZButton(
                //     minWidth: 145,
                //     height: 40,
                //     buttonColor: Colors.white,
                //     label: AppLocalizations.of(context).translate("taskmanager_btn_login"),
                //     labelStyle: Theme.of(context).textTheme.headline3,
                //     // iconData: Icons.login,
                //     iconPath: "assets/images/popup_app_icons/login_icon.png",
                //     iconSize: 30,
                //     // iconColor: Theme.of(context).primaryColor,
                //     iconPosition: ZButtonIconPosition.right,
                //     clickHandler: () {
                //       PopupManager.instance.show(context: context, popup: PopupType.Login, callbackAction: (retValue) {});
                //     },
                //   ),
            !_userLogged ? Container() : TaskManagerZLevelWidget(points: _points, level: _level, levelTotal: _levelTotal, levelPoints: _levelPoints),
            SizedBox(width: 20),
            !_userLogged ? Container() : TaskManagerCoinsWidget(coins: _newCoins),
            SizedBox(width: 20),
            !_userLogged ? Container() : TaskManagerStarWidget(),
            SizedBox(width: 20),
            !_userLogged
                ? Container()
                : Tooltip(
                    message: AppLocalizations.of(context).translate("taskmanager_icon_mail_tooltip"),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: ZButton(
                            minWidth: 70,
                            height: 40,
                            buttonColor: Colors.white,
                            iconData: Icons.mail,
                            iconSize: 30,
                            iconColor: Theme.of(context).primaryColor,
                            clickHandler: () {
                              _onOpenMail();
                            },
                          ),
                        ),
                        _unreadMails > 0
                            ? Positioned(
                                right: 5,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      "assets/images/general/notification_circle.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: Center(
                                          child: Text(
                                        _unreadMails.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
            SizedBox(width: 10),
            !_userLogged
                ? Container()
                : Tooltip(
                    message: AppLocalizations.of(context).translate("taskmanager_icon_notif_tooltip"),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Offstage(
                                offstage: _notificationsLayerOpened,
                                child: ZButton(
                                  minWidth: 70,
                                  height: 40,
                                  buttonColor: Colors.white,
                                  iconPath: "assets/images/notifications/notification_icon_idle.png",
                                  iconSize: 30,
                                  iconColor: Theme.of(context).primaryColor,
                                  clickHandler: () {
                                    Root.feedsManager.show();
                                    setState(() {
                                      _notificationsLayerOpened = true;
                                      _unreadNotifications = 0;
                                    });
                                  },
                                ),
                              ),
                              Offstage(
                                offstage: !_notificationsLayerOpened,
                                child: ZButton(
                                  minWidth: 70,
                                  height: 40,
                                  buttonColor: Colors.white,
                                  iconPath: "assets/images/notifications/notification_icon_pressed.png",
                                  iconSize: 30,
                                  iconColor: Theme.of(context).primaryColor,
                                  clickHandler: () {
                                    Root.feedsManager.hide();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        _unreadNotifications > 0
                            ? Positioned(
                                right: 5,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      "assets/images/general/notification_circle.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: Center(
                                        child: Text(
                                          _unreadNotifications.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
            SizedBox(width: 10),
            !_userLogged ? Container() : TaskManagerSettingsButton()
          ],
        ),
      ),
    );
  }
}
