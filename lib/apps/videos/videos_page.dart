import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/videos/video_thumb.dart';
import 'package:zoo_flutter/models/video/user_video_model.dart';

class VideosPage extends StatelessWidget {
  VideosPage({Key key,
    @required this.pageData,
    @required this.rows,
    this.cols,
    this.myWidth,
    this.onClickHandler,
    this.onDeleteHandler
  });

  final List<UserVideoModel> pageData;
  final int rows;
  final int cols;
  final Function onClickHandler;
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
              VideoThumb(
                key: GlobalKey(),
                videoInfo: this.pageData[index],
                onClickHandler: onClickHandler,
                onDeleteHandler: onDeleteHandler
              )
          );
        } else {
          rowItems.add(
              SizedBox(width: VideoThumb.size.width, height: VideoThumb.size.height)
          );
        }
      }
      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
