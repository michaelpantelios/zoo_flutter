import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_html_css/simple_html_css.dart';
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

  // walletSMSServiceSimulator(Function response) {
  //   response();
  // }

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

    // walletSMSServiceSimulator(getOfferCodeResponse);
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
    } else if (res["status"] == "not_eligible") {
      print("not_eligible");
      if (UserProvider.instance.userInfo.coins == 0 && UserProvider.instance.userInfo.star == 0) {
        getComboCode();
        getCoinsCode();
      } else
        getCoinsCodeSimple();
    } else {
      print("error");
      print(res);
    }
  }

  getComboCode() async {
    var res = await _rpc.callMethod("Wallet.SMS.getCode", ["combo"]);
    if (res["status="] == "ok") {
      setState(() {
        comboCode = res["data"]["code"].toString();
      });
    } else {
      print(" getComboCode error");
    }
  }

  getCoinsCode() async {
    var res = await _rpc.callMethod("Wallet.SMS.getCode", ["coins"]);
    if (res["status="] == "ok") {
      setState(() {
        coinsCode = res["data"]["code"].toString();
      });
    } else {
      print(" getComboCode error");
    }
  }

  getCoinsCodeSimple() async {
    var res = await _rpc.callMethod("Wallet.SMS.getCode", ["coins"]);

    if (res["status="] == "ok") {
      setState(() {
        coinsCodeSimple = res["data"]["code"].toString();
      });
    } else {
      print(" getCoinsCodeSimple error");
    }
  }

  @override
  Widget build(BuildContext context) {
    String smsCoinsCost = DataMocker.premiumCoinsSMSSettings["smsCoinsCost"];
    String smsCoinsProvider = DataMocker.premiumCoinsSMSSettings["smsCoinsProvider"];
    String smsCoinsKeyword = DataMocker.premiumCoinsSMSSettings["smsCoinsKeyword"];
    String smsCoinsGateway = DataMocker.premiumCoinsSMSSettings["smsCoinsGateway"];

    Widget offerOkArea() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HTML.toRichText(context, AppLocalizations.of(context).translate("app_coins_sm_hasBundle"), overrideStyle: {
            "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 12),
          }),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20), child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, offerCode, smsCoinsGateway]), style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          HTML.toRichText(context, AppLocalizations.of(context).translate("app_coins_sm_txtStarInfo"), overrideStyle: {
            "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 12),
          }),
        ],
      );
    }

    Widget noStarNoCoinsArea() {
      // walletSMSGetCodeForComboSimulator(onComboCodeResponse);
      // walletSMSGetCodeForCoinsSimulator(onCoinsCodeResponse);

      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context).translate("app_coins_sm_txtNoCoinsNoStar"),
              style: TextStyle(fontSize: 18, color: Color(0xff222222), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
        HTML.toRichText(context, AppLocalizations.of(context).translate("app_coins_sm_txtNoCoinsNoStarInfo"), overrideStyle: {
          "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 12),
        }),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 5), child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, comboCode, smsCoinsGateway]), style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text(AppLocalizations.of(context).translate("app_coins_sm_txtOR"), style: TextStyle(fontSize: 18, color: Color(0xff222222), fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context).translate("app_coins_sm_txtNoStarNoCoinsOnly"),
              style: TextStyle(fontSize: 18, color: Color(0xff222222), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
        HTML.toRichText(context, AppLocalizations.of(context).translate("app_coins_sm_txtNoStarNoCoinsOnlyInfo"), overrideStyle: {
          "html": TextStyle(
            backgroundColor: Colors.white,
            color: Colors.black,
            fontSize: 12,
          ),
        }),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 5), child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, coinsCode, smsCoinsGateway]), style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
      ]);
    }

    Widget simpleArea() {
      // walletSMSGetCodeForCoinsSimulator(onCoinsCodeSimpleResponse);

      return Column(
        children: [
          HTML.toRichText(context, AppLocalizations.of(context).translate(UserProvider.instance.userInfo.isStar ? "app_coins_sm_txtSimpleInfoStar" : "app_coins_sm_txtSimpleInfoSimple"), overrideStyle: {
            "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 14),
          }),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: HTML.toRichText(context, AppLocalizations.of(context).translate(UserProvider.instance.userInfo.isStar ? "app_coins_sm_txtSimpleStarYes" : "app_coins_sm_txtSimpleStarNo"), overrideStyle: {
                "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 14),
              })),
          Padding(
              padding: EdgeInsets.only(top: 20, bottom: 5),
              child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, coinsCodeSimple, smsCoinsGateway]), style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center))
        ],
      );
    }

    return Container(
        height: widget._appSize.height - 10,
        color: Color(0xFFffffff),
        child: Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.all(10), child: FaIcon(FontAwesomeIcons.coins, size: 50, color: Colors.orange)),
                Container(
                    width: widget._appSize.width - 80,
                    child: HTML.toRichText(context, AppLocalizations.of(context).translate("app_coins_sm_txtHeader"), overrideStyle: {
                      "html": TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 18),
                    })),
              ],
            ),
            Container(
                width: widget._appSize.width - 10,
                padding: EdgeInsets.all(5),
                child: offerServiceResOk
                    ? offerOkArea()
                    : noStarNoCoins
                        ? noStarNoCoinsArea()
                        : simpleArea()),
            Expanded(child: Container()),
            Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_sm_txtCredits", [smsCoinsCost, smsCoinsProvider]), style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal))),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: widget._appSize.width * 0.3,
              child: RaisedButton(
                onPressed: () {
                  widget.onBackHandler();
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
