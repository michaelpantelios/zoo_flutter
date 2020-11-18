import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/home/home_module.dart';
import 'package:zoo_flutter/providers/auth.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class Home extends StatefulWidget {
  Home();

  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  HomeState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: Theme.of(context).canvasColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: new HomeModule(
                info: DataMocker.homeModules[0],
              ),
            ),
            SizedBox(width: 5),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: context.select((Auth auth) => auth.isLoggedIn)
                  ? HomeModule(
                      info: DataMocker.homeModules[3],
                      extraData: {
                        'username': context.select((Auth auth) => auth.username),
                        'cost': "10",
                        'userCoins': context.select((Auth auth) => auth.coins).toString(),
                      },
                    )
                  : HomeModule(
                      info: DataMocker.homeModules[1],
                    ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: new HomeModule(
                info: DataMocker.homeModules[2],
              ),
            )
          ],
        ));
  }
}
