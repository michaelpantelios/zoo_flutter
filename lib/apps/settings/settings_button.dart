import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsButton extends StatefulWidget{
  SettingsButton({Key key, this.id, this.icon, this.title, this.onTapHandler}): super(key: key);

  final String id;
  final FaIcon icon;
  final String title;
  final Function onTapHandler;

  SettingsButtonState createState() => SettingsButtonState(key: key);
}

class SettingsButtonState extends State<SettingsButton>{
  SettingsButtonState({Key key});

  bool active;
  bool mouseOver;

  @override
  void initState() {
    // TODO: implement initState
    active = false;
    mouseOver = false;
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
      child: GestureDetector(
        onTap: () {
          if (!active)
            widget.onTapHandler(widget.id);
        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            padding: EdgeInsets.all(5),
            color: mouseOver ? Colors.cyan[100] : active ? Colors.cyan[300] : Colors.white,
            child: Row(
              children: [
                Container(
                  width: 30,
                  margin: EdgeInsets.only(left: 5),
                  child:  widget.icon,
                ),
                SizedBox(width: 5),
                Text(widget.title,
                    style: TextStyle(color: Colors.indigo,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    )
                )
              ],
            )
        ),
      )
    );
  }
}
