import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class BankInfo {
  String bankName;
  String bankAccount;

  BankInfo({this.bankName, this.bankAccount});
}

class StarBankScreen extends StatefulWidget {
  StarBankScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  StarBankScreenState createState() => StarBankScreenState();
}

class StarBankScreenState extends State<StarBankScreen> {
  StarBankScreenState();

  String subscriptionId = "sub4";
  String bankId = "peiraeus";
  Map<String, BankInfo> banksInfo;

  @override
  void initState() {
    banksInfo = {"peiraeus": new BankInfo(bankName: "Τράπεζα Πειραιώς", bankAccount: "GR77 0172 0290 0050 2902 8546 200")};

    super.initState();
  }

  getDepositAmount() {
    switch (subscriptionId) {
      case "sub1":
        return "5€";
      case "sub2":
        return "12€";
      case "sub3":
        return "20€";
      case "sub4":
        return "33€";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget._appSize.height - 10,
      color: Color(0xFFffffff),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/star/bank_header.png",
              ),
              Positioned(
                top: 20,
                left: 220,
                child: Container(
                  width: 330,
                  // height: 100,
                  child: Html(
                    data: AppLocalizations.of(context).translate("app_star_bk_txtHeader"),
                    style: {"html": Style(color: Colors.black, fontSize: FontSize.large, fontWeight: FontWeight.w500, textAlign: TextAlign.left)},
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).translate("app_star_bk_lblSub"), style: TextStyle(fontSize: 14.0, color: Color(0xFF9598a4), fontWeight: FontWeight.w500)),
                Container(
                  width: 200,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      new BoxShadow(color: Color(0xffC7C6C6), offset: new Offset(0.0, 0.0), blurRadius: 1, spreadRadius: 1),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: subscriptionId,
                        items: [
                          DropdownMenuItem(
                            child: Text(AppLocalizations.of(context).translate("app_star_bk_sub1"), style: TextStyle(fontSize: 14.0, color: Color(0xff000000), fontWeight: FontWeight.normal)),
                            value: "sub1",
                          ),
                          DropdownMenuItem(
                            child: Text(AppLocalizations.of(context).translate("app_star_bk_sub2"), style: TextStyle(fontSize: 14.0, color: Color(0xff000000), fontWeight: FontWeight.normal)),
                            value: "sub2",
                          ),
                          DropdownMenuItem(
                            child: Text(AppLocalizations.of(context).translate("app_star_bk_sub3"), style: TextStyle(fontSize: 14.0, color: Color(0xff000000), fontWeight: FontWeight.normal)),
                            value: "sub3",
                          ),
                          DropdownMenuItem(
                            child: Text(AppLocalizations.of(context).translate("app_star_bk_sub4"), style: TextStyle(fontSize: 14.0, color: Color(0xff000000), fontWeight: FontWeight.normal)),
                            value: "sub4",
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            subscriptionId = value;
                          });
                        }),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 35),
            child: Container(
              width: widget._appSize.width - 80,
              child: Html(
                data: AppLocalizations.of(context).translateWithArgs("app_star_bk_txtInfo", [getDepositAmount(), banksInfo[bankId].bankName, banksInfo[bankId].bankAccount]),
                style: {
                  "html": Style(color: Colors.black, fontSize: FontSize.medium, fontWeight: FontWeight.w500),
                },
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 20),
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
                              AppLocalizations.of(context).translate("app_star_bk_btnBack"),
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
      ),
    );
  }
}
