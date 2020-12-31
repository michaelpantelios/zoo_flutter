import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/utils/utils.dart';

class FooterLinks extends StatelessWidget {
  FooterLinks();

  _onUseTermsTap() async {
    if (await canLaunch(Utils.userTerms)) {
    await launch(Utils.instance.getHelpUrl());
    } else {
    throw 'Could not launch $Utils.instance.getHelpUrl()';
    }
  }

  _onPrivacyTap() async {
    if (await canLaunch(Utils.privacyTerms)) {
      await launch(Utils.instance.getHelpUrl());
    } else {
      throw 'Could not launch $Utils.instance.getHelpUrl()';
    }
  }

  _onHelpTap() async {
    if (await canLaunch(Utils.instance.getHelpUrl())) {
        await launch(Utils.instance.getHelpUrl());
    } else {
      throw 'Could not launch $Utils.instance.getHelpUrl()';
    }
  }

  _onContactTap(BuildContext context){
    PopupManager.instance.show(context: context, popup: PopupType.Contact, callbackAction: (retValue) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: _onUseTermsTap,
            child: Text(AppLocalizations.of(context).translate("footer_link_use_terms"),
            style: Theme.of(context).textTheme.bodyText1)
          ),
          Padding(
             padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "|", style: Theme.of(context).textTheme.bodyText1
            )
          ),
          FlatButton(
              onPressed: _onPrivacyTap,
              child: Text(AppLocalizations.of(context).translate("footer_link_privacy"),
                  style: Theme.of(context).textTheme.bodyText1)
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                  "|", style: Theme.of(context).textTheme.bodyText1
              )
          ),
          FlatButton(
              onPressed: _onHelpTap,
              child: Text(AppLocalizations.of(context).translate("footer_link_help"),
                  style: Theme.of(context).textTheme.bodyText1)
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                  "|", style: Theme.of(context).textTheme.bodyText1
              )
          ),
          FlatButton(
              onPressed: (){_onContactTap(context);},
              child: Text(AppLocalizations.of(context).translate("footer_link_contact"),
                  style: Theme.of(context).textTheme.bodyText1)
          ),
        ],
      ),

    );
  }
  
  
}
