import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/apps/app_info.dart';

import 'package:zoo_flutter/panel/panel_app_button.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class PanelButtonsList extends StatelessWidget {
  final List<AppInfo> buttonsInfo = [
     DataMocker.apps["home"],
     DataMocker.apps["chat"],
     DataMocker.apps["multigames"],
     DataMocker.apps["forum"],
     DataMocker.apps["search"]
  ];

  PanelButtonsList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            color: Theme.of(context).canvasColor,
            padding: EdgeInsets.all(5),
            child: ListView.separated(
                padding: const EdgeInsets.all(3),
                itemCount: buttonsInfo.length,
                itemBuilder: (BuildContext context, int index) {
                  return PanelAppButton(appInfo: buttonsInfo[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 5,
                  );
                })
        ));
  }
}
