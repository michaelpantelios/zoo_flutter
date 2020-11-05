import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/coins/screens/sms_screen.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

enum PurchaseOption { sms, phone, paypal, card, paysafe }

class Coins extends StatefulWidget {
  Coins({Key  key, this.onResizeHandler});

  final Function onResizeHandler;

  CoinsState createState() => CoinsState();
}

class CoinsState extends State<Coins> {
  CoinsState({Key key});

  Size _appSize = DataMocker.apps["coins"].size;
  PurchaseOption _purchaseOption;
  int screenToShow = 0;

  @override
  void initState() {
    super.initState();
  }

  onBackHandler(){
    screenToShow = 0;
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
    getHomeScreen(){
      return Container(
          color: Theme.of(context).canvasColor,
          // padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: FaIcon(FontAwesomeIcons.coins,
                          size: 50, color: Colors.orange)),
                  Container(
                      padding: EdgeInsets.all(5),
                      width: _appSize.width - 90,
                      // height: 100,
                      child: Text(
                          AppLocalizations.of(context)
                              .translate("app_coins_pm_txtHeader"),
                          style: Theme.of(context).textTheme.bodyText1)),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 25, left: 5, right: 5, bottom: 5),
                  child: Divider(
                    height: 1,
                    color: Colors.grey,
                    thickness: 1,
                  )),
              Row(
                children: [
                  Container(
                      width: 30,
                      margin: EdgeInsets.only(left: 10),
                      child: FaIcon(FontAwesomeIcons.sms,
                          size: 20, color: Colors.blue)),
                  Container(
                      width: _appSize.width - 60,
                      child: RadioListTile<PurchaseOption>(
                        title: Text(
                            AppLocalizations.of(context)
                                .translate("app_coins_pm_pm1"),
                            style: Theme.of(context).textTheme.bodyText1),
                        selected: true,
                        value: PurchaseOption.sms,
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
              ),
              Row(
                children: [
                  Container(
                      width: 30,
                      margin: EdgeInsets.only(left: 10),
                      child: FaIcon(FontAwesomeIcons.phone,
                          size: 20, color: Colors.red)),
                  Container(
                      width: _appSize.width - 60,
                      child: RadioListTile<PurchaseOption>(
                        title: Text(
                            AppLocalizations.of(context)
                                .translate("app_coins_pm_pm2"),
                            style: Theme.of(context).textTheme.bodyText1),
                        selected: true,
                        value: PurchaseOption.phone,
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
              ),
              Row(
                children: [
                  Container(
                      width: 30,
                      margin: EdgeInsets.only(left: 10),
                      child: FaIcon(FontAwesomeIcons.ccPaypal,
                          size: 20, color: Colors.blue)),
                  Container(
                      width: _appSize.width - 60,
                      child: RadioListTile<PurchaseOption>(
                        title: Text(
                            AppLocalizations.of(context)
                                .translate("app_coins_pm_pm3"),
                            style: Theme.of(context).textTheme.bodyText1),
                        selected: true,
                        value: PurchaseOption.paypal,
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
              ),
              Row(
                children: [
                  Container(
                      width: 30,
                      margin: EdgeInsets.only(left: 10),
                      child: FaIcon(FontAwesomeIcons.solidCreditCard,
                          size: 20, color: Colors.deepPurple)),
                  Container(
                      width: _appSize.width - 60,
                      child:  RadioListTile<PurchaseOption>(
                        title: Text(
                            AppLocalizations.of(context).translate("app_coins_pm_pm4"),
                            style: Theme.of(context).textTheme.bodyText1),
                        selected: true,
                        value: PurchaseOption.card,
                        groupValue: _purchaseOption,
                        onChanged: (PurchaseOption value) {
                          setState(() {
                            _purchaseOption = value;
                            print("_purchaseOption = " + _purchaseOption.toString());
                          });
                        },
                      )
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 30,
                      margin: EdgeInsets.only(left: 10),
                      child: FaIcon(FontAwesomeIcons.creditCard,
                          size: 20, color: Colors.green)),
                  Container(
                      width: _appSize.width - 60,
                      child:  RadioListTile<PurchaseOption>(
                        title: Text(
                            AppLocalizations.of(context).translate("app_coins_pm_pm5"),
                            style: Theme.of(context).textTheme.bodyText1),
                        selected: true,
                        value: PurchaseOption.paysafe,
                        groupValue: _purchaseOption,
                        onChanged: (PurchaseOption value) {
                          setState(() {
                            _purchaseOption = value;
                            print("_purchaseOption = " + _purchaseOption.toString());
                          });
                        },
                      )
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Divider(
                    height: 1,
                    color: Colors.grey,
                    thickness: 1,
                  )),
              SizedBox(height: 65),
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
    }
  }
}
