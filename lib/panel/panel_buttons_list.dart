import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/panel/panel_app_button.dart';
import 'package:zoo_flutter/providers/app_provider.dart';

class PanelButtonsList extends StatelessWidget {
  final List<AppInfo> buttonsInfo = [
    AppProvider.instance.getAppInfo(AppType.Home),
    AppProvider.instance.getAppInfo(AppType.Chat),
    AppProvider.instance.getAppInfo(AppType.Multigames),
    AppProvider.instance.getAppInfo(AppType.Forum),
    AppProvider.instance.getAppInfo(AppType.Search),
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
                })));
  }
}
