import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/app_info.dart';

class FullAppContainerBarButton extends StatefulWidget {
  FullAppContainerBarButton({Key key, @required this.appInfo});

  final AppInfo appInfo;

  @override
  FullAppContainerBarButtonState createState() => FullAppContainerBarButtonState();
}

class FullAppContainerBarButtonState extends State<FullAppContainerBarButton> {
  FullAppContainerBarButtonState({Key key});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () =>
        {
          print("clicked on "+widget.appInfo.appName)
        },
        child: Container(
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .secondaryHeaderColor,
                border: Border.all(
                  color: Theme
                      .of(context)
                      .secondaryHeaderColor,
                  width: 1.0,
                ),
              ),
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                widget.appInfo.iconPath,
                size: 25,
                color: Colors.white,
              )
          )
    );
  }
}