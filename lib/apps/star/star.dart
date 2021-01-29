import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/apps/star/screens/star_bank_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_credit_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_paypal_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_paysafe_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_phone_screen.dart';
import 'package:zoo_flutter/apps/star/screens/star_sms_screen.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

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
        if (res["data"]["type"] == "permanent") {
          _isStarPermanent = true;
          _cancelStar = true;
        }
      } else if (res["errorMsg"] == "not_star") {
        print("not star");
        _isStar = false;
        _isStarPermanent = false;
      } else if (res["errorMsg"] == "not_authenticated") {
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

  getListTileOption(Widget tileIcon, String titleCode, PurchaseOption optionValue) {
    return Row(children: [
      Container(
        width: 60,
        margin: EdgeInsets.only(left: 10),
        child: tileIcon,
      ),
      Container(
          width: _appSize.width - 160,
          child: RadioListTile<PurchaseOption>(
            title: Text(
              AppLocalizations.of(context).translate(titleCode),
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xff000000),
                fontWeight: FontWeight.normal,
              ),
            ),
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
      padding: const EdgeInsets.only(top: 30, right: 35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Image.asset("assets/images/star/star_small.png", width: 20, height: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Container(
              width: 580,
              child: Text(
                txt,
                softWrap: true,
                style: TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
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

  getWelcomeScreen() {
    print("getIntroScreen");
    return Container(
      color: Color(0xFFffffff),
      height: _appSize.height - 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/star/star_header.png",
              ),
              Positioned(
                top: 40,
                left: 220,
                child: Container(
                    width: 360,
                    // height: 100,
                    child: Html(data: AppLocalizations.of(context).translate("app_star_welc_header"), style: {
                      "html": Style(color: Color(0xff393e54), fontSize: FontSize.large, fontWeight: FontWeight.w500),
                    })),
              ),
            ],
          ),
          getIntroScreenPrivilege(AppLocalizations.of(context).translate("app_star_welc_privs1")),
          getIntroScreenPrivilege(AppLocalizations.of(context).translate("app_star_welc_privs4")),
          getIntroScreenPrivilege(AppLocalizations.of(context).translate("app_star_welc_privs5")),
          Spacer(),
          getIntroScreenDateArea(),
          Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 30, bottom: 20),
                child: GestureDetector(
                  onTap: () => {_cancelStar ? cancelStarSubscription() : goToPaymentsScreen()},
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: !_isStar ? 190 : 230,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Color(0xff64abff),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate(_isStar ? (_isStarPermanent ? "app_star_welc_btnCancelPayment" : "app_star_welc_btnRenewMembership") : "app_star_welc_btnWantStar"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getPaymentOptionsScreen() {
    return Container(
      height: _appSize.height - 10,
      color: Color(0xFFffffff),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/star/star_header.png",
              ),
              Positioned(
                top: 20,
                left: 220,
                child: Container(
                    width: 360,
                    // height: 100,
                    child: Html(data: AppLocalizations.of(context).translate("app_star_pm_txtHeader"), style: {
                      "html": Style(color: Color(0xff393e54), fontSize: FontSize.large, fontWeight: FontWeight.w500),
                    })),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 20),
            child: Container(
              width: 624,
              height: 360,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff9598a4),
                  width: 2,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  getListTileOption(Image.asset("assets/images/common/paypal_icon.png", height: 40), "app_star_pm_paypal", PurchaseOption.paypal),
                  SizedBox(height: 10),
                  getListTileOption(Image.asset("assets/images/common/cc_icon.png", height: 40), "app_star_pm_creditcard", PurchaseOption.card),
                  SizedBox(height: 10),
                  getListTileOption(Image.asset("assets/images/common/phone_icon.png", height: 40), "app_star_pm_phone", PurchaseOption.phone),
                  SizedBox(height: 10),
                  getListTileOption(Image.asset("assets/images/star/bank_icon.png", height: 40), "app_star_pm_deposit", PurchaseOption.bank),
                  SizedBox(height: 10),
                  getListTileOption(Image.asset("assets/images/common/sms_icon.png", height: 40), "app_star_pm_sms", PurchaseOption.sms),
                  SizedBox(height: 10),
                  getListTileOption(Image.asset("assets/images/common/paysafe_icon.png", height: 40), "app_star_pm_paysafe", PurchaseOption.paysafe),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
              padding: EdgeInsets.only(right: 26, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => goToWelcomeScreen(),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 140,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xfff7a738),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                width: 25,
                                height: 25,
                                child: Image.asset("assets/images/coins/back_icon.png"),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context).translate("app_star_pm_btnCancel"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => changeScreen(),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 140,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xff3c8d40),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 28),
                              child: Text(
                                AppLocalizations.of(context).translate("app_star_pm_btnGo"),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                width: 25,
                                height: 25,
                                child: Image.asset("assets/images/coins/continue_icon.png"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
