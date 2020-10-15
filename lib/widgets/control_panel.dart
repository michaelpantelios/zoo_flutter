// Widget that resides on the left side
// containing current app info (online users etc),
// apps icons, logout button

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

import 'package:zoo_flutter/widgets/control_panel_header.dart';
import 'package:zoo_flutter/widgets/app_buttons_list.dart';

class ControlPanel extends StatefulWidget {
  ControlPanel({Key key});

  @override
  ControlPanelState createState() => ControlPanelState();
}

class ControlPanelState extends State<ControlPanel> {
  PanelHeader _panelHeader;
  AppButtonsList _appButtonsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _panelHeader = new PanelHeader();
    _appButtonsList = new AppButtonsList();
  }

  @override
  Widget build(BuildContext context) {
    getLogoutButton(){
      return Container(
        // color: Colors.white,
        child: FlatButton(
            onPressed:() => {},
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  )
                ),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("panel_button_logoff"),
                        style: Theme.of(context).textTheme.bodyText2))
              ],
            )
        )
      );
    }


    return Container(
      width: 300,
      color: Theme.of(context).primaryColor,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              _panelHeader,
              SizedBox(height: 10),
              _appButtonsList,
              SizedBox(height: 10),
              getLogoutButton()
            ],
          )),
    );
  }


}
