import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar_button.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

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
          userLogged
              ? Tooltip(
                  message: AppLocalizations.of(context).translate("logout"),
                  textStyle: TextStyle(fontSize: 14),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      new BoxShadow(color: Color(0xaa000000), offset: new Offset(2.0, 2.0), blurRadius: 6, spreadRadius: 3),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      border: Border.all(
                        color: Theme.of(context).secondaryHeaderColor,
                        width: 1.0,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(
                      onPressed: () => UserProvider.instance.logout(),
                      icon: Icon(Icons.logout, size: 25, color: Colors.white),
                    ),
                  ),
                )
              : Container(),
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Star)) : Container(),
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Coins)) : Container(),
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Settings)) : Container(),
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Profile)) : Container(),
        ],
      ),
    );
  }
}
