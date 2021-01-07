import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class PopupContainerBar extends StatelessWidget {
  PopupContainerBar({Key key, @required this.title, this.headerOptions, @required this.iconData, @required this.onClose});

  final String title;
  final IconData iconData;
  final Function onClose;
  final dynamic headerOptions;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: GlobalSizes.appBarHeight,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9.0),
            topRight: Radius.circular(9.0),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Icon(
                iconData,
                size: 20,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Text(
                  headerOptions == null ? AppLocalizations.of(context).translate(title) : AppLocalizations.of(context).translateWithArgs(title, [headerOptions]),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: onClose,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(
                    Icons.close,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
