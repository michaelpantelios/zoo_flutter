import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/control/user.dart';

class CoinsPhoneScreen extends StatelessWidget{
  CoinsPhoneScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _appSize.height - 10,
      color: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: FaIcon(FontAwesomeIcons.coins,
                      size: 50, color: Colors.orange)),
              Container(
                  width: _appSize.width - 80,
                  child: Html(
                      data: AppLocalizations.of(context).translateWithArgs("app_coins_tl_txtHeader", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsNumber"]]),
                      style: {
                        "html": Style(
                            backgroundColor: Colors.white,
                            color: Colors.black,
                            fontSize: FontSize.large
                        ),
                      })
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 60, bottom: 5, right:5, top: 5),
            child: Html(
                data: AppLocalizations.of(context).translateWithArgs("app_coins_tl_txtStep1", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsGateway"]]),
                style: {
                  "html": Style(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      fontSize: FontSize.medium,
                    textAlign: TextAlign.left
                  ),
                })
          ),
          Padding(
              padding: EdgeInsets.only(left: 60, bottom: 5, right:5, top: 5),
              child: Html(
                  data: AppLocalizations.of(context).translateWithArgs("app_coins_tl_txtStep2", [User.instance.userInfo.userId.toString()]),
                  style: {
                    "html": Style(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontSize: FontSize.medium,
                        textAlign: TextAlign.left
                    ),
                  })
          ),
          Padding(
              padding: EdgeInsets.only(left: 60, bottom: 5, right:5, top: 5),
              child: Text(
                  AppLocalizations.of(context).translateWithArgs("app_coins_tl_credits_fixed", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsFixedCost"] + " " + DataMocker.premiumCoinsPhoneSettings["phoneCoinsProvider"]]),
                  style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left)
          ),
          Padding(
              padding: EdgeInsets.only(left: 60, bottom: 5, right:5, top: 5),
              child: Text(
                  AppLocalizations.of(context).translateWithArgs("app_coins_tl_credits_cell", [DataMocker.premiumCoinsPhoneSettings["phoneCoinsCellCost"] + " " + DataMocker.premiumCoinsPhoneSettings["phoneCoinsProvider"]]),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left)
          ),
          Expanded(child:Container()),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            width: _appSize.width * 0.3,
            child: RaisedButton(
              onPressed:(){
                onBackHandler();
              },
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding( padding: EdgeInsets.only(right: 5), child:Icon(Icons.arrow_back, size: 20, color:Colors.black) ),
                  Text(
                    AppLocalizations.of(context).translate("app_coins_sm_btnBack"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          )

        ],
      )
    );
  }
}