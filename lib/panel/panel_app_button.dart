import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class PanelAppButton extends StatelessWidget {
  PanelAppButton({Key key, @required this.appInfo});

  final AppInfo appInfo;

  @override
  Widget build(BuildContext context) {
    var isActive = context.select((AppProvider appProvider) => appProvider.currentAppInfo).id == this.appInfo.id;
    var appButtonNotifications = context.watch<NotificationsProvider>().notifications.where((item) => item.type == this.appInfo.id).length;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.read<AppProvider>().activate(this.appInfo.id, context);
        context.read<NotificationsProvider>().removeNotificationsOfType(this.appInfo.id);
      },
      child: MouseRegion(
      cursor: SystemMouseCursors.click,
        child: Container(
          padding: EdgeInsets.only(left: 7, top: 7, right: 7, bottom: 7),
          decoration: BoxDecoration(
              gradient: isActive ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xffD7E4FF), Colors.white]) :
              LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.white, Colors.white]
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50,
                child: Icon(
                  appInfo.iconPath,
                  color: isActive ? Theme.of(context).primaryColor : Theme.of(context).textTheme.headline5.color,
                  size: 25,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  AppLocalizations.of(context).translate(appInfo.appName),
                  style: isActive ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(),
              appButtonNotifications > 0 && !isActive
                  ? Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  border: Border.all(
                    color: Color(0xff4083d5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(1.0),
                  ),
                ),
                child: Text(
                  appButtonNotifications.toString(),
                  style: TextStyle(
                      fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
                  : Container(),
            ],
          ),
        )
      ),
    );
  }
}
