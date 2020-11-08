import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/control/user.dart';

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
  ServiceResStatus _serviceResStatus = ServiceResStatus.star;
  String _serviceResDataType ;
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

  goToPaymentsScreen(){
    setState(() {
      screenToShow = 1;
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
      child: Text(isStarPermanent ? AppLocalizations.of(context).translate("app_star_welc_txtPermanent")
          : AppLocalizations.of(context).translateWithArgs("app_star_welc_txtExpiryDate", [DateTime.now().toString()]),
      )
      )
      : Container();
    }

    getIntroScreenButtonText(){
      return Text(
        AppLocalizations.of(context).translate(isStar ? (isStarPermanent  ? "app_star_welc_btnCancelPayment" : "app_star_welc_btnRenewMembership") : "app_star_welc_btnWantStar"),
        style: Theme.of(context).textTheme.bodyText1
      );
    }

    getIntroScreen(){
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
                  cancelStar ? print("Cancel star") : 
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

    }

    switch(screenToShow){
      case -1:
        return Container();
      case 0:
        return getIntroScreen();
      case 1:
        return getPaymentOptionsScreen();
      // case 2:
      //   return PhoneScreen(onBackHandler, _appSize);
      // case 3:
      //   return PayPalScreen(onBackHandler, _appSize);
      // case 4:
      //   return CreditScreen(onBackHandler, _appSize);
      // case 5:
      //   return PaySafeScreen(onBackHandler, _appSize);
    }
  }
}