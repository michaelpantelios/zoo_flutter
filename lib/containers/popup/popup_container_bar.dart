import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

typedef OnCloseBtnHandler = void Function();

class PopupContainerBar extends StatelessWidget {
  PopupContainerBar({Key key, @required this.title, @required this.iconData, @required this.onCloseBtnHandler});

  final String title;
  final IconData iconData;
  final OnCloseBtnHandler onCloseBtnHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                iconData,
                size: 20,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                child: Text(
                  AppLocalizations.of(context).translate(title),
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  print("popup bar close button pressed.");
                  onCloseBtnHandler();
                },
                child: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.white,
                    )))
          ],
        ));
  }
}
