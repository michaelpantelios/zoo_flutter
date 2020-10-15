import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zoo_flutter/models/app_button_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';


class AppButton extends StatefulWidget {
  AppButton({Key key, @required this.info});

  final AppButtonInfo info;

  @override
  AppButtonState createState() => AppButtonState();
}

class AppButtonState extends State<AppButton>{
  AppButtonState({Key key});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: () => {
       print("Tapped: "+widget.info.appId)
     },
     child: Container(
         padding: EdgeInsets.all(5),
         decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.centerLeft,
             end: Alignment.centerRight,
             colors: [
               Theme.of(context).backgroundColor,
               Theme.of(context).canvasColor,
             ],
             stops: [0, 0.9],
             tileMode: TileMode.clamp,
           ),
           border: Border.all(
             color: Theme.of(context).backgroundColor,
             width: 1.0,
           ),
           borderRadius: BorderRadius.all(
             Radius.circular(5.0),
           ),
         ),
         child: Row(
           children: [
             Container(
                 margin: EdgeInsets.only(right: 10),
                 child: Icon(
                   widget.info.iconPath,
                   color:  Theme.of(context).primaryColor,
                   size: 32
                 )
             ),
             Container(
                 margin:EdgeInsets.only(right: 10),
                 child: Text(
                   AppLocalizations.of(context).translate(widget.info.appName),
                   style: Theme.of(context).textTheme.headline1,
                   textAlign: TextAlign.left,
                 )
             ),
             Container()
           ],
         )
     ),
   );
  }
}