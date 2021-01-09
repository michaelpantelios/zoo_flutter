import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';

class MyAccountSettingsScreen extends StatefulWidget {
  final Function(bool value) setBusy;
  MyAccountSettingsScreen({Key key, this.mySize, this.setBusy});

  final Size mySize;

  MyAccountSettingsScreenState createState() => MyAccountSettingsScreenState(key: key);
}

class MyAccountSettingsScreenState extends State<MyAccountSettingsScreen> {
  MyAccountSettingsScreenState({Key key});

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPassowrdController = TextEditingController();
  TextEditingController newPasswordAgainController = TextEditingController();

  TextEditingController mailPasswordController = TextEditingController();
  TextEditingController newMailController = TextEditingController();
  TextEditingController newMailAgainController = TextEditingController();

  FocusNode oldPasswordNode = FocusNode();
  FocusNode newPassowrdNode = FocusNode();
  FocusNode newPasswordAgainNode = FocusNode();

  FocusNode mailPasswordNode = FocusNode();
  FocusNode newMailNode = FocusNode();
  FocusNode newMailAgainNode = FocusNode();

  GlobalKey<ZButtonState> changePasswordButtonKey;
  GlobalKey<ZButtonState> changeMailButtonKey;
  GlobalKey<ZButtonState> deleteAccountButtonKey;

  bool deleteMyAccount = false;
  RPC _rpc;

  @override
  void initState() {
    _rpc = RPC();
    changePasswordButtonKey = new GlobalKey<ZButtonState>();
    super.initState();
  }

  onChangePassword() async {
    if (oldPasswordController.text == "") {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertNoOldPass"));
    } else if (newPassowrdController.text != newPasswordAgainController.text) {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertPassNoMatch"));
    } else {
      var data = new Map<String, String>();
      data["oldPassword"] = oldPasswordController.text;
      data["newPassword"] = newPassowrdController.text;

      widget.setBusy(true);
      var res = await _rpc.callMethod('OldApps.User.changePassword', data);
      widget.setBusy(false);
      print(res);
      if (res["status"] == "ok") {
        oldPasswordController.clear();
        newPassowrdController.clear();
        newPasswordAgainController.clear();
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertPassOk"));
      } else if (res["errorMsg"] == "invalid_oldpassword") {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertOldPassError"));
      } else if (res["errorMsg"] == "invalid_newpassword") {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertNewPassError"));
      } else {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("${res["status"]}"));
      }
    }
  }

  onChangeMail() async {
    if (mailPasswordController.text == "") {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertMailNoPass"));
    } else if (newMailController.text != newMailAgainController.text) {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertMailNoMatch"));
    } else {
      var data = new Map<String, String>();
      data["password"] = mailPasswordController.text;
      data["email"] = newMailController.text;

      widget.setBusy(true);
      var res = await _rpc.callMethod('Zoo.Account.changeEmail', [data]);
      widget.setBusy(false);
      print(res);
      if (res["status"] == "ok") {
        mailPasswordController.clear();
        newMailController.clear();
        newMailAgainController.clear();
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertMailOk"));
      } else if (res["errorMsg"] == "invalid_password") {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertMailPassError"));
      } else if (res["errorMsg"] == "invalid_email") {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertNewMailError"));
      } else {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("${res["status"]}"));
      }
    }
  }

  onDeleteAccount() {
    if (!deleteMyAccount) {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertDeleteTerms"));
    } else {
      AlertManager.instance.showPromptAlert(context: context, title: AppLocalizations.of(context).translate("app_settings_alertVerifyDelete"), callbackAction: (retValue) => _onDeleteConfirm(retValue));
    }
  }

  _onDeleteConfirm(retValue) async {
    print("delete ${retValue}");
    if (retValue != 2) {
      widget.setBusy(true);
      var res = await _rpc.callMethod('OldApps.User.deleteUser', retValue);
      widget.setBusy(false);
      print(res);
      if (res["status"] == "ok") {
        UserProvider.instance.logout();
      } else if (res["errorMsg"] == "permanent_sub") {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertPermanent_sub"));
      } else if (res["errorMsg"] == "invalid_password") {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertAccountDeleteError"));
      } else {
        AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate(res["status"]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFffffff),
        width: widget.mySize.width,
        height: widget.mySize.height - 5,
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context).translate("app_settings_lblAccountSettingsTitle"), style: TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(AppLocalizations.of(context).translate("app_settings_lblAccountSettingsInfo"), style: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(AppLocalizations.of(context).translate("app_settings_lblPasswordChange"), style: TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    zTextField(context, 110, oldPasswordController, oldPasswordNode, AppLocalizations.of(context).translate("app_settings_lblOldPassword"), obscureText: true),
                    zTextField(context, 110, newPassowrdController, newPassowrdNode, AppLocalizations.of(context).translate("app_settings_lblNewPassword"), obscureText: true),
                    zTextField(context, 110, newPasswordAgainController, newPasswordAgainNode, AppLocalizations.of(context).translate("app_settings_lblNewPassword2"), obscureText: true),
                    Container(width: 100, child: ZButton(key: changePasswordButtonKey, buttonColor: Colors.white, label: AppLocalizations.of(context).translate("app_settings_btnChange"), clickHandler: onChangePassword))
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(AppLocalizations.of(context).translate("app_settings_lblEmailChange"), style: TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    zTextField(context, 110, mailPasswordController, mailPasswordNode, AppLocalizations.of(context).translate("app_settings_lblPassword"), obscureText: true),
                    zTextField(context, 110, newMailController, newMailNode, AppLocalizations.of(context).translate("app_settings_lblNewEmail")),
                    zTextField(context, 110, newMailAgainController, newMailAgainNode, AppLocalizations.of(context).translate("app_settings_lblNewEmail2")),
                    Container(width: 100, child: ZButton(key: changeMailButtonKey, buttonColor: Colors.white, label: AppLocalizations.of(context).translate("app_settings_btnChange"), clickHandler: onChangeMail))
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(AppLocalizations.of(context).translate("app_settings_lblAccountDelete"), style: TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            //width: 220,
                            child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      onChanged: (value) {
                        setState(() {
                          deleteMyAccount = value;
                        });
                      },
                      value: deleteMyAccount,
                      selected: deleteMyAccount,
                      title: Text(
                        AppLocalizations.of(context).translate("app_settings_chkDeleteAccount"),
                        style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.left,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ))),
                    Container(width: 100, child: ZButton(key: deleteAccountButtonKey, buttonColor: Colors.white, label: AppLocalizations.of(context).translate("app_settings_btnDelete"), clickHandler: onDeleteAccount))
                  ],
                ))
          ],
        ));
  }
}
