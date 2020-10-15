import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zoo_flutter/utils/app_localizations.dart';

class OnlineCounters extends StatefulWidget{
  OnlineCounters({Key key});

  @override
  OnlineCountersState createState() => OnlineCountersState();
}

class OnlineCountersState extends State<OnlineCounters>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(2),
              color: Theme.of(context).secondaryHeaderColor,
              child: Row(
                children: [
                  Text(AppLocalizations.of(context).translate("panelHeader_online_counter"), style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.right),
                  Text("666", style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.left),
                ],
              )
          ),

        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(2),
            color: Theme.of(context).secondaryHeaderColor,
            child: Row (
              children: [
                Text(AppLocalizations.of(context).translate("panelHeader_games_counter"), style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.right),
                Text("123", style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.left),
              ],
            )
          ),

        Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(2),
                color: Theme.of(context).secondaryHeaderColor,
                child: Row (
                  children: [
                    Text(AppLocalizations.of(context).translate("panelHeader_chat_counter"), style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.right),
                    Text("333", style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.left),
                  ],
                )
            ),

      ],
    );
  }
}