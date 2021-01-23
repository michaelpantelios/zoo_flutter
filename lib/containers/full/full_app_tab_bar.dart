import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class TabInfo {
  TabInfo(this.times, this.timer, this.color);
  int times = 0;
  Timer timer;
  Color color;

  @override
  String toString() {
    return "times: $times, timer: $timer, color: $color";
  }
}

class FullAppTabBar extends StatefulWidget {
  final AppInfo appInfo;
  FullAppTabBar({Key key, this.appInfo}) : super(key: key);

  @override
  _FullAppTabBarState createState() => _FullAppTabBarState();
}

class _FullAppTabBarState extends State<FullAppTabBar> {
  Map<String, TabInfo> _flashingTabs = Map<String, TabInfo>();
  @override
  void initState() {
    super.initState();
    AppBarProvider.instance.addListener(_onAppBarProviderEvent);
  }

  _onAppBarProviderEvent() {
    var nestedApps = AppBarProvider.instance.getNestedApps(widget.appInfo.id);
    print("PRIVATE CHATS: ${nestedApps.length}");
    for (NestedAppInfo nestedApp in nestedApps) {
      if (nestedApp.flash) {
        NestedAppInfo flashingNestedApp = nestedApp;
        bool flashingIsActivated = nestedApps.firstWhere((item) => item.active == true && item.id == flashingNestedApp.id, orElse: () => null) != null;

        if (flashingNestedApp != null && flashingNestedApp.flash) {
          if (_flashingTabs[flashingNestedApp.id] == null) _flashingTabs[flashingNestedApp.id] = TabInfo(0, null, Color(0xff474d68));

          // print('flashingNestedApp: ${_flashingTabs[flashingNestedApp.id]}');
          // print('flashingIsActivated? ${flashingIsActivated}');
          if (flashingIsActivated) {
            flashingNestedApp.flash = false;
          } else if (_flashingTabs[flashingNestedApp.id].times == 0) {
            _flashingTabs[flashingNestedApp.id].timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
              if (!flashingNestedApp.flash) {
                _flashingTabs[flashingNestedApp.id].times = 0;
                // print('STOP FLASHING: ${flashingNestedApp.id}');
                timer.cancel();
                setState(() {
                  _flashingTabs[flashingNestedApp.id].color = Color(0xff474d68);
                });
                return;
              }
              setState(() {
                _flashingTabs[flashingNestedApp.id].color = _flashingTabs[flashingNestedApp.id].times % 2 == 0 ? Colors.purpleAccent : Color(0xff474d68);
                _flashingTabs[flashingNestedApp.id].times++;
              });
            });
          }
        }
      } else {
        if (_flashingTabs[nestedApp.id] != null) {
          _flashingTabs[nestedApp.id].timer.cancel();
          _flashingTabs[nestedApp.id].times = 0;
        }
      }
    }
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
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Image.asset(
            widget.appInfo.iconImagePath,
            color: Theme.of(context).primaryIconTheme.color,
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

    var tabInfo;
    if (nestedInfoApp != null) {
      if (_flashingTabs[nestedInfoApp.id] == null) {
        tabInfo = TabInfo(0, null, Color(0xff474d68));
      } else {
        tabInfo = _flashingTabs[nestedInfoApp.id];
      }
    }

    return GestureDetector(
      onTap: () {
        context.read<AppBarProvider>().activateApp(widget.appInfo.id, nestedInfoApp);
      },
      child: Container(
        height: 35,
        color: tabIsActive
            ? Color(0xffffffff)
            : (nestedInfoApp == null
                ? Color(0xff474d68)
                : tabInfo.color == null
                    ? Color(0xff474d68)
                    : tabInfo.color),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            nestedInfoApp == null
                ? Padding(
                    padding: EdgeInsets.all(3),
                    child: Image.asset(
                      widget.appInfo.iconImagePath,
                      color: tabIsActive ? Color(0xff474d68) : Colors.white,
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 10),
              child: Text(
                nestedInfoApp == null ? AppLocalizations.of(context).translate(widget.appInfo.appName) : nestedInfoApp.title,
                style: tabIsActive
                    ? TextStyle(
                        color: Color(0xff393e54),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      )
                    : TextStyle(
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
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
