// Widget that resides on the left side
// containing current app info (online users etc),
// apps icons, logout button

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/panel/panel_buttons_list.dart';
import 'package:zoo_flutter/panel/panel_header.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/panel/old_zoo_link.dart';

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
    return Container(
      width: 300,
      color: Color(0xFF07438c),
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              PanelHeader(),
              SizedBox(height: 10),
              PanelButtonsList(_buttonsInfo),
              oldZooLink(context)
            ],
          )),
    );
  }
}
