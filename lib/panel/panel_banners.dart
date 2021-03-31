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
class PanelBanners extends StatelessWidget {
  PanelBanners(){
    double availableHeight = Root.AppSize.height - bannersSpace- GlobalSizes.taskManagerHeight - GlobalSizes.fullAppMainPadding - GlobalSizes.panelButtonsHeight -
        (UserProvider.instance.logged ? GlobalSizes.panelHeaderHeight + 2 * GlobalSizes.fullAppMainPadding : 0);
    _availableStampsNum = min((availableHeight / (sideBannerHeight + bannersSpace)).floor(), 4);
    _bannersList.add(SizedBox(height: bannersSpace));
    for (int i=1; i<=_availableStampsNum; i++){
      _bannersList.add(Container(margin: EdgeInsets.only(bottom:bannersSpace), child:
          ZBanner(key:new GlobalKey(), bannerId: i.toString(), bannerSize: new Size(sideBannerWidth, sideBannerHeight))
        )
      );
    }
  }

  int _availableStampsNum;
  double sideBannerWidth = 240;
  double sideBannerHeight = 94;
  double bannersSpace = 10;
  List<Widget> _bannersList = [];

  final String htmlFilePath = 'assets/data/banners/sidestamp1.html';

  static getFilePath(String filename) {
    if (window.location.href.contains("localhost")) return "assets/data/banners/$filename.html";
    return Zoo.relativeToAbsolute("assets/assets/data/banners/$filename.html");
  }

  @override
  Widget build(BuildContext context) {
    return Column(children:
      _bannersList
    );
  }
}
