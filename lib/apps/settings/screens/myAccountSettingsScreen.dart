import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

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

  getFieldsInputDecoration({double verticalPadding}) {
    double paddingV = verticalPadding == null ? 7 : verticalPadding;
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
    return Container(
      color: Color(0xFFffffff),
      width: widget.mySize.width,
      height: widget.mySize.height - 5,
      padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context).translate("app_settings_lblPasswordChange"),
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xff393e54),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  AppLocalizations.of(context).translate("app_settings_lblOldPassword"),
                  style: TextStyle(
                    color: Color(0xff9598a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 35,
                child: TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.left,
                  obscuringCharacter: "*",
                  controller: oldPasswordController,
                  focusNode: oldPasswordNode,
                  decoration: getFieldsInputDecoration(verticalPadding: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  AppLocalizations.of(context).translate("app_settings_lblNewPassword"),
                  style: TextStyle(
                    color: Color(0xff9598a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 35,
                child: TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.left,
                  obscuringCharacter: "*",
                  controller: newPassowrdController,
                  focusNode: newPassowrdNode,
                  decoration: getFieldsInputDecoration(verticalPadding: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  AppLocalizations.of(context).translate("app_settings_lblNewPassword2"),
                  style: TextStyle(
                    color: Color(0xff9598a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 35,
                child: TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.left,
                  obscuringCharacter: "*",
                  controller: newPasswordAgainController,
                  focusNode: newPasswordAgainNode,
                  decoration: getFieldsInputDecoration(verticalPadding: 20),
                ),
              ),
              // Container(width: 100, child: ZButton(key: changePasswordButtonKey, buttonColor: Colors.white, label: AppLocalizations.of(context).translate("app_settings_btnChange"), clickHandler: onChangePassword))
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 5),
                child: Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: onChangePassword,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: 130,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0xff3c8d40),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate("app_settings_btnChange"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context).translate("app_settings_lblEmailChange"),
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xff393e54),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  AppLocalizations.of(context).translate("app_settings_lblPassword"),
                  style: TextStyle(
                    color: Color(0xff9598a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 35,
                child: TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.left,
                  obscuringCharacter: "*",
                  controller: mailPasswordController,
                  focusNode: mailPasswordNode,
                  decoration: getFieldsInputDecoration(verticalPadding: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  AppLocalizations.of(context).translate("app_settings_lblNewEmail"),
                  style: TextStyle(
                    color: Color(0xff9598a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 35,
                child: TextFormField(
                  textAlign: TextAlign.left,
                  controller: newMailController,
                  focusNode: newMailNode,
                  decoration: getFieldsInputDecoration(verticalPadding: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  AppLocalizations.of(context).translate("app_settings_lblNewEmail2"),
                  style: TextStyle(
                    color: Color(0xff9598a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 35,
                child: TextFormField(
                  textAlign: TextAlign.left,
                  controller: newMailAgainController,
                  focusNode: newMailAgainNode,
                  decoration: getFieldsInputDecoration(verticalPadding: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 5),
                child: Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: onChangeMail,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: 130,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0xff3c8d40),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate("app_settings_btnChange"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              AppLocalizations.of(context).translate("app_settings_lblAccountDelete"),
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xff393e54),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CheckboxListTile(
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
                    style: TextStyle(
                      color: Color(0xff9598a4),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 5),
                  child: Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: onDeleteAccount,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 130,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color(0xffdc5b42),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).translate("app_settings_btnDelete"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
