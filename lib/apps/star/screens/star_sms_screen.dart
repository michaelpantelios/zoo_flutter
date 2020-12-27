import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
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

  String starCode = "";

  walletSMSgetStarCodeSimulator(Function response) {
    response();
  }

  onStarCodeResponse() {
    setState(() {
      starCode = "12121";
    });
  }

  @override
  void initState() {
    walletSMSgetStarCodeSimulator(onStarCodeResponse);
    super.initState();
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.all(10), child: Icon(Icons.star, size: 60, color: Colors.orange)),
                Container(
                    width: widget._appSize.width - 90,
                    child: Html(
                        data: AppLocalizations.of(context).translateWithArgs("app_star_sms_txtSmsDetails", [gateway, keyword, starCode, starCost, starProvider]),
                        style: {"html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.large), "h1": Style(color: Colors.red, fontSize: FontSize.xxLarge, textAlign: TextAlign.center)})),
              ],
            ),
            Expanded(child: Container()),
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
                      AppLocalizations.of(context).translate("app_star_sms_btnBack"),
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF111111),
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
