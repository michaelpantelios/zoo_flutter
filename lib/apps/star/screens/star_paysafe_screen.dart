import 'dart:html';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

class StarPaysafeScreen extends StatefulWidget {
  StarPaysafeScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  StarPaysafeScreenState createState() => StarPaysafeScreenState();
}

class StarPaysafeScreenState extends State<StarPaysafeScreen> {
  StarPaysafeScreenState();

  String _product;

  buyProduct() {
    print("buy subscription");
    var random = new Random();
    window.open("${Env.zooURL}/cgiapp/wallet/order.pl?rm=paysafe_redirect&type=$_product&rkey=${random.nextInt(10000).toString()}", "pay", "width=960,height=700,scrollbars=yes,resizable=yes,menubar=yes,toolbar=yes,status=no");
  }

  getProductOption(String prodid) {
    String label = AppLocalizations.of(context).translate("app_star_ps_" + prodid);
    return Container(
        width: widget._appSize.width * 0.4,
        child: RadioListTile<String>(
          title: Text(label, style: TextStyle(
              fontSize: 12.0,
              color: Color(0xFF111111),
              fontWeight: FontWeight.normal)),
          selected: _product == prodid,
          value: prodid,
          groupValue: _product,
          onChanged: (String value) {
            setState(() {
              print("value = " + value);
              _product = value;
            });
          },
        ));
  }

  @override
  void initState() {
    _product = "star1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget._appSize.height - 10,
        color: Color(0xFFffffff),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(10), child: Icon(Icons.star, size: 60, color: Colors.orange)),
                Container(
                    width: widget._appSize.width - 90,
                    child: Html(data: AppLocalizations.of(context).translate("app_star_ps_txtHeader"), style: {
                      "html": Style(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontSize: FontSize.large,
                      ),
                    })),
              ],
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: RichText(
                    text: TextSpan(text: AppLocalizations.of(context).translate("app_star_ps_paysafe_link1"), style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.normal), children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context).translate("app_star_ps_paysafe_link2"),
                    style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = 'http://www.paysafecard.com/';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).translate("app_star_ps_paysafe_link3"),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.normal),
                  )
                ]))),
            Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: Text(AppLocalizations.of(context).translate("app_star_ps_txtSubHeader"), style: TextStyle(
                fontSize: 14.0,
                color: Color(0xff000000),
                fontWeight: FontWeight.normal)))),
            getProductOption("star1"),
            getProductOption("star2.5"),
            getProductOption("star6"),
            getProductOption("star12"),
            Expanded(child: Container()),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        widget.onBackHandler();
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.arrow_back, size: 20, color: Colors.black)),
                          Text(
                            AppLocalizations.of(context).translate("app_star_ps_btnCancel"),
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
                        buyProduct();
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("app_star_ps_btnGo"),
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
          ],
        ));
  }
}
