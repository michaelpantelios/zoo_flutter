import 'package:flutter/cupertino.dart';
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
      this.iconPosition = ZButtonIconPosition.left,
      this.hasBorder = false,
      this.startDisabled = false,
      this.minWidth = 1,
      this.height
      })
      : super(key: key);

  final Function clickHandler;
  final String label;
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final ZButtonIconPosition iconPosition;
  final Color buttonColor;
  final TextStyle labelStyle;
  final bool hasBorder;
  final startDisabled;
  final minWidth;
  final height;

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
    isDisabled = widget.startDisabled;
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
                minWidth: widget.minWidth,
                color: widget.buttonColor,
                onPressed: isDisabled ? null : widget.clickHandler,
                child: FaIcon(widget.iconData,
                    color: isDisabled ? Colors.grey[400] : widget.iconColor,
                    size: widget.iconSize))
            : Container(
                decoration: BoxDecoration(
                  border: widget.hasBorder ?  Border.all(color: Colors.black38, width: 1) : null
                ),
                child: FlatButton(
                    minWidth: widget.minWidth,
                    height: widget.height,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                         // side: BorderSide(color: widget.buttonColor)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    onPressed: isDisabled ? null : widget.clickHandler,
                    color: widget.buttonColor,
                    child: widget.iconData == null
                        ? Text(widget.label,
                            style: isDisabled
                                ? disabledTextStyle
                                : widget.labelStyle)
                        : widget.iconPosition == ZButtonIconPosition.left
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Icon(widget.iconData,
                                        color: isDisabled
                                            ? Colors.grey[400]
                                            : widget.iconColor,
                                        size: widget.iconSize),
                                SizedBox(width: 10),
                                 Text(widget.label,
                                        style: isDisabled
                                            ? disabledTextStyle
                                            : widget.labelStyle)
                              ])
                        : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(widget.label,
                              style: isDisabled
                                  ? disabledTextStyle
                                  : widget.labelStyle),
                          SizedBox(width: 10),
                           Icon(widget.iconData,
                              color: isDisabled
                                  ? Colors.grey[400]
                                  : widget.iconColor,
                              size: widget.iconSize)
                        ])

                ));
  }
}
