import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class CoinsSmsScreen extends StatefulWidget {
  CoinsSmsScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  CoinsSmsScreenState createState() => CoinsSmsScreenState();
}

class CoinsSmsScreenState extends State<CoinsSmsScreen> {
  CoinsSmsScreenState();

  RPC _rpc;
  bool dataReady = false;
  bool offerServiceResOk = false; //comes from service
  bool noStarNoCoins = UserProvider.instance.userInfo.coins == 0 && UserProvider.instance.userInfo.isStar;
  String offerCode = ""; //comes from service

  String comboCode = "";
  String coinsCode = "";
  String coinsCodeSimple = "";

  // getOfferCodeResponse() {
  //   setState(() {
  //     dataReady = true;
  //     //change the 2 lines below to simulate the service response cases
  //     offerServiceResOk = true;
  //
  //     offerCode = "00000";
  //   });
  // }
  //
  // //no star no coins
  // walletSMSGetCodeForComboSimulator(Function response) {
  //   response();
  // }
  //
  // onComboCodeResponse() {
  //   //todo implement service response here
  //   setState(() {
  //     comboCode = "11111";
  //   });
  // }

  // walletSMSGetCodeForCoinsSimulator(Function response) {
  //   response();
  // }
  //
  // onCoinsCodeResponse() {
  //   //todo implement service response here
  //   setState(() {
  //     coinsCode = "22222";
  //   });
  // }

  //
  // onCoinsCodeSimpleResponse() {
  //   //todo implement service response here
  //   setState(() {
  //     coinsCodeSimple = "77777";
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _rpc = RPC();

    _getOfferCode();
  }

  _getOfferCode() async {
    print("_getOfferCode");
    var res = await _rpc.callMethod("Wallet.SMS.getOfferCode", [UserProvider.instance.sessionKey]);

    print(res);
    if (res["status"] == "ok") {
      print(res["data"]);
      setState(() {
        offerServiceResOk = true;
        offerCode = res["data"]["code"].toString();
      });
    } else if (res["errorMsg"] == "not_eligible") {
      print("not_eligible");
      if (UserProvider.instance.userInfo.coins == 0 && UserProvider.instance.userInfo.star == 0) {
        getComboCode();
        getCoinsCode();
      } else
        getCoinsCodeSimple();
    } else if (res["status"] == "not_authenticated") {
      _showNotAuthenticatedAlert();
    } else {
      print(" _getOfferCode error");
    }
  }

  getComboCode() async {
    print('getComboCode');
    var res = await _rpc.callMethod("Wallet.SMS.getCode", ["combo"]);
    if (res["status"] == "ok") {
      setState(() {
        comboCode = res["data"]["code"].toString();
        print('comboCode::' + comboCode);
      });
    } else if (res["status"] == "not_authenticated") {
      _showNotAuthenticatedAlert();
    } else {
      print(" getComboCode error");
    }
  }

  getCoinsCode() async {
    print('getCoinsCode');
    var res = await _rpc.callMethod("Wallet.SMS.getCode", ["coins"]);
    print(res);
    if (res["status"] == "ok") {
      setState(() {
        coinsCode = res["data"]["code"].toString();
      });
    } else if (res["status"] == "not_authenticated") {
      _showNotAuthenticatedAlert();
    } else {
      print(" getCoinsCode error");
    }
  }

  getCoinsCodeSimple() async {
    print('getCoinsCodeSimple');
    var res = await _rpc.callMethod("Wallet.SMS.getCode", ["coins"]);
    print(res);

    if (res["status"] == "ok") {
      setState(() {
        coinsCodeSimple = res["data"]["code"].toString();
      });
    } else if (res["status"] == "not_authenticated") {
      _showNotAuthenticatedAlert();
    } else {
      print(" getCoinsCodeSimple error");
    }
  }

  _showNotAuthenticatedAlert() {
    AlertManager.instance.showSimpleAlert(
      context: context,
      bodyText: AppLocalizations.of(context).translate("not_authenticated"),
      callbackAction: (retValue) async {
        UserProvider.instance.logout();
      },
      dialogButtonChoice: AlertChoices.OK,
    );
  }

  Widget offerOkArea() {
    String smsCoinsKeyword = DataMocker.premiumCoinsSMSSettings["smsCoinsKeyword"];
    String smsCoinsGateway = DataMocker.premiumCoinsSMSSettings["smsCoinsGateway"];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Html(data: AppLocalizations.of(context).translate("app_coins_sm_hasBundle"), style: {
          "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium),
        }),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
          child: Text(
            AppLocalizations.of(context)
                .translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, offerCode, smsCoinsGateway]),
            style: TextStyle(color: Color(0xfff2453d), fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        Html(data: AppLocalizations.of(context).translate("app_coins_sm_txtStarInfo"), style: {
          "html": Style(
              backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.left),
        }),
      ],
    );
  }

  Widget noStarNoCoinsArea() {
    // walletSMSGetCodeForComboSimulator(onComboCodeResponse);
    // walletSMSGetCodeForCoinsSimulator(onCoinsCodeResponse);
    String smsCoinsKeyword = DataMocker.premiumCoinsSMSSettings["smsCoinsKeyword"];
    String smsCoinsGateway = DataMocker.premiumCoinsSMSSettings["smsCoinsGateway"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context).translate("app_coins_sm_txtNoCoinsNoStar"),
              style: TextStyle(fontSize: 18, color: Color(0xff222222), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
        Html(data: AppLocalizations.of(context).translate("app_coins_sm_txtNoCoinsNoStarInfo"), style: {
          "html": Style(
              backgroundColor: Colors.white,
              color: Colors.black,
              fontSize: FontSize.medium,
              textAlign: TextAlign.center),
        }),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            child: Text(
                AppLocalizations.of(context)
                    .translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, comboCode, smsCoinsGateway]),
                style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(AppLocalizations.of(context).translate("app_coins_sm_txtOR"),
                style: TextStyle(fontSize: 18, color: Color(0xff222222), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context).translate("app_coins_sm_txtNoStarNoCoinsOnly"),
              style: TextStyle(fontSize: 18, color: Color(0xff222222), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
        Html(data: AppLocalizations.of(context).translate("app_coins_sm_txtNoStarNoCoinsOnlyInfo"), style: {
          "html": Style(
              backgroundColor: Colors.white,
              color: Colors.black,
              fontSize: FontSize.medium,
              textAlign: TextAlign.center),
        }),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            child: Text(
                AppLocalizations.of(context)
                    .translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, coinsCode, smsCoinsGateway]),
                style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center)),
      ],
    );
  }

  Widget simpleArea() {
    // walletSMSGetCodeForCoinsSimulator(onCoinsCodeSimpleResponse);
    String smsCoinsKeyword = DataMocker.premiumCoinsSMSSettings["smsCoinsKeyword"];
    String smsCoinsGateway = DataMocker.premiumCoinsSMSSettings["smsCoinsGateway"];

    return Column(
      children: [
        Html(
            data: AppLocalizations.of(context).translate(UserProvider.instance.userInfo.isStar
                ? "app_coins_sm_txtSimpleInfoStar"
                : "app_coins_sm_txtSimpleInfoSimple"),
            style: {
              "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium),
            }),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Html(
                data: AppLocalizations.of(context).translate(UserProvider.instance.userInfo.isStar
                    ? "app_coins_sm_txtSimpleStarYes"
                    : "app_coins_sm_txtSimpleStarNo"),
                style: {
                  "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium),
                })),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            child: Text(
                AppLocalizations.of(context)
                    .translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, coinsCodeSimple, smsCoinsGateway]),
                style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String smsCoinsCost = DataMocker.premiumCoinsSMSSettings["smsCoinsCost"];
    String smsCoinsProvider = DataMocker.premiumCoinsSMSSettings["smsCoinsProvider"];

    return Container(
        height: widget._appSize.height - 10,
        color: Color(0xFFffffff),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/coins/sms_header.png",
            ),
            Container(
                width: widget._appSize.width - 10,
                padding: EdgeInsets.all(5),
                child: offerServiceResOk
                    ? offerOkArea()
                    : noStarNoCoins
                        ? noStarNoCoinsArea()
                        : simpleArea()),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                AppLocalizations.of(context)
                    .translateWithArgs("app_coins_sm_txtCredits", [smsCoinsCost, smsCoinsProvider]),
                style: TextStyle(
                  color: Color(0xff393e54),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 20),
                  child: GestureDetector(
                    onTap: () => widget.onBackHandler(),
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
                                AppLocalizations.of(context).translate("app_coins_sm_btnBack"),
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
                ),
              ],
            ),
          ],
        ));
  }
}
