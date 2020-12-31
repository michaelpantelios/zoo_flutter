import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

Widget oldZooLink(BuildContext context) {
  return
       Center(
          child: FlatButton(
            color: Theme.of(context).canvasColor,
            onPressed: () async {
              if (await canLaunch(Utils.oldZoo)) {
                await launch(Utils.oldZoo);
              } else {
                throw 'Could not launch $Utils.oldZoo';
              }
            },
            child: Html(
                data:
                    AppLocalizations.of(context).translate("panel_link_to_old_zoo"),
                style: {
                  "html": Style(
                      // backgroundColor: Colors.white,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                      fontSize: FontSize.medium),
                  "span": Style(color: Colors.blue)
                }),
        )
      );
}
