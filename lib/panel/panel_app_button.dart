import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/models/notifications/notification_info.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class PanelAppButton extends StatefulWidget {
  PanelAppButton({Key key, @required this.appInfo});

  final AppInfo appInfo;

  @override
  _PanelAppButtonState createState() => _PanelAppButtonState();
}

class _PanelAppButtonState extends State<PanelAppButton> {
  int _unreadMessengerChats = 0;

  @override
  void initState() {
    super.initState();
    if (widget.appInfo.id == AppType.Messenger) NotificationsProvider.instance.addListener(_onNotification);
  }

  _onNotification() {
    var chatNotification = NotificationsProvider.instance.notifications.firstWhere((element) => element.name == NotificationType.ON_MESSENGER_CHAT_MESSAGE, orElse: () => null);

    setState(() {
      if (chatNotification != null) {
        print('NEW!!!!!!!!');
        _unreadMessengerChats++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isActive = context.select((AppProvider appProvider) => appProvider.currentAppInfo).id == this.widget.appInfo.id;
    if (isActive && this.widget.appInfo.id == AppType.Messenger) _unreadMessengerChats = 0;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.read<AppProvider>().activate(this.widget.appInfo.id, context);
      },
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: EdgeInsets.only(left: 7, top: 7, right: 7, bottom: 7),
            decoration: BoxDecoration(gradient: isActive ? LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xffD7E4FF), Colors.white]) : LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.white, Colors.white])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(
                    widget.appInfo.iconImagePath,
                    color: isActive ? Theme.of(context).primaryColor : Theme.of(context).textTheme.headline5.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context).translate(widget.appInfo.appName),
                    style: isActive ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.left,
                  ),
                ),
                Spacer(),
                (_unreadMessengerChats > 0 && !isActive && this.widget.appInfo.id == AppType.Messenger)
                    ? Text(
                        "(${_unreadMessengerChats.toString()})",
                        style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                      )
                    : Container()
              ],
            ),
          )),
    );
  }
}
