import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/profile/photos/profile_photo_thumb.dart';

class ProfilePhotosPage extends StatelessWidget {
  ProfilePhotosPage({Key key,
    @required this.pageData,
    @required this.rows,
    this.cols,
    this.myWidth,
    this.onClickHandler});

  final List<int> pageData;
  final int rows;
  final int cols;
  final Function onClickHandler;
  final double myWidth;

  List<Row> getPageRows(){
    int dataRowsNum = (pageData.length / this.cols).ceil();
    List<Row> _rows = new List<Row>();

    int index = -1;
    for (int i=0; i< dataRowsNum; i++ ){
      List<Widget> rowItems = new List<Widget>();
      for (int j=0; j< this.cols; j++){
        index++;
        if (index < pageData.length) {
          rowItems.add(
              ProfilePhotoThumb(
                key: GlobalKey(),
                photoId: this.pageData[index].toString(),
                onClickHandler: onClickHandler,
              )
          );
        } else {
          rowItems.add(
              SizedBox(width: ProfilePhotoThumb.size.width, height: ProfilePhotoThumb.size.height)
          );
        }
      }
      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rowItems,
      );

      _rows.add(row);
    }

    return _rows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: myWidth,
        child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: getPageRows(),
            )
        )
    );
  }
}
