import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/mail/mail_info.dart';
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

class TaskManager extends StatefulWidget {
  TaskManager();

  TaskManagerState createState() => TaskManagerState();
}

class TaskManagerState extends State<TaskManager> {
  TaskManagerState();

  int _unreadMails = 0;
  int _newCoins = 0;
  int _points = 0;
  int _levelPoints = 0;
  int _level = 0;
  int _levelTotal = 0;
  bool _userLogged = false;
  RPC _rpc;

  @override
  void initState() {
    NotificationsProvider.instance.addListener(_onNotification);
    UserProvider.instance.addListener(_onUserProvider);

    _rpc = RPC();

    _fetchMails();

    super.initState();
  }

  @override
  void dispose() {
    NotificationsProvider.instance.removeListener(_onNotification);
    UserProvider.instance.removeListener(_onUserProvider);
    super.dispose();
  }

  _fetchMails() async {
    var options = {};
    options["recsPerPage"] = 30;
    options["page"] = 1;
    options["getCount"] = 1;
    var res = await _rpc.callMethod("Mail.Main.getInbox", [options]);

    var mailsFetched = [];
    if (res["status"] == "ok") {
      var records = res["data"]["records"];
      for (int i = 0; i < records.length; i++) {
        MailInfo mailInfo = MailInfo.fromJSON(records[i]);
        mailsFetched.add(mailInfo);
      }
    }

    setState(() {
      _unreadMails = mailsFetched.where((element) => element.read == 0).length;
    });
  }

  _onUserProvider() {
    print("task mananger- _onUserProvider");
    setState(() {
      _newCoins = int.parse(UserProvider.instance.userInfo.coins.toString());
      _points = int.parse(UserProvider.instance.userInfo.points.toString());
      _level = int.parse(UserProvider.instance.userInfo.level.toString());
      _levelPoints = int.parse(UserProvider.instance.userInfo.levelPoints.toString());
      _levelTotal = int.parse(UserProvider.instance.userInfo.levelTotal.toString());
      _userLogged = UserProvider.instance.logged;
    });
  }

  _onNotification() {
    print("task mananger - notification change.");
    var newMailNotification = NotificationsProvider.instance.notifications.firstWhere((element) => element.type == NotificationType.ON_NEW_MAIL, orElse: () => null);
    if (newMailNotification != null) {
      _fetchMails();
    }
  }

  _onOpenNotifications() {
    AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("unavailable_service"));
  }

  _onOpenMail() {
    PopupManager.instance.show(
        context: context,
        popup: PopupType.Mail,
        callbackAction: (r) {
          _fetchMails();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
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
              Expanded(child: Container()),
              _userLogged
                  ? Container()
                  : ZButton(
                      minWidth: 145,
                      height: 40,
                      buttonColor: Theme.of(context).buttonColor,
                      label: AppLocalizations.of(context).translate("taskmanager_btn_signup"),
                      labelStyle: Theme.of(context).textTheme.headline2,
                      iconData: Icons.person_add_alt_1_rounded,
                      iconSize: 30,
                      iconColor: Theme.of(context).backgroundColor,
                      iconPosition: ZButtonIconPosition.right,
                      clickHandler: () {
                        PopupManager.instance.show(context: context, popup: PopupType.Signup);
                      },
                    ),
              SizedBox(width: 10),
              _userLogged
                  ? Container()
                  : ZButton(
                      minWidth: 145,
                      height: 40,
                      buttonColor: Colors.white,
                      label: AppLocalizations.of(context).translate("taskmanager_btn_login"),
                      labelStyle: Theme.of(context).textTheme.headline3,
                      iconData: Icons.login,
                      iconSize: 30,
                      iconColor: Theme.of(context).primaryColor,
                      iconPosition: ZButtonIconPosition.right,
                      clickHandler: () {
                        PopupManager.instance.show(context: context, popup: PopupType.Login, callbackAction: (retValue) {});
                      },
                    ),
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
                      child: ZButton(
                        minWidth: 70,
                        height: 40,
                        buttonColor: Colors.white,
                        iconData: Icons.notifications,
                        iconSize: 30,
                        iconColor: Theme.of(context).primaryColor,
                        clickHandler: () {
                          _onOpenNotifications();
                        },
                      ),
                    ),
              SizedBox(width: 10),
              !_userLogged ? Container() : TaskManagerSettingsButton()
            ],
          ),
        ));
  }
}
