import 'dart:html';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

class CoinsPaySafeScreen extends StatefulWidget {
  CoinsPaySafeScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  CoinsPaySafeScreenState createState() => CoinsPaySafeScreenState();
}

class CoinsPaySafeScreenState extends State<CoinsPaySafeScreen> {
  CoinsPaySafeScreenState();

  List<DataRow> products = new List<DataRow>();
  String _product;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _product = "combo1280";
  }

  purchaseProduct() {
    print("Buy this product:" + _product);

    var random = new Random();
    window.open("${Env.cgiHost}/cgiapp/wallet/order.pl?rm=paysafe_redirect&type=$_product&rkey=${random.nextInt(10000).toString()}", "buycoins", "width=800,height=600,scrollbars=yes,resizable=yes,menubar=yes,toolbar=yes,status=no");
  }

  DataRow createProductRow(String prodid) {
    var productStringsArray = AppLocalizations.of(context).translate("app_coins_ps_" + prodid).split("|");
    List<DataCell> cells = new List<DataCell>();

    var coins = int.parse(prodid.substring(5));
    cells.add(
      new DataCell(
        Container(
          // width: 300,
          child: RadioListTile<String>(
            contentPadding: EdgeInsets.only(left: 0),
            title: Text(!UserProvider.instance.userInfo.isStar ? productStringsArray[0] : "${productStringsArray[0]} ${productStringsArray[3]} = ${coins + coins * 0.6}", style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal)),
            selected: _product == prodid,
            value: prodid,
            groupValue: _product,
            onChanged: (String value) {
              setState(() {
                print("value = " + value);
                _product = value;
              });
            },
          ),
        ),
      ),
    );

    cells.add(new DataCell(Text(productStringsArray[1], style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal))));

    cells.add(new DataCell(Text(productStringsArray[2], style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal))));
    DataRow row = new DataRow(cells: cells);

    return row;
  }

  @override
  Widget build(BuildContext context) {
    products.clear();
    products.add(createProductRow("coins350"));
    if (!UserProvider.instance.userInfo.isStar) products.add(createProductRow("combo560"));
    products.add(createProductRow("coins800"));
    if (!UserProvider.instance.userInfo.isStar) products.add(createProductRow("combo1280"));

    return Container(
      height: widget._appSize.height - 10,
      color: Color(0xFFffffff),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/coins/paysafe_header.png",
              ),
              Positioned(
                top: 0,
                left: 220,
                child: Container(
                    width: 360,
                    // height: 100,
                    child: Html(data: AppLocalizations.of(context).translate("app_coins_ps_txtHeader"), style: {
                      "html": Style(color: Color(0xff393e54), fontSize: FontSize.large, fontWeight: FontWeight.w500),
                    })),
              ),
              Positioned(
                top: 140,
                left: 220,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context).translate("app_coins_ps_paysafe_link1"),
                      style: TextStyle(fontSize: 14.0, color: Color(0xff000000), fontWeight: FontWeight.normal),
                      children: <TextSpan>[
                        TextSpan(
                            text: AppLocalizations.of(context).translate("app_coins_ps_paysafe_link2"),
                            style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.normal),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'http://www.paysafecard.com/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                            children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(context).translate("app_coins_ps_paysafe_link3"),
                                style: TextStyle(fontSize: 14.0, color: Color(0xff000000), fontWeight: FontWeight.normal),
                              )
                            ])
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 5, left: 25),
              child: Html(data: AppLocalizations.of(context).translate(UserProvider.instance.userInfo.isStar ? "app_coins_ps_subHeaderStar" : "app_coins_ps_subHeaderNonStar"), style: {
                "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.left),
              })),
          Container(
            width: 550,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff9598a4),
                width: 2,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith((Set states) {
                return Color(0xffe4e6e9); // Use the default value.
              }),
              headingRowHeight: 30,
              columns: [
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate("app_coins_ps_txtChooseBundle"),
                    style: TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate("app_coins_ps_txtPrice"),
                    style: TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate("app_coins_ps_txtDiscount"),
                    style: TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: products,
            ),
          ),
          Spacer(),
          Padding(
              padding: EdgeInsets.only(right: 30, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                                AppLocalizations.of(context).translate("app_coins_pp_btnBack"),
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
                    onTap: () => purchaseProduct(),
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
                                AppLocalizations.of(context).translate("app_coins_pm_btnContinue"),
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
}
