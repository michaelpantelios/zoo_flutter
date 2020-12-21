import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/apps/forum/forum_new_post.dart';
import 'package:zoo_flutter/apps/forum/forum_topic_view.dart';
import 'package:zoo_flutter/apps/forum/models/forum_category_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_record_model.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';

enum ViewStatus { homeView, topicView }

class ForumAbstract extends StatefulWidget {
  ForumAbstract({Key key, this.forumInfo, this.autoLoad = false, this.myWidth, this.myHeight }) : super(key: key);

  final ForumCategoryModel forumInfo;
  final bool autoLoad;
  final double myWidth;
  final double myHeight;

  ForumAbstractState createState() => ForumAbstractState(key : key);
}

class ForumAbstractState extends State<ForumAbstract>{
  ForumAbstractState({Key key});

  RPC _rpc;
  int _currentServicePage = 1;
  int _serviceRecsPerPage =  500;

  double _tableRowHeight = 50;
  ViewStatus _viewStatus = ViewStatus.homeView;
  List<ForumTopicRecordModel> _topics;
  bool _topicsFetched = false;
  String _searchByValue = "";
  bool _showNewPost = false;
  dynamic _selectedTopic;

  TopicsDataTableSource _dtSource;

  int _rowsPerPage;

  start(){
    print("start for "+ widget.forumInfo.code.toString()+ ": ");
    _getTopicList();
  }

  @override
  void initState() {
    _rpc = RPC();
    _topics = new List<ForumTopicRecordModel>();
    _rowsPerPage = ((widget.myHeight - 130) / _tableRowHeight).floor();
    print("_rowsPerPage = "+_rowsPerPage.toString());

    if (widget.autoLoad) start();

    super.initState();
  }
  
  _getTopicList() async {
    var options = {};
    options["recsPerPage"] = _serviceRecsPerPage;
    options["page"] = _currentServicePage;
    if (_searchByValue != "")
      options["order"] = _searchByValue;

    var res = await _rpc.callMethod("OldApps.Forum.getTopicList", {"forumId" : widget.forumInfo.id}, options);

    if (res["status"] == "ok"){
      var records = res["data"]["records"];
      print("records.length = "+records.length.toString());
      setState(() {
        _topics.clear();
        for(int i=0; i<records.length; i++){
          ForumTopicRecordModel topic = ForumTopicRecordModel.fromJSON(records[i]);
          _topics.add(topic);
        }
        _topicsFetched = true;
      });

    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _onTopicTitleTap(dynamic topicId) {
    print("clicked on topic: " + topicId.toString());
    setState(() {
      _selectedTopic = topicId;
      _viewStatus = ViewStatus.topicView;
    });
  }

  _onReturnToForumView() {
    setState(() {
      _viewStatus = ViewStatus.homeView;
    });
  }

  _onTopicOwnerTap(UserInfo userInfo) {
    print("clicked on user: " + userInfo.userId.toString());
  }

  _onNewPostCloseHandler() {
    setState(() {
      _showNewPost = false;
      _getTopicList();
    });
  }

  _getTableViewActions() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton(
              value: _searchByValue,
              items: [
                DropdownMenuItem(
                  child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_0"),
                  style: Theme.of(context).textTheme.bodyText1),
                  value: "",
                ),
                DropdownMenuItem(
                  child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_1"),
                  style: Theme.of(context).textTheme.bodyText1),
                  value: "stickies",
                ),
                DropdownMenuItem(
                    child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_2"),
                     style: Theme.of(context).textTheme.bodyText1),
                     value: "lastReply"),
                DropdownMenuItem(
                    child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_3"),
                    style: Theme.of(context).textTheme.bodyText1),
                    value: "date")
              ],
              onChanged: (value) {
                setState(() {
                  _searchByValue = value;
                  print("sort by " + _searchByValue.toString());
                  if (_searchByValue != "")
                    start();
                });
              }),
          FlatButton(
            onPressed: () {
              start();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.refresh, color: Colors.blue, size: 20), Padding(padding: EdgeInsets.all(3), child: Text(AppLocalizations.of(context).translate("app_forum_btn_refresh"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))],
            ),
          ),
          FlatButton(
            onPressed: () {
              print("new topic");
              setState(() {
                _showNewPost = true;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.add_circle, color: Colors.yellow[700], size: 20), Padding(padding: EdgeInsets.all(3), child: Text(AppLocalizations.of(context).translate("app_forum_new_topic"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))],
            ),
          ),
          // FlatButton(
          //   onPressed: () {
          //     print("search topic");
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [Icon(Icons.search, color: Colors.green, size: 20), Padding(padding: EdgeInsets.all(3), child: Text(AppLocalizations.of(context).translate("app_forum_btn_search"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))],
          //   ),
          // )
        ],
      );
    }

  _getTableView(BuildContext context) {
      return PaginatedDataTable(columns: [
        DataColumn(
          label: Text(AppLocalizations.of(context).translate("app_forum_column_from"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text(AppLocalizations.of(context).translate("app_forum_column_title"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text(AppLocalizations.of(context).translate("app_forum_column_date"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text(AppLocalizations.of(context).translate("app_forum_column_replies"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
          rowsPerPage: _rowsPerPage,
          source: _dtSource,
          header: _getTableViewActions() );
    }

  @override
  Widget build(BuildContext context) {
    _dtSource = TopicsDataTableSource(topics: _topics, context: context, onTopicTap: (topicId) => _onTopicTitleTap(topicId), onTopicOwnerTap: (userInfo) => _onTopicOwnerTap(userInfo));

    // TODO: implement build
    return !_topicsFetched ? Container() : Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: widget.myWidth,
                height: widget.myHeight,
                child: _viewStatus == ViewStatus.topicView
                    ? ForumTopicView(
                        forumInfo: widget.forumInfo,
                        topicId: _selectedTopic,
                        onReturnToForumView: _onReturnToForumView,
                        myWidth: widget.myWidth,
                        myHeight: widget.myHeight
                      )
                    : _getTableView(context)
            )
          ],
        ),
       _showNewPost ? ForumNewPost(
             parentSize: new Size(widget.myWidth, widget.myHeight),
             forumInfo: widget.forumInfo,
             parent: null,
             onCloseBtnHandler: _onNewPostCloseHandler)
           : Container()
      ],
    );
  }

}


typedef OnTopicTap = void Function(dynamic topicId);
typedef OnTopicOwnerTap = void Function(UserInfo userInfo);

class TopicsDataTableSource extends DataTableSource {
  TopicsDataTableSource({@required this.topics, @required this.context, @required this.onTopicTap, @required this.onTopicOwnerTap}) : assert(topics != null);

  final BuildContext context;
  final List<ForumTopicRecordModel> topics;
  final OnTopicTap onTopicTap;
  final OnTopicOwnerTap onTopicOwnerTap;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => topics.length;

  @override
  int get selectedRowCount => 0;

  getTopicsListTitleRenderer(String title, dynamic topicId) {
    return GestureDetector(
        onTap: () {
          onTopicTap(topicId);
        },
        child: Container(
          child: Text(title, style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal), textAlign: TextAlign.start))
        );
  }

  getTopicDateRenderer(String date) {
    return Text(Utils.instance.getNiceForumDate(dd: date.toString(),hours: true), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center);
  }

  getRepliesRenderer(int num) {
    return Text(num.toString(), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center);
  }

  @override
  DataRow getRow(int index) {
    //assert(index >= 0);

    if (index >= topics.length) {
      return null;
    }

    final topic = topics[index];

    List<DataCell> cells = new List<DataCell>();

   cells.add(new DataCell(ForumUserRenderer(userInfo: ForumUserModel.fromJSON(topic.from))));

    cells.add(new DataCell(getTopicsListTitleRenderer(topic.subject, topic.id)));

    cells.add(new DataCell(getTopicDateRenderer(topic.date)));

    cells.add(new DataCell(getRepliesRenderer(topic.repliesNo)));

    DataRow row = new DataRow(cells: cells);

    return row;
  }
}
