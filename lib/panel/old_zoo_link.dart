import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

Widget oldZooLink(BuildContext context) {
  return Center(
      child: FlatButton(
    color: Theme.of(context).canvasColor,
    onPressed: () async {
      var url = Env.oldZooUri;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    },
    child: HTML.toRichText(context, AppLocalizations.of(context).translate("panel_link_to_old_zoo"), overrideStyle: {
      "html": TextStyle(
          // backgroundColor: Colors.white,
          color: Colors.black,
          fontSize: 12),
      "span": TextStyle(color: Colors.blue)
    }),
  ));
}
