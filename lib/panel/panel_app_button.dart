import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class PanelAppButton extends StatelessWidget {
  PanelAppButton({Key key, @required this.appInfo});

  final AppInfo appInfo;

  @override
  Widget build(BuildContext context) {
    var isActive = context.select((AppProvider appProvider) => appProvider.currentAppInfo).id == this.appInfo.id;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.read<AppProvider>().activate(this.appInfo.id, context);
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
                    appInfo.iconImagePath,
                    color: isActive ? Theme.of(context).primaryColor : Theme.of(context).textTheme.headline5.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context).translate(appInfo.appName),
                    style: isActive ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
