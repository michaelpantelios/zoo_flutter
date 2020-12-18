import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/models/search/search_result_record.dart';

class SearchResultsPage extends StatelessWidget {
  SearchResultsPage({Key key,
    @required this.pageData,
    @required this.rows,
    this.cols,
    this.myWidth,
    this.onClickHandler});

  final List<SearchResultRecord> pageData;
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
            SearchResultItem(
                key: GlobalKey(),
                data: this.pageData[index],
                onClickHandler: onClickHandler,
              )
          );
        } else {
          rowItems.add(
            SizedBox(width: SearchResultItem.myWidth, height: SearchResultItem.myHeight)
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
