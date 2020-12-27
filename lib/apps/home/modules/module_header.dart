import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

getModuleHeader(title){
  return Container(
    height: 40,
    decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9.0),
            topRight: Radius.circular(9.0))
    ),
    padding: EdgeInsets.only(left: 13),
    alignment: Alignment.centerLeft,
    child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.left),
  );
}