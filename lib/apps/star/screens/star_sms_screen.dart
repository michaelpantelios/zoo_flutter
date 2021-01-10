import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:zoo_flutter/net/rpc.dart';
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
    } else {
      print("error");
      print(res);
    }
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
                  child: HTML.toRichText(
                    context,
                    AppLocalizations.of(context).translateWithArgs(
                      "app_star_sms_txtSmsDetails",
                      [
                        gateway,
                        keyword,
                        _starCode,
                        starCost,
                        starProvider,
                      ],
                    ),
                    overrideStyle: {
                      "html": TextStyle(color: Colors.black, fontSize: 14),
                      "h1": TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    },
                  ),
                ),
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
