import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class MailNew extends StatefulWidget {
  MailNew({Key key, this.parentSize, this.parent, this.username, @required this.onClose, this.size, this.setBusy});

  final Size parentSize;
  final dynamic parent;
  final String username;
  final Size size;
  final Function(bool value) setBusy;
  final Function onClose;

  _MailNewState createState() => _MailNewState();
}

class _MailNewState extends State<MailNew> {
  _MailNewState({Key key});

  RPC _rpc;

  TextEditingController _toUserTextController = TextEditingController();
  TextEditingController _subjectTextController = TextEditingController();
  TextEditingController _bodyTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rpc = RPC();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _toUserTextController.text = widget.username != null ? widget.username : "";

    _subjectTextController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    _toUserTextController.dispose();
    _subjectTextController.dispose();
    _bodyTextController.dispose();
  }

  _send() async {
    if (_toUserTextController.text == "zoo") {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("mail_reserved").replaceAll('_domain_', 'Zoo.gr'),
        dialogButtonChoice: AlertChoices.OK,
      );
      return;
    }
    _checkAccess(to: _toUserTextController.text, replyTo: null);
  }

  _checkAccess({String to, int replyTo}) async {
    print("check mail access");
    var data = {"to": to, "replyTo": replyTo};
    var res = await _rpc.callMethod("Mail.Main.checkAccess", [data]);
    print(res);
    if (res["status"] == "ok") {
      if (res["data"]["coins"] == 0 || res["data"]["coins"] == null) {
        _sendMail();
      } else {
        PopupManager.instance.show(context: context, options: CostTypes.mailNew, popup: PopupType.Protector, callbackAction: (retVal) => {if (retVal == "ok") _sendMail()});
      }
    } else {
      AlertManager.instance.showSimpleAlert(
          context: context,
          bodyText: AppLocalizations.of(context).translate("mail_${res["errorMsg"]}"),
          dialogButtonChoice: AlertChoices.OK,
          callbackAction: (retValue) {
            if (retValue == 1 && res["errorMsg"] == "no_coins") {
              PopupManager.instance.show(context: context, popup: PopupType.Coins, callbackAction: (r) {});
            }
          });
    }
  }

  _sendMail() async {
    var data = {
      "to": _toUserTextController.text,
      "subject": _subjectTextController.text,
      "body": _bodyTextController.text,
    };
    var res = await _rpc.callMethod("Mail.Main.newMessage", [data]);
    print(res);
    if (res["status"] == "ok") {
      AlertManager.instance.showSimpleAlert(
          context: context,
          bodyText: AppLocalizations.of(context).translate("mail_mailSend"),
          dialogButtonChoice: AlertChoices.OK,
          callbackAction: (r) {
            widget.onClose(null);
          });
    } else {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("mail_${res["errorMsg"]}"),
        dialogButtonChoice: AlertChoices.OK,
      );
    }
  }

  getFieldsInputDecoration({double verticalPadding}) {
    var paddingV = verticalPadding != null ? verticalPadding : 0;
    return InputDecoration(
      fillColor: Color(0xffffffff),
      filled: false,
      enabledBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      errorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      focusedBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      focusedErrorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: paddingV),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "${AppLocalizations.of(context).translate("mail_to")}:",
                      style: TextStyle(
                        color: Color(0xff393e54),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: EdgeInsets.only(bottom: 5),
                    child: TextField(
                      controller: _toUserTextController,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                      decoration: getFieldsInputDecoration(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "${AppLocalizations.of(context).translate("mail_editorSubject")}",
                        style: TextStyle(
                          color: Color(0xff393e54),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      child: TextField(
                        controller: _subjectTextController,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        decoration: getFieldsInputDecoration(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "${AppLocalizations.of(context).translate("mail_mainBody")}",
                        style: TextStyle(
                          color: Color(0xff393e54),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: TextField(
                            minLines: 5,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            controller: _bodyTextController,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                            decoration: getFieldsInputDecoration(verticalPadding: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: GestureDetector(
              onTap: () {
                print("send message");
                _send();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 110,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(0xff3c8d40),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context).translate("mail_btnSendMail"),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            "assets/images/mail/mail_outbox.png",
                            color: Color(0xffffffff),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
