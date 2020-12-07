import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  walletSMSServiceSimulator(Function response) {
    response();
  }

  getOfferCodeResponse() {
    setState(() {
      dataReady = true;
      //change the 2 lines below to simulate the service response cases
      offerServiceResOk = false;

      offerCode = "00000";
    });
  }

  bool dataReady = false;
  bool offerServiceResOk = false; //comes from service
  bool noStarNoCoins = UserProvider.instance.userInfo.coins == 0 && UserProvider.instance.userInfo.isStar;
  String offerCode = ""; //comes from service

  //no star no coins
  walletSMSGetCodeForComboSimulator(Function response) {
    response();
  }

  onComboCodeResponse() {
    //todo implement service response here
    setState(() {
      comboCode = "11111";
    });
  }

  String comboCode = "";

  walletSMSGetCodeForCoinsSimulator(Function response) {
    response();
  }

  onCoinsCodeResponse() {
    //todo implement service response here
    setState(() {
      coinsCode = "22222";
    });
  }

  String coinsCode = "";

  onCoinsCodeSimpleResponse() {
    //todo implement service response here
    setState(() {
      coinsCodeSimple = "77777";
    });
  }

  String coinsCodeSimple = "";

  @override
  void initState() {
    super.initState();

    walletSMSServiceSimulator(getOfferCodeResponse);
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
          Html(data: AppLocalizations.of(context).translate("app_coins_sm_hasBundle"), style: {
            "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium),
          }),
          Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, offerCode, smsCoinsGateway]), style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          Html(data: AppLocalizations.of(context).translate("app_coins_sm_txtStarInfo"), style: {
            "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.center),
          }),
        ],
      );
    }

    Widget noStarNoCoinsArea() {
      walletSMSGetCodeForComboSimulator(onComboCodeResponse);
      walletSMSGetCodeForCoinsSimulator(onCoinsCodeResponse);

      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context).translate("app_coins_sm_txtNoCoinsNoStar"),
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            )),
        Html(data: AppLocalizations.of(context).translate("app_coins_sm_txtNoCoinsNoStarInfo"), style: {
          "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.center),
        }),
        Padding(padding: EdgeInsets.only(top: 20, bottom: 5), child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, comboCode, smsCoinsGateway]), style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text(AppLocalizations.of(context).translate("app_coins_sm_txtOR"), style: Theme.of(context).textTheme.headline3, textAlign: TextAlign.center)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context).translate("app_coins_sm_txtNoStarNoCoinsOnly"),
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            )),
        Html(data: AppLocalizations.of(context).translate("app_coins_sm_txtNoStarNoCoinsOnlyInfo"), style: {
          "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.center),
        }),
        Padding(padding: EdgeInsets.only(top: 20, bottom: 5), child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, coinsCode, smsCoinsGateway]), style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
      ]);
    }

    Widget simpleArea() {
      walletSMSGetCodeForCoinsSimulator(onCoinsCodeSimpleResponse);

      return Column(
        children: [
          Html(data: AppLocalizations.of(context).translate(UserProvider.instance.userInfo.isStar ? "app_coins_sm_txtSimpleInfoStar" : "app_coins_sm_txtSimpleInfoSimple"), style: {
            "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium),
          }),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Html(data: AppLocalizations.of(context).translate(UserProvider.instance.userInfo.isStar ? "app_coins_sm_txtSimpleStarYes" : "app_coins_sm_txtSimpleStarNo"), style: {
                "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium),
              })),
          Padding(padding: EdgeInsets.only(top: 20, bottom: 5), child: Text(AppLocalizations.of(context).translateWithArgs("app_coins_sm_prompt", [smsCoinsKeyword, coinsCodeSimple, smsCoinsGateway]), style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center))
        ],
      );
    }

    return Container(
        height: widget._appSize.height - 10,
        color: Theme.of(context).canvasColor,
        child: Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.all(10), child: FaIcon(FontAwesomeIcons.coins, size: 50, color: Colors.orange)),
                Container(
                    width: widget._appSize.width - 80,
                    child: Html(data: AppLocalizations.of(context).translate("app_coins_sm_txtHeader"), style: {
                      "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.large),
                    })),
              ],
            ),
            Container(
                width: widget._appSize.width - 10,
                padding: EdgeInsets.all(5),
                child: !dataReady
                    ? Container()
                    : offerServiceResOk
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
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
