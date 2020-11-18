import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/home/home_module_info_model.dart';

class HomeModule extends StatelessWidget {
  final HomeModuleInfoModel info;
  final Map<String, String> extraData;
  HomeModule({Key key, @required this.info, this.extraData});

  _titleText(context) {
    if (extraData != null) {
      info.title = info.title.replaceAll('{username}', extraData['username']);
    }

    return info.title;
  }

  getTitleArea(context) {
    if (info.title != null)
      return Row(
        children: [
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(5),
                  color: Colors.grey[800],
                  child: Text(
                    _titleText(context),
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.left,
                  )))
        ],
      );
    else
      return SizedBox(height: 5);
  }

  _mainText(context) {
    if (extraData != null) {
      info.changeMainText(info.mainText.replaceAll('{cost}', extraData['cost']));
      info.changeMainText(info.mainText.replaceAll('{userCoins}', extraData['userCoins']));
    }

    return info.mainText;
  }

  getMainTextArea(context) {
    if (info.mainText != null)
      return Container(
        padding: EdgeInsets.all(10),
        child: Text(
          _mainText(context),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    else
      return SizedBox(height: 5);
  }

  getImageArea() {
    if (info.imagePath != null)
      return Padding(padding: EdgeInsets.all(10), child: Image.asset(info.imagePath));
    else
      return SizedBox(height: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          children: [getTitleArea(context), getImageArea(), getMainTextArea(context)],
        ));
  }
}
