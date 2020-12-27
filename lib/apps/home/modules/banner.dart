import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomeModuleBanner extends StatefulWidget{
  HomeModuleBanner();
  HomeModuleBannerState createState() => HomeModuleBannerState();
}

class HomeModuleBannerState extends State<HomeModuleBanner>{
  HomeModuleBannerState();

  final String bannerSrcPath = 'assets/data/home/banner.html';

  String _bannerContents = "";

  loadLocalHTML() async {
    var contents = await rootBundle.loadString(bannerSrcPath);
    if (contents != null) {
      print("contents = " + contents);
      setState(() {
        _bannerContents = contents;
      });
    }
    else print("banner source not found");
  }

  @override
  void initState(){
    loadLocalHTML();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255,
      child: Center(
          child: HtmlWidget( _bannerContents )
      )
    );
  }
}