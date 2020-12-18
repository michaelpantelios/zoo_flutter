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
        context.read<AppProvider>().activate(this.appInfo.id);
        context.read<NotificationsProvider>().removeNotificationsOfType(this.appInfo.id);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepOrange : Theme.of(context).buttonColor,
          border: Border.all(
            color: Theme.of(context).buttonColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 30),
              child: Icon(
                appInfo.iconPath,
                color: Theme.of(context).primaryIconTheme.color,
                size: 32,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Text(
                AppLocalizations.of(context).translate(appInfo.appName),
                style: Theme.of(context).textTheme.headline1,
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
                        color: Theme.of(context).buttonColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(1.0),
                      ),
                    ),
                    child: Text(
                      appButtonNotifications.toString(),
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
