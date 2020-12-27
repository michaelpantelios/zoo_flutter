import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class FullAppTabBar extends StatelessWidget {
  final AppInfo appInfo;
  FullAppTabBar(this.appInfo);
  @override
  Widget build(BuildContext context) {
    var nestedApps = context.watch<AppBarProvider>().getNestedApps(appInfo.id);
    return nestedApps.length == 0 ? _simpleTab(context) : _multipleAppTabs(context, nestedApps);
  }

  Widget _simpleTab(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            appInfo.iconPath,
            size: 25,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
          child: Text(
            AppLocalizations.of(context).translate(appInfo.appName),
            style: TextStyle(
                fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _advancedTab(BuildContext context, NestedAppInfo nestedInfoApp) {
    var nestedApps = context.watch<AppBarProvider>().getNestedApps(appInfo.id);
    // print("_advancedTab - nestedApps: ${nestedApps}");
    NestedAppInfo activeNestedApp = nestedApps.firstWhere((item) => item.active == true, orElse: () => null);
    // print("activeNestedApp: ${activeNestedApp}");
    var tabIsActive = false;
    if (nestedInfoApp == null) {
      if (activeNestedApp == null) {
        tabIsActive = true;
      } else {
        tabIsActive = false;
      }
    } else {
      if (activeNestedApp == null) {
        tabIsActive = false;
      } else {
        tabIsActive = activeNestedApp.id == nestedInfoApp.id;
      }
    }
    return GestureDetector(
      onTap: () {
        var tabID = nestedInfoApp == null ? appInfo.id : nestedInfoApp.id;
        print("tabID : $tabID");

        context.read<AppBarProvider>().activateApp(appInfo.id, nestedInfoApp);
      },
      child: Container(
        height: 35,
        color: tabIsActive ? Colors.green : Colors.blueGrey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            nestedInfoApp == null
                ? Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      appInfo.iconPath,
                      size: 25,
                      color: Colors.white,
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 10),
              child: Text(
                nestedInfoApp == null ? AppLocalizations.of(context).translate(appInfo.appName) : nestedInfoApp.title,
                style: TextStyle(
                    fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            nestedInfoApp != null
                ? Padding(
                    padding: EdgeInsets.all(3),
                    child: GestureDetector(
                      onTap: () {
                        context.read<AppBarProvider>().removeNestedApp(appInfo.id, nestedInfoApp);
                      },
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _multipleAppTabs(BuildContext context, List<NestedAppInfo> nestedApps) {
    List<Widget> lst = [];
    lst.add(SizedBox(width: 5));
    lst.add(_advancedTab(context, null));
    nestedApps.forEach((item) {
      lst.add(SizedBox(width: 10));
      lst.add(_advancedTab(context, item));
    });

    return Row(children: lst);
  }
}
