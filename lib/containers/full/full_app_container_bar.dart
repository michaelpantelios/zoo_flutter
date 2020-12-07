import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar_button.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class FullAppContainerBar extends StatefulWidget {
  FullAppContainerBar({Key key, @required this.title, @required this.iconData});

  final String title;
  final IconData iconData;

  @override
  FullAppContainerBarState createState() => FullAppContainerBarState();
}

class FullAppContainerBarState extends State<FullAppContainerBar> {
  FullAppContainerBarState({Key key});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userLogged = context.select((UserProvider p) => p.logged);
    return Container(
        color: Theme.of(context).primaryColor,
        child: Row(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(3),
            child: Icon(
              widget.iconData,
              size: 25,
              color: Colors.white,
            ),
          ),
          Expanded(child: Padding(padding: EdgeInsets.only(top: 5, bottom: 5, right: 10), child: Text(AppLocalizations.of(context).translate(widget.title), style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.left))),
          userLogged ? Container() : FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Login)),
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Star)) : Container() ,
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Coins)) : Container(),
          userLogged ? FullAppContainerBarButton(popupInfo: PopupManager.instance.getPopUpInfo(PopupType.Settings)): Container() ,
          // FullAppContainerBarButton(popupInfo: DataMocker.apps["notificationsDropdown"]),
          // FullAppContainerBarButton(popupInfo: DataMocker.apps["settingsDropdown"])
        ]));
  }
}
