import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zoo_flutter/models/home/home_module_info_model.dart';

class HomeModule extends StatefulWidget {
  HomeModule({Key key, @required this.info});

  final HomeModuleInfoModel info;

  HomeModuleState createState() => HomeModuleState();
}

class HomeModuleState extends State<HomeModule>{
  HomeModuleState({Key key});

  @override
  Widget build(BuildContext context) {
    getTitleArea(){
      if (widget.info.title != null) return
      Row(
        children: [
          Expanded(
            child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(5),
                color: Colors.grey[800],
                child: Text(widget.info.title,
                    style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.left,)

            )
          )
        ],
      );

        else return SizedBox(height: 5);
    }

    getImageArea(){
      if (widget.info.imagePath != null) return
        Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(widget.info.imagePath)
        );
      else return SizedBox(height: 5);
    }

    getMainTextArea(){
      if (widget.info.mainText != null) return
        Container(
          padding: EdgeInsets.all(10),
          child: Text(widget.info.mainText, style: Theme.of(context).textTheme.bodyText1),
        ); else return SizedBox(height: 5);
    }

    return  Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: 1.0,
            ),
          ),
          // margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getTitleArea(),
              getImageArea(),
              getMainTextArea()
            ],
          )
    );

  }
}