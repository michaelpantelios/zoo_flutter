import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

typedef OnCloseBtnHandler = void Function();

class PopupContainerBar extends StatefulWidget {
  PopupContainerBar({Key key, @required this.title, @required this.iconData, @required this.onCloseBtnHandler});

  final String title;
  final IconData iconData;
  final OnCloseBtnHandler onCloseBtnHandler;

  PopupContainerBarState createState() => PopupContainerBarState();
}

class PopupContainerBarState extends State<PopupContainerBar> {
  PopupContainerBarState({Key key});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                widget.iconData,
                size: 20,
                color: Colors.white,
              ),
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                    child: Text(
                        AppLocalizations.of(context).translate(widget.title),
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.left))),
            GestureDetector(
                onTap: () => {
                      // print("clicked on "+widget.appInfo.appName)
                    },
                child: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(3),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.white,
                    )))
          ],
        ));
  }
}
