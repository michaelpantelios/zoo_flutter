import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

class HomeModuleNewSignup extends StatelessWidget {
  HomeModuleNewSignup();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        // border: Border.all(color: Colors.deepOrange, width: 3),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getModuleHeader(AppLocalizations.of(context).translate("app_home_module_title_new_signup")),
          Container(
            height: 240,
            padding: EdgeInsets.only(left: 0, right: 0, bottom: 5),
            child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9.0),
                      child: Image.asset("assets/images/home/new_signup.png", fit: BoxFit.fitWidth),
                    )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).translate("app_home_module_new_signup_prompt"),
                          style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(bottom: 10),
                        child: ZButton(
                          hasBorder: false,
                          height: 50,
                          minWidth: 200,
                          buttonColor: Color(0xff63ABFF),
                          clickHandler: () {
                            PopupManager.instance.show(context: context, popup: PopupType.Signup);
                          },
                          label : AppLocalizations.of(context).translate("app_home_module_new_signup_button"),
                          labelStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  )
                ],
              )
          )
        ],
      )
    );
  }
  

  
}

