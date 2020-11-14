import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:zoo_flutter/apps/settings/settings_button.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class Settings extends StatefulWidget {
  Settings();

  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  SettingsState();

  List<GlobalKey<SettingsButtonState>> settingsButtonKeys;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Column(
              children: [
                FlatButton(

                )
              ],
            )
          )
        ],
      )
    );
  }
}