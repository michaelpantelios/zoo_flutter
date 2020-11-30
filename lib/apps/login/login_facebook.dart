import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class LoginFacebook extends StatelessWidget {
  LoginFacebook({Key key, @required this.onFBLogin});

  final Function onFBLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 150,
            child: Text(
              AppLocalizations.of(context).translate("app_login_mode_facebook_promo"),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            )),
        Container(
            margin: EdgeInsets.only(top: 10, bottom: 15),
            child: RaisedButton(
                onPressed: () {
                  onFBLogin();
                },
                child: Text(
                  AppLocalizations.of(context).translate("app_login_mode_facebook_btn_login"),
                  style: Theme.of(context).textTheme.bodyText2,
                )))
      ],
    );
  }
}
