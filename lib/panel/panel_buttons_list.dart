import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/panel/panel_app_button.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class PanelButtonsList extends StatelessWidget {
  final List<AppInfo> buttonsInfo;

  PanelButtonsList(this.buttonsInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: GlobalSizes.panelWidth,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            width: GlobalSizes.panelWidth-20,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              // border: Border.all(color: Colors.deepOrange, width: 3),
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                new BoxShadow(color: Theme.of(context).shadowColor, offset: new Offset(5.0, 5.0), blurRadius: 4, spreadRadius: 5),
              ],
            ),
            alignment: Alignment.center,
            child:  Column(
              children: this.buttonsInfo.map<Widget>((AppInfo info) {
                return PanelAppButton(appInfo: info);
              }).toList(),
            ),
          )
        )
      );
  }
}
