import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
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
import 'package:zoo_flutter/apps/forum/forum_results_topic_row.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

enum ViewStatus { homeView, topicView }

class ForumAbstract extends StatefulWidget {
  ForumAbstract({Key key, this.criteria, this.myHeight, this.onSearchHandler, this.loadAuto = true}) : super(key: key);

  final bool loadAuto;
  final Function onSearchHandler;
  final dynamic criteria;
  final double myHeight;

  ForumAbstractState createState() => ForumAbstractState(key : key);
}

class ForumAbstractState extends State<ForumAbstract>{
  ForumAbstractState({Key key});

  dynamic _criteria;

  double _controlsHeight = 70;
  RPC _rpc;
  int _currentServicePage = 1;
  int _serviceRecsPerPageFactor =  10;

  List<DropdownMenuItem<String>> _filters;

  ViewStatus _viewStatus = ViewStatus.homeView;
  List<ForumTopicRecordModel> _topicsFetched;
  int _totalTopicsNum;

  String _searchByValue = "";
  bool _showNewPost = false;
  dynamic _selectedTopic;

  List<Widget> _rows = new List<Widget>();
  List<GlobalKey<ForumResultsTopicRowState>> _rowKeys = new List<GlobalKey<ForumResultsTopicRowState>>();

  int _rowsPerPage;
  int _totalPages = 0;
  int _currentPage = 1;

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  bool _newPostButtonEnabled = false;

  start(){
    if (_criteria != null)
      _getTopicList();
  }

  refresh(dynamic criteria){
    _criteria = criteria;
    _newPostButtonEnabled = _criteria["forumId"] != null;
    _getTopicList();
  }

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
    super.initState();
    _rpc = RPC();
    _topicsFetched = new List<ForumTopicRecordModel>();

    _criteria = widget.criteria;
    if (_criteria != null)
      _newPostButtonEnabled = _criteria["forumId"] != null;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
     _rowsPerPage = ((widget.myHeight - _controlsHeight) / ForumResultsTopicRow.myHeight).floor();

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
      GlobalKey<ForumResultsTopicRowState> _key = GlobalKey<ForumResultsTopicRowState>();
      _rowKeys.add(_key);
      _rows.add(ForumResultsTopicRow(key: _key, onSubjectTap: _onTopicTitleTap));
    }

    if (widget.loadAuto && _criteria != null)
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
    options["getCount"] = refresh ? 1 : 0;
    if (_searchByValue != "")
      options["order"] = _searchByValue;

    var res = await _rpc.callMethod("OldApps.Forum.getTopicList", _criteria, options);

    if (res["status"] == "ok"){
      if (res["data"]["count"] != null) {
        _totalTopicsNum = res["data"]["count"];
        _totalPages = (res["data"]["count"] / _rowsPerPage).ceil();
      }

      var records = res["data"]["records"];

      if (refresh) _topicsFetched.clear();

      for(int i=0; i<records.length; i++){
        ForumTopicRecordModel topic = ForumTopicRecordModel.fromJSON(records[i]);
        _topicsFetched.add(topic);
      }

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
        int fetchedTopicsIndex = ((_currentPage - 1) * _rowsPerPage) + i;
        if (fetchedTopicsIndex < _topicsFetched.length)
          _rowKeys[i].currentState.update(_topicsFetched[fetchedTopicsIndex]);
        else _rowKeys[i].currentState.clear();
      }

      _btnLeftKey.currentState.setDisabled(_currentPage > 1);

      if (_currentPage == _currentServicePage * _serviceRecsPerPageFactor
      && _topicsFetched.length <= _currentPage * _currentServicePage * _rowsPerPage){
        print("reached Max");
        _btnRightKey.currentState.setDisabled(true);
        _currentServicePage++;
        _getTopicList(refresh: false);
      }

     _updatePager();
  }
  
  _updatePager(){
    setState(() {
      _btnLeftKey.currentState.setDisabled(_currentPage > 1);
      _btnLeftKey.currentState.setDisabled(_currentPage == 1);
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

  _onNewPostCloseHandler(dynamic retVal) {
    if (retVal != null){
      if (retVal == "ok") {
        AlertManager.instance.showSimpleAlert(
            context: context,
            bodyText: AppLocalizations.of(context).translate( "app_forum_submitOK"));
        _getTopicList();
      } else {
        print("error");
        print(retVal);
      }
    }

    setState(() {
      _showNewPost = false;
    });
  }

  _openNewPost(BuildContext context){
    print("_open New Post ");
    if (!UserProvider.instance.logged) {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (res) {
            if (res) {
              print("ok");
              _doOpenNewPost();
            }
          });
      return;
    }
    _doOpenNewPost();
  }

  _doOpenNewPost(){
    setState(() {
      _showNewPost = true;
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
                labelStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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
                  labelStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  clickHandler: (){
                    print("new topic");
                    _openNewPost(context);
                  },
                  iconData: Icons.add_circle,
                  iconSize: 25,
                  iconColor: Colors.white,
                  hasBorder: false,
                  startDisabled: !_newPostButtonEnabled,
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
                labelStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                clickHandler: (){
                  widget.onSearchHandler();
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
                    child:
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
                                                flex: 1,
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
                                                flex: 1,
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
                    ? ForumTopicView(
                        topicId: _selectedTopic,
                        onReturnToForumView: _onReturnToForumView,
                        myWidth: MediaQuery.of(context).size.width - 10,
                        myHeight: MediaQuery.of(context).size.height - 130
                    )
                    : Container(),
                _showNewPost ? Center(child: ForumNewPost(
                    parentSize: new Size(MediaQuery.of(context).size.width - 10, MediaQuery.of(context).size.height - 10),
                    forumId: _criteria["forumId"],
                    parent: null,
                    onCloseBtnHandler: _onNewPostCloseHandler))
                    : Container()
              ],
            );
      }

}
