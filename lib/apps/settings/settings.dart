import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:zoo_flutter/apps/settings/settings_button.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/settings/screens/myAccountSettingsScreen.dart';
import 'package:zoo_flutter/apps/settings/screens/facebookSettingsScreen.dart';

class Settings extends StatefulWidget {
  Settings();

  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  SettingsState();

  Size _appSize = DataMocker.apps["settings"].size;

  Map<String, GlobalKey<SettingsButtonState>> settingsButtonKeys;
  GlobalKey<SettingsButtonState> myAccountSettingsKey;
  GlobalKey<SettingsButtonState> fbSettingsKey;

  String selectedButtonId = "myAccount";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(updateSettingsButtons);
    settingsButtonKeys = new Map<String, GlobalKey<SettingsButtonState>>();

    myAccountSettingsKey = new GlobalKey<SettingsButtonState>();
    fbSettingsKey = new GlobalKey<SettingsButtonState>();

    settingsButtonKeys["myAccount"] = myAccountSettingsKey;
    settingsButtonKeys["facebook"] = fbSettingsKey;

    print("_appSize = "+_appSize.width.toString());
    super.initState();
  }

  onSettingsButtonTap(String id){
    print("tapped on :"+id);
    setState(() {
      selectedButtonId = id;
      updateSettingsButtons(null);
    });
  }

  updateSettingsButtons(_){
    settingsButtonKeys.forEach((key, value) => value.currentState.setActive(key == selectedButtonId));
  }

  getScreen(){
    switch(selectedButtonId) {
      case "myAccount" :
        return MyAccountSettingsScreen(mySize: new Size(_appSize.width - 205, _appSize.height - 10));
      case "facebook" :
        return FacebookSettingsScreen(mySize: new Size(_appSize.width - 205, _appSize.height - 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: EdgeInsets.all(5),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 180,
            height: _appSize.height - 15,
            padding: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.black26, width: 2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
          ),
          SizedBox(width:5),
          Container(
              width: _appSize.width - 205,
              child: Center(
                child: getScreen()
              )
          )
        ],
      )
    );
  }
}