import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SettingsButton extends StatefulWidget {
  SettingsButton({Key key, this.id, this.icon, this.title, this.onTapHandler}) : super(key: key);

  final String id;
  final String icon;
  final String title;
  final Function onTapHandler;

  SettingsButtonState createState() => SettingsButtonState(key: key);
}

class SettingsButtonState extends State<SettingsButton> {
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

  setActive(bool value) {
    setState(() {
      active = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) {
          setState(() {
            mouseOver = true;
          });
        },
        onExit: (_) {
          setState(() {
            mouseOver = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            if (!active) widget.onTapHandler(widget.id);
          },
          child: Container(
              width: 180,
              margin: EdgeInsets.symmetric(vertical: 2),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: mouseOver
                    ? Colors.grey[300]
                    : active
                        ? Color(0xffe4e6e9)
                        : Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/settings/${widget.icon}.png",
                    width: 25,
                    height: 25,
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Color(0xff393e54),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )),
        ));
  }
}
