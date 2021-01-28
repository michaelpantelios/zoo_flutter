import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatUserDropdownItem extends StatefulWidget {
  ChatUserDropdownItem({Key key, @required this.text, @required this.iconPath, @required this.onTapHandler });

  final String text;
  final String iconPath;
  final Function onTapHandler;

  ChatUserDropdownItemState createState() => ChatUserDropdownItemState();
}

class ChatUserDropdownItemState extends State<ChatUserDropdownItem>{
  ChatUserDropdownItemState({Key key});

  bool mouseOn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => widget.onTapHandler(),
      child: MouseRegion(
        onHover: (_)  {
          if (!mouseOn){
            setState(() {
              mouseOn = true;
            });
          }
        },
        onExit: (_)  {
          setState(() {
            mouseOn = false;
          });
        },
        child: Container(
              color : mouseOn ? Colors.cyan[100] : Colors.white,
              child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(margin: EdgeInsets.only(right: 5), child: Image.asset(widget.iconPath, width: 20)),
                        Text(widget.text, style: TextStyle(color: Colors.grey[900], fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left)
                      ],
                    )
                )
          )
      )
    );
  }
}

