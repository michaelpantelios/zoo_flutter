import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/control/user.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

class FacebookSettingsScreen extends StatefulWidget {
  FacebookSettingsScreen({Key key, this.mySize});

  final Size mySize;

  FacebookSettingsScreenState createState() => FacebookSettingsScreenState(key: key);
}

class FacebookSettingsScreenState extends State<FacebookSettingsScreen> {
  FacebookSettingsScreenState({Key key});

  bool _dataReady = false;
  bool _isFbConnected = false;
  String fbName = "";


  zooFbConnectServiceSimulator(Function responder){
    responder();
  }

  fbConnectInfoResponder(){
    setState(() {
      _dataReady = true;
      _isFbConnected = false;
      fbName = "Karamitros";
    });
  }

  buttonHandler(){

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    zooFbConnectServiceSimulator(fbConnectInfoResponder);
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
          Text(
              AppLocalizations.of(context)
                  .translate("app_settings_txtFBTitle"),
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
                    .translate("app_settings_txtFBInfo"),
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.left),
          ),
          SizedBox(height: 20),
          _dataReady ? _isFbConnected ?
              Html(
                data: AppLocalizations.of(context).translateWithArgs("app_settings_txtFBConnected", [User.instance.userInfo.username, fbName]),
                  style: {
                    "html": Style(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontSize: FontSize.medium
                    ),
                  }
              )
              : Html(
              data: AppLocalizations.of(context).translateWithArgs("app_settings_txtFBNotConnected", [User.instance.userInfo.username, fbName]),
              style: {
                "html": Style(
                    backgroundColor: Colors.white,
                    color: Colors.black,
                    fontSize: FontSize.medium
                ),
              }
          ) : Container(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _dataReady ? Container(
                  width: 200,
                  child: ZButton(
                    clickHandler: buttonHandler,
                    buttonColor: Colors.white,
                    label: _isFbConnected ? AppLocalizations.of(context).translate("app_settings_btnFBUnlink")
                        : AppLocalizations.of(context).translate("app_settings_btnFBLink"),
                    labelStyle: TextStyle(color:Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                  )
              ) : Container()
            ],
          )
        ],
      )
    );
  }
}