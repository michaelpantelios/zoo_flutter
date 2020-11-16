import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar.dart';
import 'package:zoo_flutter/models/apps/app_info_model.dart';

class FullAppContainer extends StatefulWidget {
  FullAppContainer({Key key, @required this.appInfo});

  final AppInfoModel appInfo;

  FullAppContainerState createState() => FullAppContainerState();
}

class FullAppContainerState extends State<FullAppContainer>{
  FullAppContainerState({Key key});

  Widget _app;

  @override
  void initState() {
    super.initState();
    _app = widget.appInfo.appWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(3.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FullAppContainerBar(title: widget.appInfo.appName, iconData: widget.appInfo.iconPath),
          SizedBox(height: 5),
             _app
        ],
      )
    );
  }
}