import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:zoo_flutter/apps/settings/settings_button.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class Settings extends StatefulWidget {
  Settings();

  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  SettingsState();

  Map<String, GlobalKey<SettingsButtonState>> settingsButtonKeys;
  GlobalKey<SettingsButtonState> myAccountSettingsKey;
  GlobalKey<SettingsButtonState> fbSettingsKey;

  String selectedButtonId = "myAccount";


  @override
  void initState() {
    settingsButtonKeys = new Map<String, GlobalKey<SettingsButtonState>>();

    myAccountSettingsKey = new GlobalKey<SettingsButtonState>();
    fbSettingsKey = new GlobalKey<SettingsButtonState>();

    settingsButtonKeys["myAccount"] = myAccountSettingsKey;
    settingsButtonKeys["facebook"] = fbSettingsKey;

    super.initState();
  }

  onSettingsButtonTap(String id){
    print("tapped on :"+id);
    selectedButtonId = id;
    myAccountSettingsKey.currentState.setActive(true);
    // settingsButtonKeys.map((key, value) => value.currentState.setActive(id == key));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Container(
            width: 180,
            child: Column(
              children: [
                SettingsButton(
                  key: myAccountSettingsKey,
                  id : "myAccount",
                  icon : FaIcon(FontAwesomeIcons.edit, color: Colors.green, size: 25),
                  title: AppLocalizations.of(context).translate("app_settings_lblAccount"),
                  onTapHandler: onSettingsButtonTap,
                ),
                SettingsButton(
                  key: fbSettingsKey,
                  id : "facebook",
                  icon : FaIcon(FontAwesomeIcons.facebook, color: Theme.of(context).buttonColor, size: 25 ),
                  title: AppLocalizations.of(context).translate("app_settings_txtFBTitle"),
                  onTapHandler: onSettingsButtonTap,
                )
              ],
            )
          )
        ],
      )
    );
  }
}