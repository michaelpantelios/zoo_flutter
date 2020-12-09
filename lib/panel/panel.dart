// Widget that resides on the left side
// containing current app info (online users etc),
// apps icons, logout button

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/panel/panel_buttons_list.dart';
import 'package:zoo_flutter/panel/panel_header.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class Panel extends StatefulWidget {
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  List<AppInfo> _buttonsInfo;

  @override
  void initState() {
    _buttonsInfo = [];
    AppType.values.forEach((app) {
      var popupInfo = AppProvider.instance.getAppInfo(app);
      if (popupInfo.hasPanelShortcut) {
        _buttonsInfo.add(AppProvider.instance.getAppInfo(app));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var logged = context.select((UserProvider p) => p.logged);
    return Container(
      width: 300,
      color: Theme.of(context).primaryColor,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              PanelHeader(),
              SizedBox(height: 10),
              PanelButtonsList(_buttonsInfo),
              logged ? SizedBox(height: 10) : Container(),
              logged
                  ? FlatButton(
                      onPressed: () => context.read<UserProvider>().logout(),
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              )),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              AppLocalizations.of(context).translate("panel_button_logoff"),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ))
                  : Container()
            ],
          )),
    );
  }
}
