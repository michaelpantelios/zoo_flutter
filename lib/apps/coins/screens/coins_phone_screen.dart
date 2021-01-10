import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class CoinsPhoneScreen extends StatelessWidget {
  CoinsPhoneScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _appSize.height - 10,
        color: Color(0xFFffffff),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.all(10), child: FaIcon(FontAwesomeIcons.coins, size: 50, color: Colors.orange)),
                Container(
                    width: _appSize.width - 80,
                    child: HTML.toRichText(context, AppLocalizations.of(context).translateWithArgs("app_coins_tl_txtHeader", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsNumber"]]), overrideStyle: {
                      "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 18),
                    }))
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
                child: HTML.toRichText(context, AppLocalizations.of(context).translateWithArgs("app_coins_tl_txtStep1", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsGateway"]]), overrideStyle: {
                  "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 12),
                })),
            Padding(
                padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
                child: HTML.toRichText(context, AppLocalizations.of(context).translateWithArgs("app_coins_tl_txtStep2", [UserProvider.instance.userInfo.userId.toString()]), overrideStyle: {
                  "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 12),
                })),
            Padding(
                padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
                child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_tl_credits_fixed", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsFixedCost"] + " " + DataMocker.premiumCoinsPhoneSettings["phoneCoinsProvider"]]),
                    style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal), textAlign: TextAlign.left)),
            Padding(
                padding: EdgeInsets.only(left: 60, bottom: 5, right: 5, top: 5),
                child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_tl_credits_cell", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsCellCost"] + " " + DataMocker.premiumCoinsPhoneSettings["phoneCoinsProvider"]]),
                    style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal), textAlign: TextAlign.left)),
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: _appSize.width * 0.3,
              child: RaisedButton(
                onPressed: () {
                  onBackHandler();
                },
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.arrow_back, size: 20, color: Colors.black)),
                    Text(
                      AppLocalizations.of(context).translate("app_coins_sm_btnBack"),
                      style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
