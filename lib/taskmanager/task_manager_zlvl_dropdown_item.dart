import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskManagerZlvlDropdownItem extends StatefulWidget {
  TaskManagerZlvlDropdownItem({this.text, this.iconPath, this.onTapHandler});

  final String text;
  final String iconPath;
  final Function onTapHandler;

  TaskManagerZlvlDropdownItemState createState() => TaskManagerZlvlDropdownItemState();

}

class TaskManagerZlvlDropdownItemState extends State<TaskManagerZlvlDropdownItem>{
  TaskManagerZlvlDropdownItemState();

  bool mouseOn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ()=>{ widget.onTapHandler() },
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
                        Container(width: 20, height: 20, margin: EdgeInsets.only(right: 10), child: Image.asset(widget.iconPath)),
                        Text(widget.text, style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.left)
                      ],
                    )
                )
            )
        )
    );
  }
}