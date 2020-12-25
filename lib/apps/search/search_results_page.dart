import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/models/search/search_result_record.dart';

class SearchResultsPage extends StatefulWidget {
  SearchResultsPage({Key key,
    @required this.rows,
    this.cols,
    this.myWidth,
    this.myHeight
  });

  final int rows;
  final int cols;
  final double myWidth;
  final double myHeight;

  SearchResultsPageState createState() => SearchResultsPageState(key : key);
}

class SearchResultsPageState extends State<SearchResultsPage>{
  SearchResultsPageState({Key key});

  List<GlobalKey<SearchResultItemState>> _itemKeysList;
  int _itemsNum;
  List<SearchResultRecord> _pageData;

  update(List<SearchResultRecord> pageData){
    _pageData = pageData;
    for(int i=0; i< _itemKeysList.length; i++){
      if (i < _pageData.length)
        _itemKeysList[i].currentState.update(_pageData[i]);
      else _itemKeysList[i].currentState.clear();
    }
  }

  @override
  void initState() {
    super.initState();

    _itemsNum = widget.rows * widget.cols;

    _itemKeysList = new List<GlobalKey<SearchResultItemState>>();

  }

  List<Row> getPageRows(){
    List<Row> _rows = new List<Row>();

    for (int i=0; i< widget.rows; i++ ){
      List<Widget> rowItems = new List<Widget>();
      for (int j=0; j < widget.cols; j++){
          GlobalKey<SearchResultItemState> _key = GlobalKey<SearchResultItemState>();
          _itemKeysList.add(_key);
          rowItems.add(
            SearchResultItem(
              key: _key
            )
          );
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
    return
      Container(
      width: widget.myWidth,
      height: widget.myHeight,
      child: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: getPageRows(),
        )
      )
    );
  }
}
