import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class Coins extends StatefulWidget {
  Coins();

  CoinsState createState() => CoinsState();
}

class CoinsState extends State<Coins>{
  CoinsState({Key key});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Container(
       color: Theme.of(context).canvasColor,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            // height: 100,
            child: Text(AppLocalizations.of(context).translate("app_coins_intro"),
                style: Theme.of(context).textTheme.bodyText1)
          )
        ],
      )
   );
  }
}
