import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

zTextField(BuildContext context, double width, TextEditingController _controller, FocusNode _focusNode, String label, {bool obscureText = false}) {
  return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal), textAlign: TextAlign.left),
          Container(
              height: 30,
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              // margin: EdgeInsets.only(bottom: 5),
              child: TextFormField(

                obscureText: obscureText,
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                onChanged: (value) {
                  //todo
                },
                onTap: () {
                  _focusNode.requestFocus();
                },
              )),
        ],
      ));
}
