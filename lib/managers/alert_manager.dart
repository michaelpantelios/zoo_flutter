import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

typedef OnCallbackAction = void Function(dynamic retValue);

class AlertChoices {
  static const OK = 1;
  static const CANCEL = 2;
  static const OK_CANCEL = 3;
}

class AlertManager {
  AlertManager._privateConstructor();

  static final AlertManager instance = AlertManager._privateConstructor();

  Future<dynamic> showSimpleAlert({@required BuildContext context, @required String bodyText, OnCallbackAction callbackAction, int dialogButtonChoice = AlertChoices.OK}) async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget _child = ConstrainedBox(
          constraints: BoxConstraints.expand(width: double.infinity, height: double.infinity),
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: SimpleDialog(
                // key: Key(id),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                elevation: 10,
                contentPadding: EdgeInsets.zero,
                children: [
                  SimpleAlert(
                    bodyText,
                    dialogButtonChoice,
                    (retValue) => _closeAlert(callbackAction, context, retValue),
                  ),
                ],
              ),
            ),
          ),
        );
        return _child;
      },
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.2),
      useRootNavigator: true,
    );
  }

  Future<dynamic> showPromptAlert({@required context, @required title, @required OnCallbackAction callbackAction}) async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget _child = ConstrainedBox(
          constraints: BoxConstraints.expand(width: double.infinity, height: double.infinity),
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: SimpleDialog(
                // key: Key(id),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                elevation: 10,
                contentPadding: EdgeInsets.zero,
                children: [
                  PromptAlert(title, (retValue) => _closeAlert(callbackAction, context, retValue)),
                ],
              ),
            ),
          ),
        );
        return _child;
      },
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.2),
      useRootNavigator: true,
    );
  }

  _closeAlert(OnCallbackAction callbackAction, BuildContext context, dynamic retValue) {
    print("close alert, retValue: $retValue");
    Navigator.of(context, rootNavigator: true).pop();
    if (callbackAction != null && retValue != null) callbackAction(retValue);
  }
}

class SimpleAlert extends StatelessWidget {
  final String bodyText;
  final int dialogButtonChoice;
  final Function(int retValue) onCB;
  SimpleAlert(this.bodyText, this.dialogButtonChoice, this.onCB);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PopupContainerBar(
            title: "alert_generic",
            iconData: Icons.announcement_sharp,
            onClose: () => onCB(AlertChoices.CANCEL),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Text(
              bodyText,
              style: TextStyle(fontSize: 13, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (dialogButtonChoice == AlertChoices.OK || dialogButtonChoice == AlertChoices.OK_CANCEL)
                    ? RaisedButton(
                        onPressed: () {
                          onCB(AlertChoices.OK);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.check, size: 20, color: Colors.green)),
                            Text(
                              AppLocalizations.of(context).translate("ok"),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                dialogButtonChoice == AlertChoices.OK_CANCEL ? Spacer() : Container(),
                (dialogButtonChoice == AlertChoices.CANCEL || dialogButtonChoice == AlertChoices.OK_CANCEL)
                    ? RaisedButton(
                        onPressed: () {
                          onCB(AlertChoices.CANCEL);
                        },
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.close, size: 20, color: Colors.redAccent)),
                            Text(
                              AppLocalizations.of(context).translate("cancel"),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PromptAlert extends StatefulWidget {
  final Function(dynamic retValue) onCB;
  final String title;
  PromptAlert(this.title, this.onCB);

  @override
  _PromptAlertState createState() => _PromptAlertState();
}

class _PromptAlertState extends State<PromptAlert> {
  TextEditingController _promptController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PopupContainerBar(
            title: "alert_generic",
            iconData: Icons.announcement_sharp,
            onClose: () => widget.onCB(AlertChoices.CANCEL),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 13, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    height: 30,
                    child: TextFormField(
                      controller: _promptController,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () {
                    widget.onCB(_promptController.text);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.check, size: 20, color: Colors.green)),
                      Text(
                        AppLocalizations.of(context).translate("ok"),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    widget.onCB(AlertChoices.CANCEL);
                  },
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.close, size: 20, color: Colors.redAccent)),
                      Text(
                        AppLocalizations.of(context).translate("cancel"),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
}
