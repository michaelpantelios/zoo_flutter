import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/settings/screens/blocked_users_screen.dart';
import 'package:zoo_flutter/apps/settings/screens/facebookSettingsScreen.dart';
import 'package:zoo_flutter/apps/settings/screens/myAccountSettingsScreen.dart';
import 'package:zoo_flutter/apps/settings/settings_button.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class Settings extends StatefulWidget {
  final Size size;
  final Function(bool value) setBusy;
  final dynamic options;
  Settings({@required this.size, this.setBusy, this.options});

  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  SettingsState();
  Map<String, GlobalKey<SettingsButtonState>> settingsButtonKeys;

  GlobalKey<SettingsButtonState> myAccountSettingsKey;
  GlobalKey<SettingsButtonState> fbSettingsKey;
  GlobalKey<SettingsButtonState> blockedUsersSettingsKey;

  String selectedButtonId = "myAccount";
  int _selectedIndex = 0;

  RPC _rpc;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(updateSettingsButtons);
    settingsButtonKeys = new Map<String, GlobalKey<SettingsButtonState>>();

    myAccountSettingsKey = new GlobalKey<SettingsButtonState>();
    fbSettingsKey = new GlobalKey<SettingsButtonState>();
    blockedUsersSettingsKey = new GlobalKey<SettingsButtonState>();

    _rpc = RPC();

    settingsButtonKeys["myAccount"] = myAccountSettingsKey;
    settingsButtonKeys["facebook"] = fbSettingsKey;
    settingsButtonKeys["blocked"] = blockedUsersSettingsKey;

    super.initState();
  }

  updateSettingsButtons(_) {
    settingsButtonKeys.forEach((key, value) => value.currentState.setActive(key == selectedButtonId));
  }

  onSettingsButtonTap(String id) {
    print("tapped on :" + id);
    setState(() {
      selectedButtonId = id;
      if (id == "myAccount") {
        _selectedIndex = 0;
      } else if (id == "facebook") {
        _selectedIndex = 1;
      } else if (id == "blocked") {
        _selectedIndex = 2;
      }

      updateSettingsButtons(null);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.options != null && ["park_at"] != null) {
      var parkedAt = widget.options["park_at"].toString();
      Future.delayed(Duration(milliseconds: 100), () {
        onSettingsButtonTap(parkedAt);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SettingsButton(
              key: myAccountSettingsKey,
              id: "myAccount",
              icon: "profile_icon_settings",
              title: AppLocalizations.of(context).translate("app_settings_lblAccount"),
              onTapHandler: onSettingsButtonTap,
            ),
            SettingsButton(
              key: fbSettingsKey,
              id: "facebook",
              icon: "fb_icon_settings",
              title: AppLocalizations.of(context).translate("app_settings_txtFBTitle"),
              onTapHandler: onSettingsButtonTap,
            ),
            SettingsButton(
              key: blockedUsersSettingsKey,
              id: "blocked",
              icon: "block_icon_settings",
              title: AppLocalizations.of(context).translate("app_settings_blocked_users"),
              onTapHandler: onSettingsButtonTap,
            )
          ],
        ),
        Container(
          width: widget.size.width - 205,
          child: Center(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                MyAccountSettingsScreen(
                  mySize: new Size(widget.size.width - 205, widget.size.height - 10),
                  setBusy: (value) => widget.setBusy(value),
                ),
                FacebookSettingsScreen(
                  mySize: new Size(widget.size.width - 205, widget.size.height - 10),
                  setBusy: (value) => widget.setBusy(value),
                ),
                BlockedUsersScreen(
                  mySize: new Size(widget.size.width - 205, widget.size.height - 10),
                  setBusy: (value) => widget.setBusy(value),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
