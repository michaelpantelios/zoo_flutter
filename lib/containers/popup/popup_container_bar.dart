import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class PopupContainerBar extends StatelessWidget {
  PopupContainerBar({Key key, @required this.title, @required this.iconData, @required this.onClose});

  final String title;
  final IconData iconData;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF07438c),
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
                  style: TextStyle(
                      fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  print("popup bar close button pressed.");
                  onClose();
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
