import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zoo_flutter/models/app_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';


class AppButton extends StatefulWidget {
  AppButton({Key key, @required this.appInfo});

  final AppInfo appInfo;

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
       print("Tapped: "+widget.appInfo.appId)
     },
     child: Container(
         padding: EdgeInsets.all(5),
         decoration: BoxDecoration(
           color: Theme.of(context).buttonColor,
           border: Border.all(
             color: Theme.of(context).buttonColor,
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
                   widget.appInfo.iconPath,
                   color:  Theme.of(context).primaryColor,
                   size: 32
                 )
             ),
             Container(
                 margin:EdgeInsets.only(right: 10),
                 child: Text(
                   AppLocalizations.of(context).translate(widget.appInfo.appName),
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