import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

zTextField(BuildContext context, double width, TextEditingController _controller, FocusNode _focusNode, String label, {bool obscureText = false}) {
  return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          label != "" ?
          Container(
              height: 20,
              padding: EdgeInsets.only(left: 10),
              child:   Text(
                  label,
                  style: TextStyle(
                      fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left)
          )
              : Container(),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  new BoxShadow(color:  Color(0xffC7C6C6), offset: new Offset(0.0, 0.0), blurRadius: 2, spreadRadius: 2),
                ],
              ),
              height: 30,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(5),
              // margin: EdgeInsets.only(bottom: 5),
              child: TextFormField(
                decoration: InputDecoration.collapsed(
                  hintText: "",
                  border: InputBorder.none,
                ),
                obscureText: obscureText,
                controller: _controller,
                focusNode: _focusNode,
                // decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
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
