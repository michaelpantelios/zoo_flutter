import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

getModuleHeader(title, BuildContext context){
  return Container(
    height: 40,
    decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9.0),
            topRight: Radius.circular(9.0))
    ),
    padding: EdgeInsets.only(left: 12),
    alignment: Alignment.centerLeft,
    child: Text(title, style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.left),
  );
}