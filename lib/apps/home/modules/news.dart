import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class HomeModuleNews extends StatefulWidget {
  HomeModuleNews();
  HomeModuleNewsState createState() => HomeModuleNewsState();
}

class HomeModuleNewsState extends State<HomeModuleNews>{
  HomeModuleNewsState();

  final String htmlFilePath = 'assets/data/home/news.html';

  String fileHtmlContents = "";

   loadLocalHTML() async {
    var contents = await rootBundle.loadString(htmlFilePath);
    if (contents != null) {
      setState(() {
        fileHtmlContents = contents;
      });
    }
    else print("news source not found");
  }

  @override
  void initState() {
    loadLocalHTML();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          // border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getModuleHeader(AppLocalizations.of(context).translate("app_home_module_title_news"), context),
            Padding(
              padding: EdgeInsets.all(7),
              child: SingleChildScrollView(
                  child: HtmlWidget(  fileHtmlContents, textStyle: TextStyle(color: Colors.black ) )
              )
            )
          ],
        )
    );
  }


}