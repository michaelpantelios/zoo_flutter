import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class LoginFacebook extends StatelessWidget {
  LoginFacebook({Key key, @required this.onFBLogin, @required this.onSignUp});

  final Function onFBLogin;
  final Function onSignUp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 150,
            child: Text(
              AppLocalizations.of(context).translate("app_login_mode_facebook_promo"),
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF9598a4),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: onSignUp,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  AppLocalizations.of(context).translate("app_login_mode_zoo_create_new_account"),
                  style: TextStyle(
                    color: Color(0xff64abff),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 115, right: 20),
            child: Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: onFBLogin,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 230,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff63ABFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate("app_login_mode_facebook_btn_login"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
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
    );
  }
}
