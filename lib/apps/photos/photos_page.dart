import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/photos/photo_thumb.dart';
import 'package:zoo_flutter/models/photos/user_photo_model.dart';

class PhotosPage extends StatelessWidget {
  PhotosPage({Key key,
    @required this.pageData,
    @required this.rows,
    this.cols,
    this.myWidth,
    this.onClickHandler,
    this.onSetAsMainHandler,
    this.onDeleteHandler
    });

  final List<UserPhotoModel> pageData;
  final int rows;
  final int cols;
  final Function onClickHandler;
  final Function onSetAsMainHandler;
  final Function onDeleteHandler;
  final double myWidth;

  List<Row> getPageRows(){
    int dataRowsNum = (pageData.length / this.cols).ceil();
    List<Row> _rows = [];

    int index = -1;
    for (int i=0; i< dataRowsNum; i++ ){
      List<Widget> rowItems = [];
      for (int j=0; j< this.cols; j++){
        index++;
        if (index < pageData.length) {
          rowItems.add(
              PhotoThumb(
                key: GlobalKey(),
                photoData: this.pageData[index],
                onClickHandler: onClickHandler,
                onDeleteHandler: onDeleteHandler,
                onSetAsMainHandler: onSetAsMainHandler,
              )
          );
        } else {
          rowItems.add(
              SizedBox(width: PhotoThumb.size.width, height: PhotoThumb.size.height)
          );
        }
      }
      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
