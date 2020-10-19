import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar_button.dart';

class FullAppContainerBar extends StatefulWidget{
  FullAppContainerBar({Key key, @required this.title, @required this.iconData});

  final String title;
  final IconData iconData;

  @override
  FullAppContainerBarState createState() => FullAppContainerBarState();
}

class FullAppContainerBarState extends State<FullAppContainerBar>{
  FullAppContainerBarState({Key key});


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
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
                widget.iconData,
                size: 20,
                color: Colors.white,
            ),
          ),
          Expanded(
            child:  Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                child: Text(AppLocalizations.of(context).translate(widget.title), style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.left)
            )
          ),
          FullAppContainerBarButton(appInfo: DataMocker.apps["profile"]),
          FullAppContainerBarButton(appInfo: DataMocker.apps["star"]),
          FullAppContainerBarButton(appInfo: DataMocker.apps["coins"]),
          FullAppContainerBarButton(appInfo: DataMocker.apps["messenger"]),
          FullAppContainerBarButton(appInfo: DataMocker.apps["notifications"]),
          FullAppContainerBarButton(appInfo: DataMocker.apps["settings"])
         ]
      )
    );
  }

}