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
import 'package:zoo_flutter/widgets/z_dropdown_button.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/forum/forum_results_row.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

enum ViewStatus { homeView, topicView }

class ForumAbstract extends StatefulWidget {
  ForumAbstract({Key key, this.forumInfo}) : super(key: key);

  final ForumCategoryModel forumInfo;

  ForumAbstractState createState() => ForumAbstractState(key : key);
}

class ForumAbstractState extends State<ForumAbstract>{
  ForumAbstractState({Key key});

  RPC _rpc;
  int _currentServicePage = 1;
  int _serviceRecsPerPageFactor =  10;

  List<DropdownMenuItem<String>> _filters;

  ViewStatus _viewStatus = ViewStatus.homeView;
  List<ForumTopicRecordModel> _topics;
  String _searchByValue = "";
  bool _showNewPost = false;
  dynamic _selectedTopic;

  List<Widget> _rows = new List<Widget>();
  List<GlobalKey<ForumResultsRowState>> _rowKeys = new List<GlobalKey<ForumResultsRowState>>();

  int _rowsPerPage;
  int _totalPages = 0;
  int _currentPage = 1;

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  _onPreviousPage(){
    _currentPage--;
    _updatePageData();
  }

  _onNextPage(){
    _currentPage++;
    _updatePageData();
  }

  @override
  void initState() {
    _rpc = RPC();
    _topics = new List<ForumTopicRecordModel>();

    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
     _rowsPerPage = ((MediaQuery.of(context).size.height - 240) / ForumResultsRow.myHeight).floor();
    print("_rowsPerPage = "+_rowsPerPage.toString());

    _filters = new List<DropdownMenuItem<String>>();
    _filters.add(
          DropdownMenuItem(
        child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_0"),
            style: Theme.of(context).textTheme.bodyText1),
        value: "",
      )
    );
    _filters.add(
        DropdownMenuItem(
          child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_1"),
              style: Theme.of(context).textTheme.bodyText1),
          value: "stickies",
        )
    );
    _filters.add(
        DropdownMenuItem(
            child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_2"),
                style: Theme.of(context).textTheme.bodyText1),
            value: "lastReply")
    );
    _filters.add(
        DropdownMenuItem(
            child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_3"),
                style: Theme.of(context).textTheme.bodyText1),
            value: "date")
    );

    for(int i=0; i<_rowsPerPage; i++){
      GlobalKey<ForumResultsRowState> _key = GlobalKey<ForumResultsRowState>();
      _rowKeys.add(_key);
      _rows.add(ForumResultsRow(key: _key, onSubjectTap: _onTopicTitleTap));
    }

    _getTopicList();
  }

  _getTopicList({bool refresh = true}) async {
    if (refresh){
      _currentServicePage = 1;
      _currentPage = 1;
    }

    var options = {};
    options["recsPerPage"] = _serviceRecsPerPageFactor * _rowsPerPage;
    options["page"] = _currentServicePage;
    if (_searchByValue != "")
      options["order"] = _searchByValue;

    var res = await _rpc.callMethod("OldApps.Forum.getTopicList", {"forumId" : widget.forumInfo.id}, options);

    if (res["status"] == "ok"){
      var records = res["data"]["records"];

      print("records.length = "+records.length.toString());

      if (refresh)
        _topics.clear();
      for(int i=0; i<records.length; i++){
        ForumTopicRecordModel topic = ForumTopicRecordModel.fromJSON(records[i]);
        _topics.add(topic);
      }

      _totalPages = (_topics.length / _rowsPerPage).ceil();
      print("_totalPages = "+_totalPages.toString());

      if (refresh)
        _updatePageData();
      else _updatePager();

    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _updatePageData(){
      for(int i=0; i<_rowsPerPage; i++){
        int curIndex = ((_currentPage - 1) * _rowsPerPage) + i;
        if (curIndex < _topics.length)
          _rowKeys[i].currentState.update(_topics[curIndex]);
        else _rowKeys[i].currentState.clear();
      }

      if (_currentPage > 1)
        _btnLeftKey.currentState.setDisabled(false);

      if (_currentPage == _totalPages){
        print("reached Max");
        _btnRightKey.currentState.setDisabled(true);
        _currentServicePage++;
        _getTopicList(refresh: false);
      }

     _updatePager();
  }
  
  _updatePager(){
    setState(() {
      if (_currentPage > 1)
        _btnLeftKey.currentState.setDisabled(false);

      print("UPDATE PAGER");
      print("currentPage = "+_currentPage.toString());
      print("totalPages = "+_totalPages.toString());

      if (_btnLeftKey.currentState != null)
        _btnLeftKey.currentState.setDisabled(_currentPage == 1);

      // if (currentPage == _totalPages)
      if (_btnRightKey.currentState != null)
        _btnRightKey.currentState.setDisabled(_currentPage == _totalPages);

    });
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

  _onNewPostCloseHandler() {
    setState(() {
      _showNewPost = false;
      _getTopicList();
    });
  }

  _getTableViewActions(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          zDropdownButton(
              context, "", 220,
              _searchByValue,
              _filters,
                  (value) {
                setState(() {
                  _searchByValue = value;
                  print("sort by " + _searchByValue.toString());
                  if (_searchByValue != "")
                    _getTopicList();
                });
              }
          ),
          Container(
            width: 120,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.all(3),
            child: ZButton(
                buttonColor: Colors.blue,
                label: AppLocalizations.of(context).translate("app_forum_btn_refresh"),
                labelStyle: TextStyle(color: Colors.white, fontSize: 13),
                clickHandler: _getTopicList,
                iconData: Icons.refresh,
                iconSize: 25,
                iconColor: Colors.white,
                hasBorder: false,
            )
          ),
          Container(
              width: 120,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.all(3),
              child: ZButton(
                  buttonColor: Colors.yellow[800],
                  label: AppLocalizations.of(context).translate("app_forum_new_topic"),
                  labelStyle: TextStyle(color: Colors.white, fontSize: 13),
                  clickHandler: (){
                    print("new topic");
                    setState(() {
                      _showNewPost = true;
                    });
                  },
                  iconData: Icons.add_circle,
                  iconSize: 25,
                  iconColor: Colors.white,
                  hasBorder: false,
              )
          ),
          Container(
              width: 120,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.all(3),
              child: ZButton(
                buttonColor: Colors.green[700],
                label: AppLocalizations.of(context).translate("app_forum_btn_search"),
                labelStyle: TextStyle(color: Colors.white, fontSize: 13),
                clickHandler: (){
                  print("search topic");
                },
                iconData: Icons.search,
                iconSize: 25,
                iconColor: Colors.white,
                hasBorder: false,
              )
          ),
        ],
      );
    }


  @override
  Widget build(BuildContext context) {
    return Stack(
            children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height - 130,
                  child:
                  // _getTableView(context)
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      child: Center(
                          child:  Column(
                              children: [
                                _getTableViewActions(context),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26, width: 1),
                                    ),
                                    child: Row(
                                        children:[
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    border:  Border(
                                                        right: BorderSide(
                                                            color: Colors.black26, width: 1)),
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                                  child: Text(AppLocalizations.of(context).translate("app_forum_column_from"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                                  )
                                              )
                                          ),
                                          Expanded(
                                              flex: 6,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    border:  Border(
                                                        right: BorderSide(
                                                            color: Colors.black26, width: 1)),
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                                  child: Text(AppLocalizations.of(context).translate("app_forum_column_title"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                                  )
                                              )
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    border:  Border(
                                                        right: BorderSide(
                                                            color: Colors.black26, width: 1)),
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                                  child: Text(AppLocalizations.of(context).translate("app_forum_column_date"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                                  )
                                              )
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                                  child: Text(AppLocalizations.of(context).translate("app_forum_column_replies"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                                  )
                                              )
                                          )
                                        ]
                                    )
                                ),
                                Container(
                                    child: Column(
                                        children: _rows
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        Container(
                                            padding: EdgeInsets.all(3),
                                            width: 130,
                                            child: ZButton(
                                              key: _btnLeftKey,
                                              iconData: Icons.arrow_back_ios,
                                              iconColor: Colors.blue,
                                              iconSize: 30,
                                              label: AppLocalizations.of(context).translate("previous_page"),
                                              iconPosition: ZButtonIconPosition.left,
                                              clickHandler: _onPreviousPage,
                                              startDisabled: true,
                                              hasBorder: false,
                                            )
                                        ),
                                        Container(
                                          height: 30,
                                          width: 140,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 5),
                                              child: Center(
                                                  child: Html(data: AppLocalizations.of(context).translateWithArgs(
                                                      "pager_label", [_currentPage.toString(), _totalPages.toString()]),
                                                      style: {
                                                        "html": Style(
                                                            backgroundColor: Colors.white,
                                                            color: Colors.black,
                                                            textAlign: TextAlign.center),
                                                      }))),
                                        ),
                                        Container(
                                            width: 130,
                                            padding: EdgeInsets.all(3),
                                            child: ZButton(
                                              key: _btnRightKey,
                                              iconData: Icons.arrow_forward_ios,
                                              iconColor: Colors.blue,
                                              iconSize: 30,
                                              label: AppLocalizations.of(context).translate("next_page"),
                                              iconPosition: ZButtonIconPosition.right,
                                              clickHandler: _onNextPage,
                                              hasBorder: false,
                                              startDisabled: true,
                                            )
                                        )
                                      ],
                                    )

                                )
                              ]
                          )
                      )
                  )
                ),
                _viewStatus == ViewStatus.topicView
                  ? SizedBox(
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height - 130,
                    child: ForumTopicView(
                      forumInfo: widget.forumInfo,
                      topicId: _selectedTopic,
                      onReturnToForumView: _onReturnToForumView,
                      myWidth: MediaQuery.of(context).size.width - 10,
                      myHeight: MediaQuery.of(context).size.height - 140
                    )
                ) : Container(),
              _showNewPost ? ForumNewPost(
                  parentSize: new Size(MediaQuery.of(context).size.width - 10, MediaQuery.of(context).size.height - 140),
                  forumInfo: widget.forumInfo,
                  parent: null,
                  onCloseBtnHandler: _onNewPostCloseHandler)
                  : Container()
            ],
      );
  }
}
