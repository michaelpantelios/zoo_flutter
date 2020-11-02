import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/models/apps/app_info.dart';

class PopupContainer extends StatefulWidget {
  PopupContainer({Key key, @required this.appInfo });

  final AppInfo appInfo;

  PopupContainerState createState() => PopupContainerState();

}

class PopupContainerState extends State<PopupContainer>{
  PopupContainerState();

  Widget _app;

  onCloseBtnHandler(){

  }

  @override
  void initState() {
    super.initState();
    _app = widget.appInfo.appWidget;

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: new Color.fromRGBO(0, 0, 0, 0.8) // Specifies the background color and the opacity
            ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.all(5),
            width: widget.appInfo.size.width,
            height: widget.appInfo.size.height + 45,
            color: Colors.white,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PopupContainerBar(
                    title: widget.appInfo.appName,
                    iconData: widget.appInfo.iconPath,
                    onCloseBtnHandler: onCloseBtnHandler,
                ),
                SizedBox(height: 5),
                _app
              ],
            )
          )
        )
      ],
    );
  }
}