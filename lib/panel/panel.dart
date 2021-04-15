// Widget that resides on the left side
// containing current app info (online users etc),
// apps icons, logout button

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/panel/panel_buttons_list.dart';
import 'package:zoo_flutter/panel/panel_header.dart';
import 'package:zoo_flutter/panel/panel_banners.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/panel/cookie_consent.dart';

import '../main.dart';

class Panel extends StatefulWidget {
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  List<AppInfo> _buttonsInfo;
  Widget cookieConsentBanner;
  bool showBanners = false;


  @override
  void initState() {
    UserProvider.instance.addListener(onUserLoggedIn);
    _buttonsInfo = [];
    AppType.values.forEach((app) {
      var popupInfo = AppProvider.instance.getAppInfo(app);
      if (popupInfo.hasPanelShortcut) {
        _buttonsInfo.add(AppProvider.instance.getAppInfo(app));
      }
    });

    if (!UserProvider.instance.cookieConsent)
      cookieConsentBanner = CookieConsent(onCookieConsent: onCookieConsentOk);
     else {
      cookieConsentBanner = Container();
      showBanners = true;
     }
    super.initState();
  }

  onCookieConsentOk(){
    print("cookie consent ok");
    UserProvider.instance.cookieConsent = true;
    setState(() {
      cookieConsentBanner = Container();
      showBanners = true;
    });
  }

  onUserLoggedIn(){
    print("onUserLoggedIn");
    if (UserProvider.instance.logged){
      UserProvider.instance.removeListener(onUserLoggedIn);
      print("----------------->>>> USER LOGGED");
      setState(() { });
    }

  }


  @override
  Widget build(BuildContext context) {
    print("panel build");
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: GlobalSizes.panelWidth,
          height: Root.AppSize.height - GlobalSizes.taskManagerHeight,
          padding: EdgeInsets.only(left: 10, top: 10),
          child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PanelHeader(),
                  PanelButtonsList(_buttonsInfo),
                  showBanners ? PanelBanners() : Container()
                ],
              ),
        ),
        cookieConsentBanner
      ],
    );
  }
}
