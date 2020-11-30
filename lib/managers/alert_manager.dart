import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertChoices {
  static const OK = 1;
  static const CANCEL = 2;
  static const OK_CANCEL = 3;
}

class AlertManager {
  AlertManager._privateConstructor();

  static final AlertManager instance = AlertManager._privateConstructor();

  Future<bool> showSimpleAlert({@required BuildContext context, @required String title, String desc = "", int dialogButtonChoice = AlertChoices.OK, AlertType alertType = AlertType.info}) async {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromBottom,
      isCloseButton: true,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      descTextAlign: TextAlign.start,
      // animationDuration: Duration(milliseconds: 0),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        fontSize: 20,
        color: Colors.red,
      ),
      alertAlignment: Alignment.center,
    );
    return await Alert(
      context: context,
      style: alertStyle,
      title: title,
      type: alertType,
      content: (desc != null && desc != "")
          ? Padding(
              padding: EdgeInsets.only(top: 15),
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 400),
                child: Text(
                  desc,
                  style: alertStyle.descStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Container(),
      buttons: _buildButtons(context, dialogButtonChoice),
    ).show();
  }

  _buildButtons(context, dialogButtonChoice) {
    List<DialogButton> arr = [];
    if (dialogButtonChoice == AlertChoices.OK) {
      arr.add(DialogButton(
        color: Colors.blueAccent,
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        width: 120,
      ));
    } else if (dialogButtonChoice == AlertChoices.CANCEL) {
      arr.add(DialogButton(
        color: Colors.grey,
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        width: 120,
      ));
    } else if (dialogButtonChoice == AlertChoices.OK_CANCEL) {
      arr = [
        DialogButton(
          color: Colors.blueAccent,
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.grey,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          width: 120,
        )
      ];
    }

    return arr;
  }
}
