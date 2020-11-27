import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ZButtonIconPosition { left, right }

class ZButton extends StatefulWidget {
  ZButton(
      {Key key,
      @required this.clickHandler,
      this.label,
      this.iconData,
      this.iconColor,
      this.iconSize,
      this.buttonColor,
      this.labelStyle = const TextStyle(
          color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
      this.iconPosition = ZButtonIconPosition.left})
      : super(key: key);

  final Function clickHandler;
  final String label;
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final ZButtonIconPosition iconPosition;
  final Color buttonColor;
  final TextStyle labelStyle;

  ZButtonState createState() => ZButtonState(key: key);
}

class ZButtonState extends State<ZButton> {
  ZButtonState({Key key});

  bool isHidden;
  bool isDisabled;
  TextStyle disabledTextStyle = TextStyle(
      color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.normal);

  setDisabled(bool value) {
    setState(() {
      isDisabled = value;
    });
  }

  setHidden(bool value) {
    setState(() {
      isHidden = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    isHidden = false;
    isDisabled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.label == null && widget.iconData == null)
      return Text(
          "error! You must provide either a text or an icon for the button!",
          style: TextStyle(
              color: Colors.red, fontSize: 12, fontWeight: FontWeight.normal));

    return isHidden
        ? Container()
        : widget.label == null
            ? FlatButton(
                minWidth: 1,
                color: widget.buttonColor,
                onPressed: isDisabled ? null : widget.clickHandler,
                child: FaIcon(widget.iconData,
                    color: isDisabled ? Colors.grey[400] : widget.iconColor,
                    size: widget.iconSize))
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1),
                ),
                child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    onPressed: isDisabled ? null : widget.clickHandler,
                    color: widget.buttonColor,
                    child: widget.iconData == null
                        ? Text(widget.label,
                            style: isDisabled
                                ? disabledTextStyle
                                : widget.labelStyle)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                widget.iconPosition == ZButtonIconPosition.left
                                    ? Icon(widget.iconData,
                                        color: isDisabled
                                            ? Colors.grey[400]
                                            : widget.iconColor,
                                        size: widget.iconSize)
                                    : Text(widget.label,
                                        style: isDisabled
                                            ? disabledTextStyle
                                            : widget.labelStyle),
                                SizedBox(width: 10),
                                widget.iconPosition == ZButtonIconPosition.left
                                    ? Text(widget.label,
                                        style: isDisabled
                                            ? disabledTextStyle
                                            : widget.labelStyle)
                                    : Icon(widget.iconData,
                                        color: isDisabled
                                            ? Colors.grey[400]
                                            : widget.iconColor,
                                        size: widget.iconSize)
                              ])));
  }
}
