import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class SMSActivation extends StatefulWidget {
  final Size size;
  final Function(bool value) setBusy;
  SMSActivation({@required this.size, this.setBusy});

  SMSActivationState createState() => SMSActivationState();
}

class SMSActivationState extends State<SMSActivation> {
  SMSActivationState();

  RPC _rpc;

  FocusNode _firstStepFocusNode = FocusNode();
  TextEditingController _firstStepController = TextEditingController();

  FocusNode _secondStepFocusNode = FocusNode();
  TextEditingController _secondStepController = TextEditingController();

  @override
  void initState() {
    _rpc = RPC();

    super.initState();
  }

  _firstStepSubmit() async {
    print("first step submit : ${_firstStepController.text}");
    var res = await _rpc.callMethod("Alerts.Phone.activatePhone", [_firstStepController.text]);
    print(res);
    if (res["status"] == "ok") {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("sms_ok"),
      );
    } else {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("sms_code_${res["errorMsg"]}"),
      );
    }
  }

  _secondStepSubmit() async {
    print("second step submit : ${_secondStepController.text}");
    var res = await _rpc.callMethod("Alerts.Phone.sendActivationCode", [_secondStepController.text]);
    print(res);
    if (res["status"] == "ok") {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("sms_code_ok"),
      );
    } else {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("sms_${res["errorMsg"]}"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              AppLocalizations.of(context).translate("sms_lblLabel"),
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Html(
            data: """ 
            <span>${AppLocalizations.of(context).translate("sms_txtBody").replaceAll('_domain_', 'Zoo.gr')}</span> 
          """,
            style: {
              "span": Style(color: Colors.black, fontSize: FontSize.medium),
            },
          ),
          Padding(
            child: Text(AppLocalizations.of(context).translate("sms_lblStep1"), style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
            padding: EdgeInsets.only(top: 15),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).translate("sms_lblPhoneNumber"), style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: 25,
                    width: 120,
                    child: TextField(
                      focusNode: _firstStepFocusNode,
                      controller: _firstStepController,
                      onSubmitted: (e) => _firstStepSubmit(),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      _firstStepSubmit();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            AppLocalizations.of(context).translate("sms_btnSendNumber"),
                            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 15),
          ),
          Padding(
            child: Text(AppLocalizations.of(context).translate("sms_lblStep2"), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
            padding: EdgeInsets.only(top: 15),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).translate("sms_lblCode"), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                    height: 25,
                    width: 100,
                    child: TextField(
                      focusNode: _secondStepFocusNode,
                      controller: _secondStepController,
                      onSubmitted: (e) => _secondStepSubmit(),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      _secondStepSubmit();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            AppLocalizations.of(context).translate("sms_btnSendCode"),
                            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 15),
          ),
        ],
      ),
    );
  }
}
