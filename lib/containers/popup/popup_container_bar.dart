import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class PopupContainerBar extends StatelessWidget {
  PopupContainerBar({Key key, @required this.title, @required this.iconData, @required this.onClose});

  final String title;
  final IconData iconData;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: GlobalSizes.appBarHeight,
        padding: EdgeInsets.symmetric(horizontal:10),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9.0),
                topRight: Radius.circular(9.0))
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                iconData,
                size: 30,
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
            FlatButton(
              minWidth: 30,
              height: 30,
              padding: EdgeInsets.all(0),
                onPressed: () {
                  print("popup bar close button pressed.");
                  onClose();
                },
                child:
                    // Container(
                    // width: 30,
                    // height: 30,
                    // color: Theme.of(context).primaryColor,
                    // padding: EdgeInsets.all(3),
                    // child:
                    Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.white,
                    )
                // )
            )
          ],
        ));
  }
}
