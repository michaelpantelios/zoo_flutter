import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class SettingsButton extends StatefulWidget{
  SettingsButton({Key key, this.id, this.icon, this.title});

  final String id;
  final Icon icon;
  final String title;

  SettingsButtonState createState() => SettingsButtonState();
}

class SettingsButtonState extends State<SettingsButton>{
  SettingsButtonState({Key key});

  bool active;
  bool mouseOver;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  setActive(bool value){
    setState(() {
      active = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MouseRegion(
      onEnter: (_){
        setState(() {
          mouseOver = true;
        });
      },
      onExit: (_){
        setState(() {
          mouseOver = false;
        });
      },
      child: Container(
        color: mouseOver ? Colors.cyan[200] : active ? Colors.cyan : Colors.white,
        child: Row(
          children: [
            widget.icon,
            SizedBox(width: 5),
            Text(widget.title,
                style: TextStyle(color: Colors.purple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                )
            )
          ],
        )
      )
    );
  }
}
