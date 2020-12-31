import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

class Contact extends StatefulWidget{
  Contact({this.size, this.onClose, this.setBusy});

  final Size size;
  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;

  ContactState createState() => ContactState();
}

class ContactState extends State<Contact>{
  ContactState();

  RPC _rpc;

  Size _size = PopupManager.instance.getPopUpInfo(PopupType.Contact).size;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();


  @override
  void initState() {
    _rpc = RPC();
    super.initState();
  }

  _onSend(BuildContext context) async {
    if (_emailController.text.length < 3 || !_emailController.text.contains("@")){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_contact_no_valid_mail"));
      return;
    }

    if (_subjectController.text.length == 0 ){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_contact_no_subject"));
      return;
    }

    if (_bodyController.text.length == 0 ){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_contact_no_body"));
      return;
    }
    widget.setBusy(true);
    var data = {
      "from" : _emailController.text,
      "to" : "support@zoo.gr",
      "subject" : AppLocalizations.of(context).translate("app_contact_feedBack") + " - " + _subjectController.text + " - "  + UserProvider.instance.userInfo.username,
      "body" : _bodyController.text
    };

    print(data);

    _doSend(context, data);
  }

  _doSend(BuildContext context, var data) async {
    // ok:               success
    // invalid_[field]:  [field] is not valid
    // denied:           the recipients address is not in the zoo.gr domain
    // error:
        
    var res = await _rpc.callMethod('OldApps.Misc.sendMail', data);

    widget.setBusy(false);
    if( res["status"] == "ok" ){
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_contact_success"));
      _emailController.clear();
      _subjectController.clear();
      _bodyController.clear();
    } else {
      print("error");
      print(res);
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_contact_error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).translate("app_contact_header"),
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.left
          ),
          Expanded(child: Container()),
          Text(AppLocalizations.of(context).translate("app_contact_email"),
              style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.left),
          Container(
              padding: EdgeInsets.all(5),
              width: widget.size.width - 20,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              alignment: Alignment.centerLeft,
              child:  TextFormField(
                decoration: InputDecoration.collapsed(
                  hintText: "",
                  border: InputBorder.none,
                ),
                controller: _emailController,
              )
          ),
          Expanded(child: Container()),
          Text(AppLocalizations.of(context).translate("app_contact_subject"),
              style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.left),
          Container(
              padding: EdgeInsets.all(5),
              width: widget.size.width - 20,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              alignment: Alignment.centerLeft,
              child:  TextFormField(
                decoration: InputDecoration.collapsed(
                  hintText: "",
                  border: InputBorder.none,
                ),
                controller: _subjectController,
              )
          ),
          Expanded(child: Container()),
          Text(AppLocalizations.of(context).translate("app_contact_body"),
          style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.left),
          Container(
            padding: EdgeInsets.all(5),
            width: widget.size.width - 20,
            height: 150,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
            alignment: Alignment.centerLeft,
            child:  TextFormField(
              decoration: InputDecoration.collapsed(
                hintText: "",
                border: InputBorder.none,
              ),
              minLines: 10,
              maxLines: 15,
              controller: _bodyController,
            )
          ),
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ZButton(
                minWidth: 200,
                height: 40,
                iconData: Icons.send,
                iconColor: Colors.white,
                iconSize: 30,
                iconPosition: ZButtonIconPosition.right,
                buttonColor: Theme.of(context).buttonColor,
                label:  AppLocalizations.of(context).translate("app_contact_send"),
                labelStyle: Theme.of(context).textTheme.button,
                clickHandler:()=>{ _onSend(context) },
              )
            ],
          )
        ],
      )
    );
  }


}

