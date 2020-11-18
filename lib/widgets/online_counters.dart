import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/providers/users_counter.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class OnlineCounters extends StatelessWidget {
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
                Text(
                  AppLocalizations.of(context).translate("panelHeader_online_counter"),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.right,
                ),
                Text(
                  context.select((UsersCounter counter) => counter.onLineUsers).toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ],
            )),
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(2),
            color: Theme.of(context).secondaryHeaderColor,
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).translate("panelHeader_games_counter"),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.right,
                ),
                Text(
                  context.select((UsersCounter counter) => counter.onGamesUsers).toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ],
            )),
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(2),
            color: Theme.of(context).secondaryHeaderColor,
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).translate("panelHeader_chat_counter"),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.right,
                ),
                Text(
                  context.select((UsersCounter counter) => counter.onChatUsers).toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ],
            )),
      ],
    );
  }
}
