import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zoo_flutter/models/apps/app_info_model.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/control/root_widget_main_state.dart';


class PanelAppButton extends StatefulWidget {
  PanelAppButton({Key key, @required this.appInfo});

  final AppInfoModel appInfo;

  @override
  PanelAppButtonState createState() => PanelAppButtonState();
}

class PanelAppButtonState extends State<PanelAppButton>{
  PanelAppButtonState({Key key});


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
   final MainState state = Main.of(context, false);
   return GestureDetector(
     onTap: () {
       print("Tapped: "+widget.appInfo.appId);
       state.openApp(widget.appInfo);
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
                   color:  Theme.of(context).primaryIconTheme.color,
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