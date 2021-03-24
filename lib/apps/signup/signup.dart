import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/js/zoo_lib.dart';

class Signup extends StatefulWidget{
  Signup({this.onClose, this.size, this.setBusy});

  final Function(bool value) setBusy;
  final Function(dynamic retValue) onClose;
  final Size size;

  SignupState createState() => SignupState();
}

class SignupState extends State<Signup>{
  SignupState();

  onZooSignup(BuildContext context) async {
    await PopupManager.instance.show(context: context, popup: PopupType.SignupZoo, callbackAction: (e) {});
    widget.onClose(null);
  }

  onFbConnect(BuildContext context) async {
    widget.setBusy(true);

    var res = await Zoo.fbLogin();

    print(res);

    // TODO: add translation for "app_login_blocked" (blocked popup)
    if (res["status"] != "ok") {
      print("login error: "+res["status"]);
      widget.setBusy(false);
      String bodyText = AppLocalizations.of(context).translate("app_login_${res["status"]}");
      if (bodyText == null) bodyText = AppLocalizations.of(context).translate("app_coins_error");
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: bodyText,
      );
      return;
    }

    widget.setBusy(false);
    await PopupManager.instance.show(context: context, popup: PopupType.FacebookLinker, callbackAction: (e) {});
    widget.onClose(null);
  }



    @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: widget.size.width+25,
              height: widget.size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.centerLeft,
                      image: AssetImage("assets/images/signup/bg.png"), fit: BoxFit.fitHeight)),
              child:
              Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 20
                    ),
                    Container(
                      width: 500,
                      alignment: Alignment.centerLeft,
                      child:  Text(AppLocalizations.of(context).translate("app_signup_first_screen_title"),
                          style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left),
                    ),
                    SizedBox(
                        height: 50
                    ),
                    ZButton(
                        clickHandler: () =>{ onZooSignup(context) },
                        buttonColor: Theme.of(context).buttonColor,
                        label: AppLocalizations.of(context).translate("app_signup_first_screen_btnSignupZoo"),
                        labelStyle: Theme.of(context).textTheme.button,
                        minWidth: 500,
                        height: 60
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical:5),
                        child: Text(AppLocalizations.of(context).translate("app_signup_first_screen_or"),
                            style: Theme.of(context).textTheme.headline3)
                    ),
                    ZButton(
                        clickHandler:() => { onFbConnect(context) },
                        buttonColor: Colors.white,
                        iconPath: "assets/images/signup/fb_blue.png",
                        iconSize: 25,
                        hasBorder: true,
                        borderColor: Color(0xff4485d3),
                        borderWidth: 2,
                        label: AppLocalizations.of(context).translate("app_signup_first_screen_btnFbConnect"),
                        labelStyle: TextStyle(color: Color(0xff4485d3), fontSize: 16.0, fontWeight: FontWeight.normal,
                            fontFamily: 'CeraPro'),
                        minWidth: 500,
                        height: 60
                    ),
                    SizedBox(
                        height: 50
                    ),
                  ],
                ),
              )
          )
        ],
      );
    }


}