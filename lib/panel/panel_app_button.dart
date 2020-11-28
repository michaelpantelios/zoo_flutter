import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class PanelAppButton extends StatelessWidget {
  PanelAppButton({Key key, @required this.appInfo});

  final AppInfo appInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        print("tap!!");
        context.read<AppProvider>().activate(this.appInfo.id);
      },
      child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            border: Border.all(
              color: Theme.of(context).buttonColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Row(
            children: [
              Container(margin: EdgeInsets.only(right: 10), child: Icon(appInfo.iconPath, color: Theme.of(context).primaryIconTheme.color, size: 32)),
              Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    AppLocalizations.of(context).translate(appInfo.appName),
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.left,
                  )),
              Container()
            ],
          )),
    );
  }
}
