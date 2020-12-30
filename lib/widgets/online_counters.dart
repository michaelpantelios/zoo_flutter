import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';

class OnlineCounters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(2),
            color: Theme.of(context).backgroundColor,
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).translate("panelHeader_online_counter"),
                  style: TextStyle(
                      fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                Text(
                  "0",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF111111),
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
              ],
            )),
        GestureDetector(
          onTap: (){
            context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.Chat).id, context);
            context.read<NotificationsProvider>().removeNotificationsOfType(AppProvider.instance.getAppInfo(AppType.Chat).id);
          },
          child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(2),
              color: Theme.of(context).backgroundColor,
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context).translate("panelHeader_chat_counter"),
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    "0",
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF111111),
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.left,
                  ),
                ],
              ))
        ),
      ],
    );
  }
}
