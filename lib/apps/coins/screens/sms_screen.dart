import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmsScreen extends StatefulWidget{
  SmsScreen(this.onBackHandler, this._appSize);

  final Function onBackHandler;
  final Size _appSize;

  SmsScreenState createState() => SmsScreenState();
}

class SmsScreenState extends State<SmsScreen>{
  SmsScreenState();

  bool offerServiceRes = true;
  bool noStarNoCoins = true;
  String starCode = "66666";
  String coinsCode = "11111";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget getOfferArea() {
      return Container();
    }

    Widget noStarNoCoinsArea() {
      return Container();
    }

    Widget simpleArea() {
      return Container();
    }

    return Container(
        color: Theme.of(context).canvasColor,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(5),
                    child: FaIcon(FontAwesomeIcons.coins,
                        size: 50, color: Colors.orange)),
                Column(
                  children: [
                    Text(AppLocalizations.of(context).translate("app_coins_sm_txtHeader"),
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                    Container(
                        padding: EdgeInsets.all(5),
                        width: widget._appSize.width - 90,
                        // height: 100,
                        child: Text(
                            AppLocalizations.of(context)
                                .translate("app_coins_sm_txxDesc"),
                            style: Theme.of(context).textTheme.bodyText1))
                  ],
                ),
              ],
            ),
          ],
        )
    );
  }
}
