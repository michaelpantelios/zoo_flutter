import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

zDropdownButton(BuildContext context, String label, double width, Object value, List items, Function onChangeHandler){
  return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              label,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.left),
          Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black26, width: 1),
              ),
              child: DropdownButton(
                isDense: true,
                value: value,
                items: items,
                onChanged: (value) {
                 onChangeHandler(value);
                },
              ))
        ],
      ));

}