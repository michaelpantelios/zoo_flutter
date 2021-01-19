import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

class StarPayPalScreen extends StatelessWidget {
  StarPayPalScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  buyProduct() {
    print("buy permanent subscription");

    var random = new Random();
    window.open("${Env.cgiHost}/cgiapp/wallet/order.pl?rm=pp_redirect&type=star_recurring&rkey=${random.nextInt(10000).toString()}", "pay", "width=960,height=700,scrollbars=yes,resizable=yes,menubar=yes,toolbar=yes,status=no");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _appSize.height - 10,
      color: Color(0xFFffffff),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/star/paypal_header.png",
              ),
              Positioned(
                top: 20,
                left: 220,
                child: Container(
                  width: 300,
                  // height: 100,
                  child: Html(
                    data: AppLocalizations.of(context).translate("app_star_pp_txtHeader_1"),
                    style: {"html": Style(color: Colors.black, fontSize: FontSize.large, textAlign: TextAlign.left)},
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Html(
              data: AppLocalizations.of(context).translate("app_star_pp_txtHeader_2"),
              style: {"html": Style(color: Colors.black, fontSize: FontSize.medium, fontWeight: FontWeight.w500, textAlign: TextAlign.left)},
            ),
          ),
          Spacer(),
          Padding(
              padding: EdgeInsets.only(right: 26, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => onBackHandler(),
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
                                AppLocalizations.of(context).translate("app_star_pp_btnBack"),
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
                                AppLocalizations.of(context).translate("app_star_pm_btnGo"),
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
