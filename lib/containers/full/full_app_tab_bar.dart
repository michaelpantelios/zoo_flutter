import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class FullAppTabBar extends StatefulWidget {
  final AppInfo appInfo;
  FullAppTabBar({Key key, this.appInfo}) : super(key: key);

  @override
  _FullAppTabBarState createState() => _FullAppTabBarState();
}

class _FullAppTabBarState extends State<FullAppTabBar> {
  Map<String, Color> _flashingCurrentColor = Map<String, Color>();
  int _timesFlashed = 0;
  @override
  void initState() {
    super.initState();
    AppBarProvider.instance.addListener(() {
      print("AppBarProvider CHANGED!");
      var nestedApps = AppBarProvider.instance.getNestedApps(widget.appInfo.id);
      print("PRIVATE CHATS: ${nestedApps.length}");
      NestedAppInfo flashingNestedApp = nestedApps.firstWhere((item) => item.flash == true, orElse: () => null);
      NestedAppInfo activeNestedApp = nestedApps.firstWhere((item) => item.active == true, orElse: () => null);

      print("flashingNestedApp: ${flashingNestedApp}");
      print("activeNestedApp: ${activeNestedApp}");
      if (flashingNestedApp != null && flashingNestedApp.flash) {
        if (_timesFlashed == 0) {
          Timer.periodic(Duration(milliseconds: 500), (timer) {
            setState(() {
              _timesFlashed++;
              _flashingCurrentColor[flashingNestedApp.id] = _timesFlashed % 2 == 0 ? Colors.purpleAccent : Colors.blueGrey;
              if (_timesFlashed > 5) {
                _flashingCurrentColor[flashingNestedApp.id] = Colors.blueGrey;
                flashingNestedApp.flash = false;
                _timesFlashed = 0;
                timer.cancel();
                print("stop flashing!");
              }
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var nestedApps = context.watch<AppBarProvider>().getNestedApps(widget.appInfo.id);
    return nestedApps.length == 0 ? _simpleTab(context) : _multipleAppTabs(context, nestedApps);
  }

  Widget _simpleTab(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            widget.appInfo.iconPath,
            size: 25,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
          child: Text(
            AppLocalizations.of(context).translate(widget.appInfo.appName),
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _advancedTab(BuildContext context, NestedAppInfo nestedInfoApp) {
    var nestedApps = context.watch<AppBarProvider>().getNestedApps(widget.appInfo.id);
    // print("_advancedTab - nestedApps: ${nestedApps}");
    NestedAppInfo activeNestedApp = nestedApps.firstWhere((item) => item.active == true, orElse: () => null);

    var tabIsActive = false;
    if (nestedInfoApp == null) {
      tabIsActive = activeNestedApp == null;
    } else {
      if (activeNestedApp == null) {
        tabIsActive = false;
      } else {
        tabIsActive = activeNestedApp.id == nestedInfoApp.id;
      }
    }

    return GestureDetector(
      onTap: () {
        context.read<AppBarProvider>().activateApp(widget.appInfo.id, nestedInfoApp);
      },
      child: Container(
        height: 35,
        color: tabIsActive
            ? Colors.green
            : (nestedInfoApp == null
                ? Colors.blueGrey
                : _flashingCurrentColor[nestedInfoApp.id] == null
                    ? Colors.blueGrey
                    : _flashingCurrentColor[nestedInfoApp.id]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            nestedInfoApp == null
                ? Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      widget.appInfo.iconPath,
                      size: 25,
                      color: Colors.white,
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 10),
              child: Text(
                nestedInfoApp == null ? AppLocalizations.of(context).translate(widget.appInfo.appName) : nestedInfoApp.title,
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.left,
              ),
            ),
            nestedInfoApp != null
                ? Padding(
                    padding: EdgeInsets.all(3),
                    child: GestureDetector(
                      onTap: () {
                        context.read<AppBarProvider>().removeNestedApp(widget.appInfo.id, nestedInfoApp);
                      },
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black,
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
