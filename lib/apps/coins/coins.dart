import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/coins/screens/sms_screen.dart';
import 'package:zoo_flutter/apps/coins/screens/phone_screen.dart';
import 'package:zoo_flutter/apps/coins/screens/paypal_screen.dart';
import 'package:zoo_flutter/apps/coins/screens/credit_screen.dart';
import 'package:zoo_flutter/apps/coins/screens/paysafe_screen.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

enum PurchaseOption { sms, phone, paypal, card, paysafe }

class Coins extends StatefulWidget {
  Coins({Key  key});

  CoinsState createState() => CoinsState();
}

class CoinsState extends State<Coins> {
  CoinsState({Key key});

  Size _appSize = DataMocker.apps["coins"].size;
  PurchaseOption _purchaseOption;
  int screenToShow = 0;

  @override
  void initState() {
    _purchaseOption = PurchaseOption.sms;
    super.initState();
  }

  onBackHandler(){
    setState(() {
      screenToShow = 0;
    });
  }

  changeScreen(){
    setState(() {
      switch(_purchaseOption){
        case PurchaseOption.sms :
          screenToShow = 1;
          break;
        case PurchaseOption.phone :
          screenToShow = 2;
          break;
        case PurchaseOption.paypal:
          screenToShow = 3;
          break;
        case PurchaseOption.card:
          screenToShow = 4;
          break;
        case PurchaseOption.paysafe:
          screenToShow = 5;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getListTileOption(Widget tileIcon, String titleCode, PurchaseOption optionValue){
      return Row(
        children: [
          SizedBox(width: 10),
          Container(
              width: 60,
              margin: EdgeInsets.only(left: 10),
              child: tileIcon),
          Container(
              width: _appSize.width - 100,
              child: RadioListTile<PurchaseOption>(
                title: Text(
                    AppLocalizations.of(context)
                        .translate(titleCode),
                    style: Theme.of(context).textTheme.headline4),
                selected: optionValue == _purchaseOption,
                value: optionValue,
                groupValue: _purchaseOption,
                onChanged: (PurchaseOption value) {
                  setState(() {
                    _purchaseOption = value;
                    print("_purchaseOption = " +
                        _purchaseOption.toString());
                  });
                },
              ))
        ],
      );
    }

    getHomeScreen(){
      return Container(
          color: Theme.of(context).canvasColor,
          height: _appSize.height - 10,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: FaIcon(FontAwesomeIcons.coins,
                          size: 50, color: Colors.orange)),
                  Container(
                      padding: EdgeInsets.all(5),
                      width: _appSize.width - 100,
                      // height: 100,
                      child: Text(
                          AppLocalizations.of(context)
                              .translate("app_coins_pm_txtHeader"),
                          style: Theme.of(context).textTheme.headline4)),
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Divider(
                    height: 1,
                    color: Colors.grey,
                    thickness: 1,
                  )),
              getListTileOption(FaIcon(FontAwesomeIcons.sms,
                  size: 40, color: Colors.blue), "app_coins_pm_pm1", PurchaseOption.sms ),
              SizedBox(height: 10),
              getListTileOption(FaIcon(FontAwesomeIcons.phone,
                  size: 40, color: Colors.red), "app_coins_pm_pm2", PurchaseOption.phone ),
              SizedBox(height: 10),
              getListTileOption(FaIcon(FontAwesomeIcons.ccPaypal,
                  size: 40, color: Colors.blue), "app_coins_pm_pm3", PurchaseOption.paypal ),
              SizedBox(height: 10),
              getListTileOption(FaIcon(FontAwesomeIcons.solidCreditCard,
                  size: 40, color: Colors.deepPurple), "app_coins_pm_pm4", PurchaseOption.card ),
              SizedBox(height: 10),
              getListTileOption(FaIcon(FontAwesomeIcons.creditCard,
                  size: 40, color: Colors.green), "app_coins_pm_pm5", PurchaseOption.paysafe ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Divider(
                    height: 1,
                    color: Colors.grey,
                    thickness: 1,
                  )),
              Expanded(child: Container()),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width:_appSize.width / 2,
                          child: Html(
                              data: AppLocalizations.of(context).translateWithArgs("app_coins_pm_lblCoins", ["80"]),
                              style: {
                                "html": Style(
                                    backgroundColor: Colors.white,
                                    color: Colors.black),
                              })
                      ),
                      Container(
                          width: _appSize.width * 0.3,
                          child: RaisedButton(
                            onPressed:(){
                             changeScreen();
                            },
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate("app_coins_pm_btnContinue"),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Icon(Icons.arrow_right_alt, size: 20, color:Colors.black)
                              ],
                            ),
                          )
                      )
                    ],
                  )
              )
            ],
          ));
    }

    switch(screenToShow){
      case 0:
       return getHomeScreen();
      case 1:
        return SmsScreen(onBackHandler, _appSize);
      case 2:
        return PhoneScreen(onBackHandler, _appSize);
      case 3:
        return PayPalScreen(onBackHandler, _appSize);
      case 4:
        return CreditScreen(onBackHandler, _appSize);
      case 5:
        return PaySafeScreen(onBackHandler, _appSize);
    }
  }
}