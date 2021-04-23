import 'dart:math';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:zoo_flutter/js/zoo_lib.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

import 'package:zoo_flutter/widgets/z_banner.dart';
import '../main.dart';

// ignore: must_be_immutable
class PanelBanners extends StatefulWidget {
  PanelBanners();

  @override
  PanelBannersState createState()=>PanelBannersState();
}

class PanelBannersState extends State<PanelBanners>{
  PanelBannersState();

  int _availableStampsNum;
  double sideBannerWidth = 240;
  double sideBannerHeight = 94;
  double bannersSpace = 10;
  List<Widget> _bannersList = [];

  @override
  void initState(){
    super.initState();
  }

  getContents(){
    double availableHeight = Root.AppSize.height - bannersSpace- GlobalSizes.taskManagerHeight - GlobalSizes.fullAppMainPadding - GlobalSizes.panelButtonsHeight -
        (UserProvider.instance.logged ? GlobalSizes.panelHeaderHeight + 2 * GlobalSizes.fullAppMainPadding : 0);
    _availableStampsNum = min((availableHeight / (sideBannerHeight + bannersSpace)).floor(), 4);

    _bannersList = [];
    _bannersList.add(SizedBox(height: bannersSpace));

    for (int i=1; i<=_availableStampsNum; i++){
      _bannersList.add(Container(margin: EdgeInsets.only(bottom:bannersSpace), child:
        ZBanner(key:new GlobalKey(), bannerId: i.toString(), bannerSize: new Size(sideBannerWidth, sideBannerHeight))
      )
      );
    }
    return _bannersList;
  }

  @override
  Widget build(BuildContext context) {
    print("panel banners build");
    return Column(children: getContents()
    );
  }
}
