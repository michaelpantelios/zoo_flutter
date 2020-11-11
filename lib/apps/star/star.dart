import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/apps/star/screens/star_paypal_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_credit_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_phone_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_bank_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_sms_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_paysafe_screen.dart';

enum PurchaseOption { paypal, card, phone, bank,  sms,  paysafe }
enum ServiceResStatus { invalid_session, no_login, not_star, star }

class Star extends StatefulWidget {
  Star();

  StarState createState() => StarState();
}

class StarState extends State<Star>{
  StarState();

  Size _appSize = DataMocker.apps["star"].size;
  PurchaseOption _purchaseOption;
  int screenToShow = -1;
  ServiceResStatus _serviceResStatus = ServiceResStatus.not_star;
  String _serviceResDataType = "" ;
  bool isStar;
  bool isStarPermanent;
  bool cancelStar = false;

  walletStarInfoServiceSimulator(Function responder){
    responder();
  }

  walletStarInfoResponse(){
    setState(() {
      screenToShow = 0;

      if (_serviceResStatus == ServiceResStatus.invalid_session) {
        print("invalid_session");
      } else if (_serviceResStatus == ServiceResStatus.no_login){
        print("no_login");
        return;
      } else if(_serviceResStatus == ServiceResStatus.not_star){
        isStar = false;
        return;
      }

      if (_serviceResDataType == "permanent"){
        isStar = true;
        isStarPermanent = true;
        cancelStar = true;
      } else {
        isStar = true;
        isStarPermanent = false;
        cancelStar = false;
      }
    });
  }

  @override
  void initState() {
    print("star initState");
    super.initState();
    _purchaseOption = PurchaseOption.paypal;
    walletStarInfoServiceSimulator(walletStarInfoResponse);
  }

  cancelStarSubscription(){
    print("cancelStar");
  }

  goToPaymentsScreen(){
    setState(() {
      screenToShow = 1;
    });
  }
  
  goToWelcomeScreen(){
    setState(() {
      screenToShow = 0;
    });
  }
    
  changeScreen(){
    setState(() {
      switch(_purchaseOption){
        case PurchaseOption.paypal:
          screenToShow = 2;
          break;
        case PurchaseOption.card:
          screenToShow = 3;
          break;
        case PurchaseOption.phone :
          screenToShow = 4;
          break;
        case PurchaseOption.bank :
          screenToShow = 5;
          break;
        case PurchaseOption.sms :
          screenToShow = 6;
          break;
        case PurchaseOption.paysafe :
          screenToShow = 7;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    getListTileOption(Widget tileIcon, String titleCode, PurchaseOption optionValue){
      return Row(
          children: [
            SizedBox(width: 80),
            Container(
                width: 60,
                margin: EdgeInsets.only(left: 10),
                child: tileIcon),
            Container(
                width: _appSize.width - 160,
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
      ]);
    }

    getIntroScreenPrivilege(String txt){
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 10, right: 10),
        child:  Container(
            width:_appSize.width - 10,
            child: Html(
                data: txt,
                style: {
                  "html": Style(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      fontSize: FontSize.large),
                })
        ),
      );
    }

    getIntroScreenDateArea(){
      return isStar ?
      Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Html(data: isStarPermanent ? AppLocalizations.of(context).translate("app_star_welc_txtPermanent")
          : AppLocalizations.of(context).translateWithArgs("app_star_welc_txtExpiryDate", [DateTime.now().toString()]),
          style: {
            "html": Style(
                backgroundColor: Colors.white,
                color: Colors.black,
                fontSize: FontSize.medium,
                textAlign: TextAlign.center),
                }
            )
        )
      : Container();
    }

    getIntroScreenButtonText(){
      return Text(
        AppLocalizations.of(context).translate(isStar ? (isStarPermanent  ? "app_star_welc_btnCancelPayment" : "app_star_welc_btnRenewMembership") : "app_star_welc_btnWantStar"),
        style: Theme.of(context).textTheme.headline4
      );
    }

    getWelcomeScreen(){
      print("getIntroScreen");
      return Container(
        color: Theme.of(context).canvasColor,
        height: _appSize.height - 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.star,
                        size: 60, color: Colors.orange)),
                Container(
                    padding: EdgeInsets.all(5),
                    width: _appSize.width - 100,
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("app_star_welc_header"),
                        style: Theme.of(context).textTheme.headline4)),
              ],
            ),
            getIntroScreenPrivilege(AppLocalizations.of(context).translate("app_star_welc_privs1")),
            getIntroScreenPrivilege(AppLocalizations.of(context).translate("app_star_welc_privs2")),
            getIntroScreenPrivilege(AppLocalizations.of(context).translate("app_star_welc_privs3")),
            getIntroScreenPrivilege(AppLocalizations.of(context).translate("app_star_welc_privs4")),
            getIntroScreenPrivilege(AppLocalizations.of(context).translate("app_star_welc_privs5")),
            Expanded(child: Container()),
            getIntroScreenDateArea(),
            Padding(
              padding:EdgeInsets.symmetric(vertical: 5),
              child: RaisedButton(
                color: Colors.white,
                onPressed: () => {
                  cancelStar ? cancelStarSubscription() :
                  goToPaymentsScreen()
                },
                child: getIntroScreenButtonText()
              ),
            )

          ],
        ),

      );
    }

    getPaymentOptionsScreen(){
      print("getPaymentOptionScreen");
      return Container(
        height: _appSize.height-10,
        color: Theme.of(context).canvasColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.star,
                        size: 60, color: Colors.orange)),
                Container(
                    width: _appSize.width - 90,
                    child: Html(
                        data: AppLocalizations.of(context).translate("app_star_pm_txtHeader"),
                        style: {
                          "html": Style(
                              backgroundColor: Colors.white,
                              color: Colors.black,
                              fontSize: FontSize.large
                          ),
                        })
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                  thickness: 1,
                )),
            getListTileOption(FaIcon(FontAwesomeIcons.ccPaypal,
                size: 40, color: Colors.blue), "app_star_pm_paypal", PurchaseOption.paypal ),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.solidCreditCard,
                size: 40, color: Colors.deepPurple), "app_star_pm_creditcard", PurchaseOption.card ),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.phone,
                size: 40, color: Colors.red), "app_star_pm_phone", PurchaseOption.phone ),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.piggyBank,
                size: 40, color: Colors.orange), "app_star_pm_deposit", PurchaseOption.bank ),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.sms,
                size: 40, color: Colors.blue), "app_star_pm_sms", PurchaseOption.sms ),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.creditCard,
                size: 40, color: Colors.green), "app_star_pm_paysafe", PurchaseOption.paysafe ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                  thickness: 1,
                )),
            Expanded(child: Container()),
            Padding(
                padding:EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed:(){
                        goToWelcomeScreen();
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding( padding: EdgeInsets.only(right: 5), child:Icon(Icons.arrow_back, size: 20, color:Colors.black) ),
                          Text(
                            AppLocalizations.of(context).translate("app_star_pm_btnCancel"),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width:20),
                    RaisedButton(
                      onPressed:(){
                        changeScreen();
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("app_star_pm_btnGo"),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Icon(Icons.arrow_forward_rounded, size: 20, color:Colors.black)
                        ],
                      ),
                    )
                  ],
                )
            )
          ]
        )
      );

    }

    switch(screenToShow){
      case -1:
        return Container();
      case 0:
        return getWelcomeScreen();
      case 1:
        return getPaymentOptionsScreen();
      case 2:
        return StarPayPalScreen(goToPaymentsScreen, _appSize);
      case 3:
         return StarCreditScreen(goToPaymentsScreen, _appSize);
      case 4:
         return StarPhoneScreen(goToPaymentsScreen, _appSize);
      case 5:
        return StarBankScreen(goToPaymentsScreen, _appSize);
      case 6:
        return StarSMSScreen(goToPaymentsScreen, _appSize);
      case 7:
        return StarPaysafeScreen(goToPaymentsScreen, _appSize);
    }
  }
}