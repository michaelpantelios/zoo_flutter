import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar_button.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

import 'full_app_tab_bar.dart';

class FullAppContainerBar extends StatelessWidget {
  final AppInfo appInfo;
  FullAppContainerBar({Key key, @required this.appInfo});

  @override
  Widget build(BuildContext context) {
    var userLogged = context.select((UserProvider p) => p.logged);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          FullAppTabBar(appInfo),
          Spacer(),
          userLogged ? Container() : FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Login)),
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Star)) : Container(),
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Coins)) : Container(),
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Settings)) : Container(),
          // FullAppContainerBarButton(popupInfo: DataMocker.apps["notificationsDropdown"]),
          // FullAppContainerBarButton(popupInfo: DataMocker.apps["settingsDropdown"])
        ],
      ),
    );
  }
}
