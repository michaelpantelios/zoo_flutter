import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/models/mail/mail_message_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class MailNewReply extends StatefulWidget {
  MailNewReply({Key key, this.parentSize, this.username, this.parent, this.mailMessageInfo, @required this.onClose, this.size, this.setBusy});

  final Size parentSize;
  final dynamic parent;
  final MailMessageInfo mailMessageInfo;
  final String username;
  final Size size;
  final Function(bool value) setBusy;
  final Function onClose;

  MailNewReplyState createState() => MailNewReplyState();
}

class MailNewReplyState extends State<MailNewReply> {
  MailNewReplyState({Key key});

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

    _toUserTextController.text = widget.mailMessageInfo == null
        ? widget.username != null
            ? widget.username
            : ""
        : widget.mailMessageInfo.from.username;
    _subjectTextController.text = widget.mailMessageInfo == null ? "" : "re: ${widget.mailMessageInfo.subject}";
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
    var data;
    if (widget.mailMessageInfo == null) {
      data = {
        "to": _toUserTextController.text,
        "subject": _subjectTextController.text,
        "body": _bodyTextController.text,
      };
    } else {
      data = {
        "replyTo": widget.mailMessageInfo == null ? null : widget.mailMessageInfo.from.userId,
        "subject": _subjectTextController.text,
        "body": _bodyTextController.text,
      };
    }
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

  String _parseHtmlString(String htmlString) {
    String input = htmlString;
    input = input.replaceAll('<TEXTFORMAT LEADING="2">', "").replaceAll("</TEXTFORMAT>", "");
    return input;
  }

  static getGiftPath(String id) {
    var str = window.location.toString().split('?')[0] + "assets/assets/images/gifts/$id-icon.png";
    print(str);
    return str;
  }

  _normalizeSelectedBody() {
    if (widget.mailMessageInfo == null) return "";
    var str = "";
    if (widget.mailMessageInfo.type == "gift") {
      str = "<img src=${getGiftPath(widget.mailMessageInfo.body['id'].toString())}></img>";
      str += _parseHtmlString(widget.mailMessageInfo.body["msg"]);
    } else {
      str = _parseHtmlString(widget.mailMessageInfo.body);
    }

    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: widget.parentSize != null ? widget.parentSize.width * 0.5 : widget.size.width,
      height: widget.parentSize != null ? (widget.parentSize.height * (widget.mailMessageInfo == null ? 0.4 : 0.7)) : widget.size.height,
      decoration: widget.parentSize != null
          ? BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black45,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 3,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ],
            )
          : BoxDecoration(),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        widget.parentSize != null ? PopupContainerBar(title: widget.mailMessageInfo == null ? "mail_btnNew" : "mail_btnReply", iconData: Icons.notes, onClose: () => {widget.onClose(null)}) : Container(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 5),
                    child: Text(
                      "${AppLocalizations.of(context).translate("mail_to")}:",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  Container(
                    width: 480,
                    height: 25,
                    margin: EdgeInsets.only(bottom: 5),
                    child: TextField(
                      controller: _toUserTextController,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 5),
                    child: Text(
                      "${AppLocalizations.of(context).translate("mail_editorSubject")}",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  Container(
                    width: 480,
                    height: 25,
                    margin: EdgeInsets.only(bottom: 5),
                    child: TextField(
                      controller: _subjectTextController,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0, bottom: 5, top: 10),
                  child: Text(
                    "${AppLocalizations.of(context).translate("mail_mainBody")}",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Container(
                        width: 475,
                        margin: EdgeInsets.only(bottom: 5),
                        child: TextField(
                          minLines: 10,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          controller: _bodyTextController,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5.0),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.mailMessageInfo == null
                ? Container()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 0, bottom: 0, top: 15, left: 10),
                        child: Text(
                          "${AppLocalizations.of(context).translate("mail_initialMessage")}:",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Container(
                              width: 525,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border(
                                  right: BorderSide(color: Colors.blueGrey, width: 1),
                                  top: BorderSide(color: Colors.blueGrey, width: 1),
                                  bottom: BorderSide(color: Colors.blueGrey, width: 1),
                                  left: BorderSide(color: Colors.blueGrey, width: 1),
                                ),
                              ),
                              margin: EdgeInsets.only(bottom: 5),
                              child: SizedBox(
                                height: 220,
                                child: SingleChildScrollView(
                                  child: HtmlWidget(
                                    _normalizeSelectedBody(),
                                    textStyle: TextStyle(color: Colors.black),
                                    onTapUrl: (value) async {
                                      if (await canLaunch(value)) {
                                        await launch(value);
                                      } else {
                                        throw 'Could not launch $value';
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 0),
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        print("send message");
                        _send();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            child: Image.asset("assets/images/mail/mail_send.png"),
                          ),
                          Text(
                            AppLocalizations.of(context).translate("mail_btnSendMail"),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
