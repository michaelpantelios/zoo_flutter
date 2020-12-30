import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/star/screens/star_bank_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_credit_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_paypal_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_paysafe_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_phone_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_sms_screen.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/net/rpc.dart';

enum PurchaseOption { paypal, card, phone, bank, sms, paysafe }
enum ServiceResStatus { invalid_session, no_login, not_star, star }

class Star extends StatefulWidget {
  final Size size;
  Star({@required this.size});

  StarState createState() => StarState();
}

class StarState extends State<Star> {
  StarState();

  Size _appSize;
  PurchaseOption _purchaseOption;
  int screenToShow = -1;
  ServiceResStatus _serviceResStatus = ServiceResStatus.not_star;
  String _serviceResDataType = "";
  bool _isStar;
  bool _isStarPermanent;
  bool _cancelStar = false;
  RPC _rpc;

  @override
  void initState() {
    print("star initState");
    super.initState();
    _appSize = widget.size;
    _purchaseOption = PurchaseOption.paypal;
    // walletStarInfoServiceSimulator(walletStarInfoResponse);

    _rpc = RPC();

    getStarInfo();
  }

  getStarInfo() async {
    print("getStarInfo");
    var res = await _rpc.callMethod("Wallet.Star.getStarInfo", [UserProvider.instance.sessionKey]);
    print(res);

    setState(() {
      screenToShow = 0;

      if (res["status"] == "ok") {
        print(res["data"]);

        _isStar = true;
        if (res["data"]["type"] == "permanent"){
          _isStarPermanent = true;
          _cancelStar = true;
        }
      } else if (res["errorMsg"] == "not_star") {
        print("not star");
        _isStar = false;
        _isStarPermanent = false;
      } else if (res["errorMsg"] == "not_authenticated"){
        print("not_authenticated");
      } else {
        print(res["status"]);
      }
    });

  }

  cancelStarSubscription() {
    print("cancelStar");
  }

  goToPaymentsScreen() {
    setState(() {
      screenToShow = 1;
    });
  }

  goToWelcomeScreen() {
    setState(() {
      screenToShow = 0;
    });
  }

  changeScreen() {
    setState(() {
      switch (_purchaseOption) {
        case PurchaseOption.paypal:
          screenToShow = 2;
          break;
        case PurchaseOption.card:
          screenToShow = 3;
          break;
        case PurchaseOption.phone:
          screenToShow = 4;
          break;
        case PurchaseOption.bank:
          screenToShow = 5;
          break;
        case PurchaseOption.sms:
          screenToShow = 6;
          break;
        case PurchaseOption.paysafe:
          screenToShow = 7;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getListTileOption(Widget tileIcon, String titleCode, PurchaseOption optionValue) {
      return Row(children: [
        SizedBox(width: 80),
        Container(width: 60, margin: EdgeInsets.only(left: 10), child: tileIcon),
        Container(
            width: _appSize.width - 160,
            child: RadioListTile<PurchaseOption>(
              title: Text(AppLocalizations.of(context).translate(titleCode), style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.normal)),
              selected: optionValue == _purchaseOption,
              value: optionValue,
              groupValue: _purchaseOption,
              onChanged: (PurchaseOption value) {
                setState(() {
                  _purchaseOption = value;
                  print("_purchaseOption = " + _purchaseOption.toString());
                });
              },
            ))
      ]);
    }

    getIntroScreenPrivilege(String txt) {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 10, right: 10),
        child: Container(
            width: _appSize.width - 10,
            child: Html(data: txt, style: {
              "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.large),
            })),
      );
    }

    getIntroScreenDateArea() {
      return _isStar
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Html(data: _isStarPermanent ? AppLocalizations.of(context).translate("app_star_welc_txtPermanent") : AppLocalizations.of(context).translateWithArgs("app_star_welc_txtExpiryDate", [DateTime.now().toString()]), style: {
                "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.center),
              }))
          : Container();
    }

    getIntroScreenButtonText() {
      return Text(AppLocalizations.of(context).translate(_isStar ? (_isStarPermanent ? "app_star_welc_btnCancelPayment" : "app_star_welc_btnRenewMembership") : "app_star_welc_btnWantStar"), style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff000000),
          fontWeight: FontWeight.normal));
    }

    getWelcomeScreen() {
      print("getIntroScreen");
      return Container(
        color: Color(0xFFffffff),
        height: _appSize.height - 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.all(5), child: Icon(Icons.star, size: 60, color: Colors.orange)),
                Container(padding: EdgeInsets.all(5), width: _appSize.width - 100, child: Text(AppLocalizations.of(context).translate("app_star_welc_header"), style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.normal))),
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
              padding: EdgeInsets.symmetric(vertical: 5),
              child: RaisedButton(color: Colors.white, onPressed: () => {_cancelStar ? cancelStarSubscription() : goToPaymentsScreen()}, child: getIntroScreenButtonText()),
            )
          ],
        ),
      );
    }

    getPaymentOptionsScreen() {
      print("getPaymentOptionScreen");
      return Container(
          height: _appSize.height - 10,
          color: Color(0xFFffffff),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.all(10), child: Icon(Icons.star, size: 60, color: Colors.orange)),
                Container(
                    width: _appSize.width - 90,
                    child: Html(data: AppLocalizations.of(context).translate("app_star_pm_txtHeader"), style: {
                      "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.large),
                    })),
              ],
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                  thickness: 1,
                )),
            getListTileOption(FaIcon(FontAwesomeIcons.ccPaypal, size: 40, color: Colors.blue), "app_star_pm_paypal", PurchaseOption.paypal),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.solidCreditCard, size: 40, color: Colors.deepPurple), "app_star_pm_creditcard", PurchaseOption.card),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.phone, size: 40, color: Colors.red), "app_star_pm_phone", PurchaseOption.phone),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.piggyBank, size: 40, color: Colors.orange), "app_star_pm_deposit", PurchaseOption.bank),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.sms, size: 40, color: Colors.blue), "app_star_pm_sms", PurchaseOption.sms),
            SizedBox(height: 10),
            getListTileOption(FaIcon(FontAwesomeIcons.creditCard, size: 40, color: Colors.green), "app_star_pm_paysafe", PurchaseOption.paysafe),
            Padding(
                padding: EdgeInsets.all(10),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                  thickness: 1,
                )),
            Expanded(child: Container()),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        goToWelcomeScreen();
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.arrow_back, size: 20, color: Colors.black)),
                          Text(
                            AppLocalizations.of(context).translate("app_star_pm_btnCancel"),
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF111111),
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    RaisedButton(
                      onPressed: () {
                        changeScreen();
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("app_star_pm_btnGo"),
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF111111),
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.black)
                        ],
                      ),
                    )
                  ],
                ))
          ]));
    }

    switch (screenToShow) {
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
        break;
      default:
        return Container();
    }
  }
}
