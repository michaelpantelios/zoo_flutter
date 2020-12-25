import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class MessengerChat extends StatefulWidget {
  MessengerChat({this.onClose, this.setBusy});

  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;

  MessengerChatState createState() => MessengerChatState();
}

class MessengerChatState extends State<MessengerChat> {
  MessengerChatState();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Text(AppLocalizations.of(context).translate("unavailable_service"),
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center)
        )
    );
  }
}
