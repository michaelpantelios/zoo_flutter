import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

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
      res = await _rpc.callMethod("Zoo.FbConnect.unlinkAccount", null);

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
      // ExternalInterface.addCallback("onFBSettingsLogin", onFBSettingsLogin);
      // ExternalInterface.call("Zoo.FB.login", "onFBSettingsLogin");
      // js.context.callMethod('fb_login', ["onFBSettingsLogin"]);
    }

    print(res);
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
    var res = await _rpc.callMethod("Zoo.FbConnect.getLinkedInfo", []);
    print(res);
    setState(() {
      if (res["status"] == "ok") {
        // _linkedInfo = FBLinkedInfo(id: res.data["id"].toString(), name: res.data["name"], pic_small: res.data["pic_small"]);
      } else if (res["errorMsg"] == "not_linked") {
        _linkedInfo = null;
      }
      _linkedInfoFetched = true;
    });
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).translate("app_settings_txtFBTitle"), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left),
            Padding(
                padding: EdgeInsets.all(5),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                  thickness: 1,
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(AppLocalizations.of(context).translate("app_settings_txtFBInfo"), style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.left),
            ),
            SizedBox(height: 20),
            _linkedInfo != null
                ? Html(data: AppLocalizations.of(context).translateWithArgs("app_settings_txtFBConnected", [UserProvider.instance.userInfo.username, _fbName]), style: {
                    "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium),
                  })
                : Html(data: AppLocalizations.of(context).translateWithArgs("app_settings_txtFBNotConnected", [UserProvider.instance.userInfo.username]), style: {
                    "html": Style(backgroundColor: Colors.white, color: Colors.black, fontSize: FontSize.medium),
                  }),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  child: ZButton(
                    clickHandler: buttonHandler,
                    buttonColor: Colors.white,
                    label: _linkedInfo != null ? AppLocalizations.of(context).translate("app_settings_btnFBUnlink") : AppLocalizations.of(context).translate("app_settings_btnFBLink"),
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
