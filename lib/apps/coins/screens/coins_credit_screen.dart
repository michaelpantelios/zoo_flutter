import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

class CoinsCreditScreen extends StatefulWidget {
  CoinsCreditScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  CoinsCreditScreenState createState() => CoinsCreditScreenState();
}

class CoinsCreditScreenState extends State<CoinsCreditScreen> {
  CoinsCreditScreenState();

  List<DataRow> products = new List<DataRow>();
  String _product;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _product = "coins100";
  }

  purchaseProduct() {
    print("Buy this product:" + _product);

    var random = new Random();
    window.open("${Env.zooURL}/cgiapp/wallet/order.pl?rm=viva_redirect&type=$_product&rkey=${random.nextInt(10000).toString()}", "buycoins", "width=1000,height=768,scrollbars=yes,resizable=yes,menubar=yes,toolbar=yes,status=no");
  }

  DataRow createProductRow(String prodid) {
    var productStringsArray = AppLocalizations.of(context).translate("app_coins_cc_" + prodid).split("|");
    List<DataCell> cells = new List<DataCell>();

    cells.add(new DataCell(Container(
        // width: 300,
        child: RadioListTile<String>(
      title: Text(productStringsArray[0], style: TextStyle(
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
    ))));

    cells.add(new DataCell(Text(productStringsArray[1], style: TextStyle(
        fontSize: 12.0,
        color: Color(0xFF111111),
        fontWeight: FontWeight.normal))));

    cells.add(new DataCell(Text(productStringsArray[2], style: TextStyle(
        fontSize: 12.0,
        color: Color(0xFF111111),
        fontWeight: FontWeight.normal))));
    DataRow row = new DataRow(cells: cells);

    return row;
  }

  @override
  Widget build(BuildContext context) {
    products.clear();
    products.add(createProductRow("coins100"));
    products.add(createProductRow("coins200"));
    if (!UserProvider.instance.userInfo.isStar) products.add(createProductRow("combo160"));
    products.add(createProductRow("coins400"));
    if (!UserProvider.instance.userInfo.isStar) products.add(createProductRow("combo320"));
    if (!UserProvider.instance.userInfo.isStar) products.add(createProductRow("combo640"));
    products.add(createProductRow("coins800"));
    if (!UserProvider.instance.userInfo.isStar) products.add(createProductRow("combo1280"));

    return Container(
        height: widget._appSize.height - 10,
        color: Color(0xFFffffff),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.all(10), child: FaIcon(FontAwesomeIcons.coins, size: 50, color: Colors.orange)),
                Container(
                    width: widget._appSize.width - 80,
                    child: Html(data: AppLocalizations.of(context).translate("app_coins_cc_txtHeader"), style: {
                      "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.large),
                    }))
              ],
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Html(data: AppLocalizations.of(context).translate(UserProvider.instance.userInfo.isStar ? "app_coins_cc_subHeaderStar" : "app_coins_cc_subHeaderNonStar"), style: {
                  "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium, textAlign: TextAlign.left),
                })),
            DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate("app_coins_cc_txtChooseBundle"),
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate("app_coins_cc_txtPrice"),
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate("app_coins_cc_txtDiscount"),
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: products,
            ),
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
                            AppLocalizations.of(context).translate("app_coins_cc_btnBack"),
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
                        purchaseProduct();
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("app_coins_cc_btnContinue"),
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF111111),
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(Icons.arrow_right_alt, size: 20, color: Colors.black)
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
