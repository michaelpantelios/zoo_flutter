import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/panel/panel.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/containers/full/full_app_container.dart';
import 'package:zoo_flutter/containers/popup/popup_container.dart';
import 'package:zoo_flutter/models/apps/app_info_model.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  Panel _panel;
  FullAppContainer _fullAppContainer;
  PopupContainer _popupContainer;

  @override
  void initState() {
    _panel = new Panel();
    _fullAppContainer = FullAppContainer(appInfo: DataMocker.apps["home"]);
    _popupContainer = PopupContainer(appInfo: DataMocker.apps["profile"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Stack(
            children: [
            Container(
                color: Theme.of(context).backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _panel,
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: _fullAppContainer))
                    ])),
             _popupContainer
          ],
        ));
  }
}
