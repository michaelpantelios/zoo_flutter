import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

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

class StarBankScreenState extends State<StarBankScreen>{
  StarBankScreenState();

  String subscriptionId = "sub4";
  String bankId = "marfin";
  Map<String, BankInfo> banksInfo;

  @override
  void initState() {
    banksInfo = {
      "marfin" : new BankInfo(
        bankName: "Marfin Egnatia Bank",
        bankAccount: "0094226-42/5"
      ),
      "peiraeus" : new BankInfo(
        bankName: "Peiraeus Bank",
        bankAccount: "5029-028546-200"
      )
    };

    super.initState();
  }

  getDepositAmount(){
    switch (subscriptionId){
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
      height: widget._appSize.height-10,
      color: Theme.of(context).canvasColor,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.star,
                      size: 60, color: Colors.orange)),
              Container(
                  width: widget._appSize.width - 90,
                  child: Html(
                      data: AppLocalizations.of(context).translate("app_star_bk_txtHeader"),
                      style: {
                        "html": Style(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontSize: FontSize.large,
                        ),
                      })
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // SizedBox(width:60),
              Column(
                children: [
                    Text(AppLocalizations.of(context).translate("app_star_bk_lblSub"),
                    style: Theme.of(context).textTheme.bodyText1),
                    DropdownButton(
                      value:subscriptionId,
                      items:[
                        DropdownMenuItem(
                          child: Text(AppLocalizations.of(context).translate("app_star_bk_sub1"),
                              style: Theme.of(context).textTheme.headline4),
                          value: "sub1",
                        ),
                        DropdownMenuItem(
                          child: Text(AppLocalizations.of(context).translate("app_star_bk_sub2"),
                              style: Theme.of(context).textTheme.headline4),
                          value: "sub2",
                        ),
                        DropdownMenuItem(
                          child: Text(AppLocalizations.of(context).translate("app_star_bk_sub3"),
                              style: Theme.of(context).textTheme.headline4),
                          value: "sub3",
                        ),
                        DropdownMenuItem(
                          child: Text(AppLocalizations.of(context).translate("app_star_bk_sub4"),
                              style: Theme.of(context).textTheme.headline4),
                          value: "sub4",
                        ),
                      ],
                        onChanged: (value) {
                          setState(() {
                            subscriptionId = value;
                          });
                        }
                    ),
                ],
              ),
              Column(
                children: [
                  Text(AppLocalizations.of(context).translate("app_star_bk_lblSub"),
                      style: Theme.of(context).textTheme.bodyText1),
                  DropdownButton(
                    value: bankId,
                    items: [
                      DropdownMenuItem(
                        child: Text(banksInfo["marfin"].bankName,
                            style: Theme.of(context).textTheme.headline4),
                        value: "marfin",
                      ),
                      DropdownMenuItem(
                        child: Text(banksInfo["peiraeus"].bankName,
                            style: Theme.of(context).textTheme.headline4),
                        value: "peiraeus",
                      )
                    ],
                      onChanged: (value) {
                        setState(() {
                          bankId = value;
                        });
                      }
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
                width: widget._appSize.width - 80,
                child: Html(
                    data: AppLocalizations.of(context).translateWithArgs("app_star_bk_txtInfo", [getDepositAmount(), banksInfo[bankId].bankName, banksInfo[bankId].bankAccount]),
                    style: {
                      "html": Style(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontSize: FontSize.medium
                      ),
                    })
            )
          ),
          Expanded(child: Container()),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            width: widget._appSize.width * 0.3,
            child: RaisedButton(
              onPressed:(){
                widget.onBackHandler();
              },
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding( padding: EdgeInsets.only(right: 5), child:Icon(Icons.arrow_back, size: 20, color:Colors.black) ),
                  Text(
                    AppLocalizations.of(context).translate("app_star_bk_btnBack"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}