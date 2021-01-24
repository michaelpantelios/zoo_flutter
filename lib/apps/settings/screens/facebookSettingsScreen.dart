import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/js/zoo_lib.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/models/login/login_user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class FBLinkedInfo {
  final String id;
  final String name;
  final String pic_small;
  FBLinkedInfo({this.id, this.name, this.pic_small});
}

class FacebookSettingsScreen extends StatefulWidget {
  FacebookSettingsScreen({Key key, this.mySize, this.setBusy});

  final Size mySize;
  final Function(bool value) setBusy;

  FacebookSettingsScreenState createState() => FacebookSettingsScreenState(key: key);
}

class FacebookSettingsScreenState extends State<FacebookSettingsScreen> {
  FacebookSettingsScreenState({Key key});

  FBLinkedInfo _linkedInfo;
  bool _linkedInfoFetched = false;
  String _fbName = "";
  RPC _rpc;

  buttonHandler() async {
    var res;
    if (_linkedInfo != null) {
      res = await _rpc.callMethod("Zoo.FbConnect.unlinkAccount", [null]);

      if (res["status"] == "ok")
        UserProvider.instance.logout();
      else if (res["errorMsg"] == "no_password") {
        AlertManager.instance.showSimpleAlert(
            context: context,
            bodyText: AppLocalizations.of(context).translate("app_settings_fbUnlinkAlert"),
            callbackAction: (retValue) {
              print("retValue: $retValue");
              if (retValue == 1) {
                _rpc.callMethod("Zoo.Account.remindPassword", [
                  {"username": UserProvider.instance.userInfo.username}
                ]);
              }
            },
            dialogButtonChoice: AlertChoices.OK_CANCEL);
      }
    } else {
      onFBLogin();
    }

    print(res);
  }

  onFBLogin() async {
    widget.setBusy(true);

    var res = await Zoo.fbLogin();

    // TODO: add translation for "app_login_blocked" (blocked popup)
    if (res["status"] != "ok") {
      widget.setBusy(false);
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("app_login_${res["status"]}"),
      );
      return;
    }

    var loginUserInfo = LoginUserInfo(facebook: 1);
    var loginRes = await UserProvider.instance.login(loginUserInfo);
    widget.setBusy(false);

    if (loginRes["status"] == "ok") {
      print("OK LOGIN!!!");
    } else {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("app_login_${loginRes["errorMsg"]}"),
      );
    }
  }

  @override
  void initState() {
    _rpc = RPC();
    _linkedInfoFetched = false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(dynamic d) {
    if (!_linkedInfoFetched) _getLinkedInfo();
  }

  _getLinkedInfo() async {
    var res = await _rpc.callMethod("Zoo.FbConnect.getLinkedInfo", [null]);
    print(res);
    setState(() {
      if (res["status"] == "ok") {
        _linkedInfo = FBLinkedInfo(id: res["data"]["id"].toString(), name: res["data"]["name"], pic_small: res["data"]["pic_small"]);
      } else if (res["errorMsg"] == "not_linked") {
        _linkedInfo = null;
      }
      _linkedInfoFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFffffff),
        width: widget.mySize.width,
        height: widget.mySize.height - 5,
        padding: EdgeInsets.only(left: 5, top: 5, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                AppLocalizations.of(context).translate("app_settings_txtFBInfo"),
                style: TextStyle(fontSize: 14.0, color: Color(0xff393e54), fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            _linkedInfo != null
                ? Html(data: AppLocalizations.of(context).translateWithArgs("app_settings_txtFBConnected", [UserProvider.instance.userInfo.username, _fbName]), style: {
                    "html": Style(
                      backgroundColor: Colors.white,
                      fontSize: FontSize.medium,
                    ),
                    "b": Style(
                      color: Color(0xff64abff),
                    ),
                  })
                : Html(data: AppLocalizations.of(context).translateWithArgs("app_settings_txtFBNotConnected", [UserProvider.instance.userInfo.username, _fbName]), style: {
                    "html": Style(
                      backgroundColor: Colors.white,
                      fontSize: FontSize.medium,
                    ),
                    "b": Style(
                      color: Color(0xff64abff),
                    ),
                  }),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 5),
              child: Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: buttonHandler,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 240,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xff64abff),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            _linkedInfo != null ? AppLocalizations.of(context).translate("app_settings_btnFBUnlink") : AppLocalizations.of(context).translate("app_settings_btnFBLink"),
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
        ));
  }
}
