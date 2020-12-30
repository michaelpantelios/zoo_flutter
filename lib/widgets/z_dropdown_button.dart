import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

zDropdownButton(BuildContext context, String label, double width, Object value, List items, Function onChangeHandler){
  return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          label != "" ?
          Text(
              label,
              style: TextStyle(
                  fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left) : Container(),
          Container(
              width: width,
              padding: EdgeInsets.all(5),
              // margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black26, width: 1),
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  new BoxShadow(color:  Color(0x33000000), offset: new Offset(0.0, 0.0), blurRadius: 2, spreadRadius: 2),
                ],
              ),
              alignment: Alignment.center,
              child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  iconSize: 22,
                  isDense: true,
                  value: value,
                  items: items,
                  onChanged: (value) {
                   onChangeHandler(value);
                  },
                )
              )
  )
        ],
      ));

}