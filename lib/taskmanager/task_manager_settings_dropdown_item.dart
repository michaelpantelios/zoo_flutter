
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskmanagerSettingsDropdownItem extends StatefulWidget {
  TaskmanagerSettingsDropdownItem({Key key, @required this.text, @required this.iconData, @required this.onTapHandler });

  final String text;
  final IconData iconData;
  final Function onTapHandler;

  TaskmanagerSettingsDropdownItemState createState() => TaskmanagerSettingsDropdownItemState();
}

class TaskmanagerSettingsDropdownItemState extends State<TaskmanagerSettingsDropdownItem>{
  TaskmanagerSettingsDropdownItemState({Key key});

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
                color : mouseOn ? Colors.grey[200] : Colors.white,
                child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 7, bottom: 7),
                    child: Row(
                      children: [
                        Container(margin: EdgeInsets.only(right: 5), child: Icon(widget.iconData, color: Theme.of(context).textTheme.headline5.color, size: 20)),
                        Text(widget.text, style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.left)
                      ],
                    )
                )
            )
        )
    );
  }
}

