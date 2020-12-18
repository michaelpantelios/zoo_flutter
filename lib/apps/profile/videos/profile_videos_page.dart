import 'package:zoo_flutter/models/video/user_video_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/profile/videos/profile_video_thumb.dart';

class ProfileVideosPage extends StatelessWidget {
  ProfileVideosPage({Key key,
    @required this.pageData,
    @required this.rows,
    this.cols,
    this.myWidth,
    this.onClickHandler});

  final List<UserVideoInfo> pageData;
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
              ProfileVideoThumb(
                key: GlobalKey(),
                videoInfo: this.pageData[index],
                onClickHandler: onClickHandler,
              )
          );
        } else {
          rowItems.add(
              SizedBox(width: ProfileVideoThumb.size.width, height: ProfileVideoThumb.size.height)
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
