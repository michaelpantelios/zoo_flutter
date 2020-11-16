import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/widgets/z_text_field.dart';

class MyAccountSettingsScreen extends StatefulWidget {
  MyAccountSettingsScreen({Key key, this.mySize});

  final Size mySize;

  MyAccountSettingsScreenState createState() =>
      MyAccountSettingsScreenState(key: key);
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

  onChangePassword() {}

  onChangeMail() {}

  onDeleteAccount() {}

  @override
  void initState() {
    changePasswordButtonKey = new GlobalKey<ZButtonState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).canvasColor,
        width: widget.mySize.width,
        height: widget.mySize.height - 5,
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                AppLocalizations.of(context)
                    .translate("app_settings_lblAccountSettingsTitle"),
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.left),
            Padding(
                padding: EdgeInsets.all(5),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                  thickness: 1,
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                  AppLocalizations.of(context)
                      .translate("app_settings_lblAccountSettingsInfo"),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                  AppLocalizations.of(context)
                      .translate("app_settings_lblPasswordChange"),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                height: 60,
                child: Row(
                  children: [
                    zTextField(
                        context,
                        110,
                        oldPasswordController,
                        oldPasswordNode,
                        AppLocalizations.of(context)
                            .translate("app_settings_lblOldPassword")),
                    zTextField(
                        context,
                        110,
                        newPassowrdController,
                        newPassowrdNode,
                        AppLocalizations.of(context)
                            .translate("app_settings_lblNewPassword")),
                    zTextField(
                        context,
                        110,
                        newPasswordAgainController,
                        newPasswordAgainNode,
                        AppLocalizations.of(context)
                            .translate("app_settings_lblNewPassword2")),
                    Container(
                        width: 100,
                        child: ZButton(
                            key: changePasswordButtonKey,
                            buttonColor: Colors.white,
                            label: AppLocalizations.of(context)
                                .translate("app_settings_btnChange"),
                            clickHandler: onChangePassword))
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                  AppLocalizations.of(context)
                      .translate("app_settings_lblEmailChange"),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                height: 60,
                child: Row(
                  children: [
                    zTextField(
                        context,
                        110,
                        mailPasswordController,
                        mailPasswordNode,
                        AppLocalizations.of(context)
                            .translate("app_settings_lblPassword")),
                    zTextField(
                        context,
                        110,
                        newMailController,
                        newMailNode,
                        AppLocalizations.of(context)
                            .translate("app_settings_lblNewEmail")),
                    zTextField(
                        context,
                        110,
                        newMailAgainController,
                        newMailAgainNode,
                        AppLocalizations.of(context)
                            .translate("app_settings_lblNewEmail2")),
                    Container(
                        width: 100,
                        child: ZButton(
                            key: changeMailButtonKey,
                            buttonColor: Colors.white,
                            label: AppLocalizations.of(context)
                                .translate("app_settings_btnChange"),
                            clickHandler: onChangeMail))
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                  AppLocalizations.of(context)
                      .translate("app_settings_lblAccountDelete"),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left),
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
                              AppLocalizations.of(context)
                                  .translate("app_settings_chkDeleteAccount"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.left,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ))
                    ),
                    Container(
                        width: 100,
                        child: ZButton(
                            key: deleteAccountButtonKey,
                            buttonColor: Colors.white,
                            label: AppLocalizations.of(context)
                                .translate("app_settings_btnDelete"),
                            clickHandler: onDeleteAccount))
                  ],
                ))
          ],
        ));
  }
}
