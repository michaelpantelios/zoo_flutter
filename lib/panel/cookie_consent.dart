import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class CookieConsent extends StatefulWidget {
  CookieConsent({@required this.onCookieConsent});

  final Function onCookieConsent;
  static double myHeight = 200;
  static double myWidth = GlobalSizes.panelWidth;
  
  @override
  CookieConsentState createState() => CookieConsentState();
}

class CookieConsentState extends State<CookieConsent>{
  CookieConsentState();

  onLearnMore() async {
    if (await canLaunch(Utils.privacyTerms)) {
      await launch(Utils.privacyTerms);
    } else {
     throw 'Could not launch userTerms';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: CookieConsent.myWidth,
        height: CookieConsent.myHeight,
        decoration: BoxDecoration(
          color: Color(0xeedddddd),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9.0),
            topRight: Radius.circular(9.0),
          ),
        ),
      child: Column(
          children: [
            Container(
              width: CookieConsent.myWidth - 20,
              child: Text(AppLocalizations.of(context).translate("cookie_consent_banner_text"),
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Container(
                width: CookieConsent.myWidth - 20,
                margin: EdgeInsets.only(top: 10),
                child: ZButton(
                  minWidth: GlobalSizes.panelWidth - 20,
                  height: 20,
                  buttonColor: Colors.white,
                  label: AppLocalizations.of(context).translate("cookie_consent_banner_learn_more"),
                  labelStyle: TextStyle(color: Theme.of(context).buttonColor, fontSize: 12, fontWeight: FontWeight.normal),
                  clickHandler: onLearnMore,
                  hasBorder: true,
                  borderWidth: 2,
                  borderColor: Theme.of(context).buttonColor,
                )
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: ZButton(
                    minWidth: GlobalSizes.panelWidth - 20,
                    height: 20,
                    buttonColor: Theme.of(context).buttonColor,
                    label: AppLocalizations.of(context).translate("cookie_consent_banner_button_ok"),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
                    clickHandler: widget.onCookieConsent,
                    hasBorder: false
                )
            ),
          ],
        )
    );
  }
  
  
}

