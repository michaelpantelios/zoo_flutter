import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/app_button_info.dart';

import 'package:zoo_flutter/widgets/itemRenderers/AppButton.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class AppButtonsList extends StatelessWidget {
  final List<AppButtonInfo> buttonsInfo = DataMocker.appButtonsList;

  AppButtonsList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            color: Theme.of(context).canvasColor,
            padding: EdgeInsets.all(5),
            child: ListView.separated(
                padding: const EdgeInsets.all(3),
                itemCount: DataMocker.appButtonsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return AppButton(info: buttonsInfo[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 5,
                  );
                })));
  }
}
