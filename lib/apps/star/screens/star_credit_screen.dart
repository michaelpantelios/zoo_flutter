import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

class StarCreditScreen extends StatefulWidget {
  StarCreditScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  StarCreditScreenState createState() => StarCreditScreenState();
}

class StarCreditScreenState extends State<StarCreditScreen> {
  StarCreditScreenState();

  String _product;
  List<DataRow> products = new List<DataRow>();

  buyProduct() {
    print("buy permanent subscription");

    var random = new Random();
    window.open("${Env.cgiHost}/cgiapp/wallet/order.pl?rm=viva_redirect&type=$_product&rkey=${random.nextInt(10000).toString()}", "pay", "width=1000,height=768,scrollbars=yes,resizable=yes,menubar=yes,toolbar=yes,status=no");
  }

  @override
  void initState() {
    _product = "star1";
    super.initState();
  }

  DataRow createProductRow(String prodid) {
    String label = AppLocalizations.of(context).translate("app_star_cc_" + prodid);
    List<DataCell> cells = new List<DataCell>();

    cells.add(
      new DataCell(
        Container(
          // width: 300,
          child: RadioListTile<String>(
            contentPadding: EdgeInsets.only(left: 0),
            title: Text(label, style: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal)),
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

    DataRow row = new DataRow(cells: cells);

    return row;
  }

  @override
  Widget build(BuildContext context) {
    products.clear();
    products.add(createProductRow("star1"));
    products.add(createProductRow("star3"));
    products.add(createProductRow("star6"));
    products.add(createProductRow("star12"));

    return Container(
        height: widget._appSize.height - 10,
        color: Color(0xFFffffff),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/star/credit_header.png",
                ),
                Positioned(
                  top: 20,
                  left: 220,
                  child: Container(
                    width: 330,
                    // height: 100,
                    child: Html(
                      data: AppLocalizations.of(context).translate("app_star_cc_txtHeader"),
                      style: {"html": Style(color: Colors.black, fontSize: FontSize.large, fontWeight: FontWeight.w500, textAlign: TextAlign.left)},
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, left: 35),
              child: Text(
                AppLocalizations.of(context).translate("app_star_cc_txtSubHeader"),
                style: TextStyle(fontSize: 13.0, color: Color(0xFF111111), fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 10),
              child: Container(
                width: 600,
                height: 300,
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
                  children: [
                    DataTable(
                      headingRowHeight: 0,
                      columns: [
                        DataColumn(
                          label: Container(),
                        ),
                      ],
                      rows: products,
                    ),
                  ],
                ),
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
                                AppLocalizations.of(context).translate("app_star_cc_btnCancel"),
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
                    onTap: () => buyProduct(),
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
                                AppLocalizations.of(context).translate("app_star_cc_btnGo"),
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
              ),
            ),
          ],
        ));
  }
}
