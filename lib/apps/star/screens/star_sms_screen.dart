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

class StarSMSScreen extends StatefulWidget {
  StarSMSScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  StarSMSScreenState createState() => StarSMSScreenState();
}

class StarSMSScreenState extends State<StarSMSScreen> {
  StarSMSScreenState();

  RPC _rpc;

  String _starCode = "";

  walletSMSgetStarCodeSimulator(Function response) {
    response();
  }

  onStarCodeResponse() {
    setState(() {
      _starCode = "12121";
    });
  }

  @override
  void initState() {
    // walletSMSgetStarCodeSimulator(onStarCodeResponse);

    _rpc = RPC();
    getStarInfo();
    super.initState();
  }

  getStarInfo() async {
    var res = await _rpc.callMethod("Wallet.SMS.getCode", ["star"]);

    if (res["status"] == "ok") {
      print(res["data"].toString());
      setState(() {
        _starCode = res["data"]["code"].toString();
      });
    } else if (res["status"] == "not_authenticated") {
      _showNotAuthenticatedAlert();
    } else {
      print(" getStarInfo error");
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

  @override
  Widget build(BuildContext context) {
    String gateway = DataMocker.premiumStarSMSSettings["smsStarGateway"];
    String keyword = DataMocker.premiumStarSMSSettings["smsStarKeyword"];
    String starCost = DataMocker.premiumStarSMSSettings["smsStarCost"];
    String starProvider = DataMocker.premiumStarSMSSettings["smsStarProvider"];

    return Container(
        height: widget._appSize.height - 10,
        color: Color(0xFFffffff),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/star/sms_header.png",
                ),
                Positioned(
                  top: 20,
                  left: 220,
                  child: Container(
                    width: 330,
                    height: 100,
                    child: Html(
                      data: AppLocalizations.of(context).translate("app_star_sm_txtHeader_1"),
                      style: {
                        "html": Style(color: Colors.black, fontWeight: FontWeight.w500, fontSize: FontSize.large),
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 10),
              child: Html(
                data: AppLocalizations.of(context).translateWithArgs(
                    "app_star_sms_txtSmsDetails", [gateway, keyword, _starCode, starCost, starProvider]),
                style: {
                  "html": Style(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      fontSize: FontSize.large,
                      textAlign: TextAlign.left),
                  "h1": Style(color: Colors.red, fontSize: FontSize.xxLarge, textAlign: TextAlign.left),
                },
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 30, bottom: 18),
              child: Row(
                children: [
                  Spacer(),
                  GestureDetector(
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
                                AppLocalizations.of(context).translate("app_star_sms_btnBack"),
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
                ],
              ),
            ),
          ],
        ));
  }
}
