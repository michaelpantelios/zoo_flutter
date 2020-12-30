import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar_button.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

import 'full_app_tab_bar.dart';

class FullAppContainerBar extends StatefulWidget {
  final AppInfo appInfo;
  FullAppContainerBar({Key key, @required this.appInfo});

  @override
  _FullAppContainerBarState createState() => _FullAppContainerBarState();
}

class _FullAppContainerBarState extends State<FullAppContainerBar> {
  final GlobalKey _tabBarKey = GlobalKey();
  final GlobalKey _buttonsBarKey = GlobalKey();
  RenderBox _tabBarRenderBox;
  RenderBox _buttonsRenderBox;
  Size _tabBarSize;
  Size _buttonsSize;
  Offset _tabBarOffset;
  Offset _buttonsOffset;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userLogged = context.select((UserProvider p) => p.logged);
    double sizedBoxW = 200;
    if (_tabBarKey.currentContext != null) {
      _tabBarRenderBox = _tabBarKey.currentContext.findRenderObject();
      _tabBarSize = _tabBarRenderBox.size;
      _tabBarOffset = _tabBarRenderBox.localToGlobal(Offset.zero);
      print(_tabBarSize);
      print(_tabBarOffset);

      sizedBoxW = _tabBarSize.width - 300;
    }

    // if (_buttonsBarKey.currentContext != null) {
    //   _buttonsRenderBox = _buttonsBarKey.currentContext.findRenderObject();
    //   _buttonsSize = _buttonsRenderBox.size;
    //   _buttonsOffset = _buttonsRenderBox.localToGlobal(Offset.zero);
    //   print(_buttonsSize);
    //   print(_buttonsOffset);
    //
    //
    // }

    print("sizedBoxW: $sizedBoxW");

    return Container(
      key: _tabBarKey,
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration :  BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(9.0),
              topRight: Radius.circular(9.0))
      ),
      height: GlobalSizes.appBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: sizedBoxW,
            child: SingleChildScrollView(
              child: FullAppTabBar(appInfo: widget.appInfo),
              scrollDirection: Axis.horizontal,
            ),
          ),
          Row(
            key: _buttonsBarKey,
            children: [
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
          )
        ],
      ),
    );
  }
}
