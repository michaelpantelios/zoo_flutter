import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:html';
import 'package:zoo_flutter/js/zoo_lib.dart';

import 'package:zoo_flutter/widgets/z_banner.dart';

class PanelBanners extends StatelessWidget {
  PanelBanners();


  final String htmlFilePath = 'assets/data/banners/sidestamp1.html';

  double bannersSpace = 10;

  static getFilePath(String filename) {
    if (window.location.href.contains("localhost")) return "assets/data/banners/$filename.html";
    return Zoo.relativeToAbsolute("assets/assets/data/banners/$filename.html");
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: bannersSpace),
      ZBanner(getFilePath("sidestamp1"), "1"),
      SizedBox(height: bannersSpace),
      ZBanner(getFilePath("sidestamp2"), "2"),
      SizedBox(height: bannersSpace),
      ZBanner(getFilePath("sidestamp3"), "3"),
      SizedBox(height: bannersSpace),
      ZBanner(getFilePath("sidestamp4"), "4")

    ]);
  }
}
