import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
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
    if ((AppProvider.instance.currentAppInfo.id == AppType.Multigames || AppProvider.instance.currentAppInfo.id == AppType.SinglePlayerGames) && !AppProvider.instance.popupOverIFrameExists) {
      AppProvider.instance.popupOverIFrameExists = true;
    }
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
      transitionDuration: Duration(milliseconds: 0),
      useRootNavigator: true,
    );
  }

  Future<dynamic> showPromptAlert({@required context, @required title, @required OnCallbackAction callbackAction}) async {
    if ((AppProvider.instance.currentAppInfo.id == AppType.Multigames || AppProvider.instance.currentAppInfo.id == AppType.SinglePlayerGames) && !AppProvider.instance.popupOverIFrameExists) {
      AppProvider.instance.popupOverIFrameExists = true;
    }
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
      transitionDuration: Duration(milliseconds: 0),
      useRootNavigator: true,
    );
  }

  _closeAlert(OnCallbackAction callbackAction, BuildContext context, dynamic retValue) {
    print("close alert, retValue: $retValue");
    if (AppProvider.instance.popupOverIFrameExists) AppProvider.instance.popupOverIFrameExists = false;
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
            iconData: Icons.warning,
            onClose: () => onCB(
              AlertChoices.CANCEL,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            child: Html(
              data: """$bodyText""",
              style: {
                "html": Style(
                  textAlign: TextAlign.center,
                  color: Color(0xff393e54),
                  fontSize: FontSize(15.0),
                  fontWeight: FontWeight.w500,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (dialogButtonChoice == AlertChoices.OK || dialogButtonChoice == AlertChoices.OK_CANCEL)
                    ? GestureDetector(
                        onTap: () => onCB(AlertChoices.OK),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 100,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Color(0xff63ABFF),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    width: 73,
                                    child: Text(
                                      AppLocalizations.of(context).translate("ok"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Container(
                                    width: 17,
                                    height: 17,
                                    child: Image.asset(
                                      "assets/images/general/ok_btn_icon.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                dialogButtonChoice == AlertChoices.OK_CANCEL ? Spacer() : Container(),
                (dialogButtonChoice == AlertChoices.CANCEL || dialogButtonChoice == AlertChoices.OK_CANCEL)
                    ? GestureDetector(
                        onTap: () => onCB(AlertChoices.CANCEL),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 100,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Color(0xffdc5b42),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    width: 73,
                                    child: Text(
                                      AppLocalizations.of(context).translate("cancel"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Container(
                                    width: 17,
                                    height: 17,
                                    child: Image.asset(
                                      "assets/images/general/cancel_btn_icon.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
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

getFieldsInputDecoration() {
  return InputDecoration(
    fillColor: Color(0xffffffff),
    filled: false,
    enabledBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
    errorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
    focusedBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
    focusedErrorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
    contentPadding: EdgeInsets.symmetric(horizontal: 5),
  );
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
                Html(
                  data: """${widget.title}""",
                  style: {
                    "html": Style(textAlign: TextAlign.left, color: Colors.black, fontSize: FontSize.medium),
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    height: 30,
                    child: TextFormField(
                      controller: _promptController,
                      decoration: getFieldsInputDecoration(),
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
                GestureDetector(
                  onTap: () => widget.onCB(AlertChoices.CANCEL),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 100,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(0xffdc5b42),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              width: 73,
                              child: Text(
                                AppLocalizations.of(context).translate("cancel"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Container(
                              width: 17,
                              height: 17,
                              child: Image.asset(
                                "assets/images/general/cancel_btn_icon.png",
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.onCB(_promptController.text),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 100,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(0xff63ABFF),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              width: 73,
                              child: Text(
                                AppLocalizations.of(context).translate("ok"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Container(
                              width: 17,
                              height: 17,
                              child: Image.asset(
                                "assets/images/general/ok_btn_icon.png",
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
