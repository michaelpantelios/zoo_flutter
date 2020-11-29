import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/widgets/z_record_set.dart';
import 'package:zoo_flutter/apps/search/search_result_item.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class SearchResults extends StatefulWidget {
  SearchResults({Key key, @required this.resData, @required this.rows, @required this.cols})
      : super(key: key);

  final List resData;
  final int rows;
  final int cols;

  SearchResultsState createState() => SearchResultsState(key: key);
}

class SearchResultsState extends State<SearchResults> {
  SearchResultsState({Key key});

  List<TableRow> rowsList;
  List<GlobalKey<SearchResultItemState>> thumbKeys;

  onItemClicked(int userId) {
    print("clicked on " + userId.toString());
  }

  @override
  void initState() {
    super.initState();
    thumbKeys = new List<GlobalKey<SearchResultItemState>>();
    rowsList = new List<TableRow>();
    for (int i = 0; i < widget.rows; i++) {
      List<TableCell> cells = new List<TableCell>();
      for (int j = 0; j < widget.cols; j++) {
        GlobalKey<SearchResultItemState> theKey = new GlobalKey<SearchResultItemState>();
        cells.add(new TableCell(
            child:
                SearchResultItem(key: theKey, onClickHandler: onItemClicked)));
        thumbKeys.add(theKey);
      }
      TableRow row = new TableRow(children: cells);
      rowsList.add(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
                AppLocalizations.of(context)
                    .translate("app_search_results_title"),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))),
        Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ZRecordSet(
                rowsNum: widget.rows,
                colsNum: widget.cols,
                data: widget.resData,
                zeroItemsMessage: AppLocalizations.of(context)
                    .translate("app_search_results_noUsers"),
                rowsList: rowsList,
                thumbKeys: thumbKeys,
                showBullets: false,
            )
        )
      ],
    );
  }
}
