import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/control/user.dart';

class PayPalScreen extends StatefulWidget{
  PayPalScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  PayPalScreenState createState() => PayPalScreenState();
}

class PayPalScreenState extends State<PayPalScreen>{
  PayPalScreenState();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget._appSize.height - 10,
      color: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: FaIcon(FontAwesomeIcons.coins,
                      size: 50, color: Colors.orange)),
              Container(
                  width: widget._appSize.width - 80,
                  child: Html(
                      data: AppLocalizations.of(context).translate("app_coins_pp_txtHeader"),
                      style: {
                        "html": Style(
                            backgroundColor: Colors.white,
                            color: Colors.black,
                            fontSize: FontSize.medium
                        ),
                      })
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.all(5),
              child: Html(
                  data: AppLocalizations.of(context).translate( User.instance.userInfo.star ? "app_coins_pp_subHeaderStar" : "app_coins_pp_subHeaderNonStar"),
                  style: {
                    "html": Style(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontSize: FontSize.medium,
                        textAlign: TextAlign.left
                    ),
                  })
          ),
        ],
      )
    );
  }
}