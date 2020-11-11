import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum ZButtonIconPosition { left, right }

Widget zButton(
    {@required Function clickHandler,
    String text,
    Widget icon,
    ZButtonIconPosition iconPosition = ZButtonIconPosition.left,
    Color buttonColor = Colors.white,
    TextStyle labelStyle = const TextStyle(
        color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal)}) {
  if (text == null && icon == null)
    return RaisedButton(
      onPressed: () {},
      child: Text(
          "error! You must provide either a text or an icon for the button!",
          style: TextStyle(
              color: Colors.red, fontSize: 12, fontWeight: FontWeight.normal)),
    );

  return text == null
      ? FlatButton(
    minWidth: 30,
          onPressed: () {
            clickHandler();
          },
          child: icon)
      : RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 5),
          onPressed: () {
            clickHandler();
          },
          color: buttonColor,
          child: icon == null
              ? Text(text, style: labelStyle)
              : iconPosition == ZButtonIconPosition.left
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      icon,
                      SizedBox(width: 5),
                      Text(text, style: labelStyle)
                    ])
                  : Row(
                      children: [
                        Text(text, style: labelStyle),
                        SizedBox(width: 5),
                        icon
                      ],
                    ));
}
