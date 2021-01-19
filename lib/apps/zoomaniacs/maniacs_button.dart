import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ManiacsButton extends StatefulWidget {
  ManiacsButton({Key key, this.id, this.title, this.onTapHandler}) : super(key: key);

  final String id;
  final String title;
  final Function onTapHandler;

  ManiacsButtonState createState() => ManiacsButtonState(key: key);
}

class ManiacsButtonState extends State<ManiacsButton>{
  ManiacsButtonState({Key key});

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
             width: 220,
             height: 45,
             margin: EdgeInsets.symmetric(vertical: 2),
             padding: EdgeInsets.all(5),
             decoration: BoxDecoration(
               shape: BoxShape.rectangle,
               color: mouseOver
                   ? Theme.of(context).secondaryHeaderColor
                   : active
                   ?  Theme.of(context).secondaryHeaderColor
                   : Colors.white,
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 SizedBox(width: 5),
                 Text(
                   widget.title,
                   style: TextStyle(
                     color: mouseOver
                         ? Colors.white
                         : active
                         ?  Colors.white
                         : Theme.of(context).secondaryHeaderColor,
                     fontSize: 22,
                     fontWeight: FontWeight.w500,
                   ),
                   textAlign: TextAlign.center,
                 )
               ],
             )),
       )
   );
  }


}