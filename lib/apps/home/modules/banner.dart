import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeModuleBanner extends StatefulWidget {
  HomeModuleBanner();
  HomeModuleBannerState createState() => HomeModuleBannerState();
}

class HomeModuleBannerState extends State<HomeModuleBanner> {
  HomeModuleBannerState();

  final String _targetLink = "https://partners.novibet.com/redirect.aspx?pid=4005&bid=1988";
  final String bannerSrcPath = 'assets/data/home/banner.html';

  String _bannerContents = "";

  loadLocalHTML() async {
    var contents = await rootBundle.loadString(bannerSrcPath);
    if (contents != null) {
      setState(() {
        _bannerContents = contents;
      });
    } else
      print("banner source not found");
  }

  @override
  void initState() {
    loadLocalHTML();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () async {
          if (await canLaunch(_targetLink)) {
            await launch(_targetLink);
          } else {
            throw 'Could not launch $_targetLink';
          }
        },
        child: Image.asset("assets/images/home/banner.gif")
        // HtmlWidget(_bannerContents)
    );
  }
}
