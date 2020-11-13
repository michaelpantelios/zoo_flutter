import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum ZButtonIconPosition { left, right }

class ZButton extends StatefulWidget{
  ZButton({ Key key,
            @required this.clickHandler,
            this.label,
            this.icon,
            this.iconColor,
            this.iconSize,
            this.buttonColor,
            this.labelStyle = const TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
            this.iconPosition = ZButtonIconPosition.left}) : super(key: key);

  final Function clickHandler;
  final String label;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final ZButtonIconPosition iconPosition;
  final Color buttonColor;
  final TextStyle labelStyle;

  ZButtonState createState() => ZButtonState(key: key);
}

class ZButtonState extends State<ZButton>{
  ZButtonState({Key key});

  bool isDisabled;
  TextStyle disabledTextStyle = TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.normal);

  setDisabled(bool value){
    setState(() {
      isDisabled = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    isDisabled = false;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if (widget.label == null && widget.icon == null)
      return RaisedButton(
        onPressed: () {},
        child: Text(
            "error! You must provide either a text or an icon for the button!",
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.normal)),
      );

    return widget.label == null
                ?  FlatButton(
                  minWidth: 1,
                  color: widget.buttonColor,
                  onPressed: isDisabled ? null : widget.clickHandler,
                  child: Icon(widget.icon, color: isDisabled ? Colors.grey[400] : widget.iconColor, size: widget.iconSize)
                )
                : RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  onPressed: isDisabled ? null : widget.clickHandler,
                  color: widget.buttonColor,
                  child: widget.icon == null
                      ? Text(widget.label, style: isDisabled ? disabledTextStyle : widget.labelStyle)
                      :  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.iconPosition == ZButtonIconPosition.left ? Icon(widget.icon, color: isDisabled ? Colors.grey[400] : widget.iconColor, size: widget.iconSize) : Text(widget.label, style: isDisabled ? disabledTextStyle : widget.labelStyle),
                        SizedBox(width: 5),
                        widget.iconPosition == ZButtonIconPosition.left ? Text(widget.label, style: isDisabled ? disabledTextStyle : widget.labelStyle) : Icon(widget.icon, color: isDisabled ? Colors.grey[400] : widget.iconColor, size: widget.iconSize)
                      ])
            );
  }
}