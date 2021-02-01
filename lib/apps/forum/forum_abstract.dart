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
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

import '../../main.dart';

enum ViewStatus { homeView, topicView }

class ForumAbstract extends StatefulWidget {
  ForumAbstract({Key key, this.criteria, this.myHeight, this.onSearchHandler, this.loadAuto = true, this.topicId}) : super(key: key);

  final bool loadAuto;
  final Function onSearchHandler;
  final dynamic criteria;
  final double myHeight;
  final int topicId;

  ForumAbstractState createState() => ForumAbstractState(key : key);
}

class ForumAbstractState extends State<ForumAbstract>{
  ForumAbstractState({Key key});

  dynamic _initTopicId;

  dynamic _criteria;

  double _controlsHeight = 130;
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

  List<Widget> _rows = [];
  List<GlobalKey<ForumResultsTopicRowState>> _rowKeys = [];

  int _rowsPerPage;
  int _totalPages = 0;
  int _currentPage = 1;

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  bool _newPostButtonEnabled = false;

  bool _isLoading = false;

  start(int topicId){
    print("forum abstract start, topicId = ");
    print(topicId);
    _initTopicId = topicId;
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
    _topicsFetched = [];

    _initTopicId = widget.topicId;

    _criteria = widget.criteria;
    if (_criteria != null)
      _newPostButtonEnabled = _criteria["forumId"] != null;

    _rowsPerPage = ((widget.myHeight - _controlsHeight) / ForumResultsTopicRow.myHeight).floor();

    for(int i=0; i<_rowsPerPage; i++){
      GlobalKey<ForumResultsTopicRowState> _key = GlobalKey<ForumResultsTopicRowState>();
      _rowKeys.add(_key);
      _rows.add(ForumResultsTopicRow(key: _key, onSubjectTap: _onTopicTitleTap));
    }

    if (widget.loadAuto && _criteria != null)
      _getTopicList();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    _filters = [];
    _filters.add(
          DropdownMenuItem(
        child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_0"),
            style: TextStyle(
            fontSize: 12.0,
            color: Color(0xFF111111),
            fontWeight: FontWeight.normal)),
        value: "",
      )
    );
    _filters.add(
        DropdownMenuItem(
          child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_1"),
              style: TextStyle(
            fontSize: 12.0,
            color: Color(0xFF111111),
            fontWeight: FontWeight.normal)),
          value: "stickies",
        )
    );
    _filters.add(
        DropdownMenuItem(
            child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_2"),
                style: TextStyle(
            fontSize: 12.0,
            color: Color(0xFF111111),
            fontWeight: FontWeight.normal)),
            value: "lastReply")
    );
    _filters.add(
        DropdownMenuItem(
            child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_3"),
                style: TextStyle(
            fontSize: 12.0,
            color: Color(0xFF111111),
            fontWeight: FontWeight.normal)),
            value: "date")
    );

  }

  _getTopicList({bool refresh = true}) async {
    setState(() {
      _isLoading = true;
    });

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
       _isLoading = false;
      // _btnLeftKey.currentState.setDisabled(_currentPage > 1);
      _btnLeftKey.currentState.setDisabled(_currentPage == 1);
      _btnRightKey.currentState.setDisabled(_currentPage == _totalPages);
    });

    if (_initTopicId != null){
      print("forumAbstract has init topicId:"+_initTopicId.toString());
      _onTopicTitleTap(_initTopicId);
    }
  }

  _onTopicTitleTap(dynamic topicId) {
    print("clicked on topic: " + topicId.toString());
    setState(() {
      _selectedTopic = int.parse(topicId.toString());
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

  Widget _loadingView() {
    return SizedBox(
        width: Root.AppSize.width - 10,
        height: widget.myHeight,
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
          width: Root.AppSize.width - 10,
          height: widget.myHeight,
          child:
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              backgroundColor: Colors.white,
            ),
          ),

        ));
  }

  _getTableViewActions(BuildContext context) {
    return Container(
        height: 60,
        padding: EdgeInsets.all(10),
        child: Row(
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
            SizedBox(width: 10),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: ZButton(
                  minWidth: 160,
                  height: 40,
                  buttonColor: Theme.of(context).buttonColor,
                  label: AppLocalizations.of(context).translate("app_forum_btn_refresh"),
                  labelStyle: Theme.of(context).textTheme.button,
                  clickHandler: _getTopicList,
                  iconData: Icons.refresh,
                  iconSize: 25,
                  iconColor: Colors.white,
                  hasBorder: false,
                  iconPosition: ZButtonIconPosition.right,
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: ZButton(
                  minWidth: 160,
                  height: 40,
                  buttonColor: Colors.yellow[800],
                  label: AppLocalizations.of(context).translate("app_forum_new_topic"),
                  labelStyle:  Theme.of(context).textTheme.button,
                  clickHandler: (){
                    print("new topic");
                    _openNewPost(context);
                  },
                  iconData: Icons.add_circle,
                  iconSize: 25,
                  iconColor: Colors.white,
                  hasBorder: false,
                  iconPosition: ZButtonIconPosition.right,
                  startDisabled: !_newPostButtonEnabled,
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: ZButton(
                  minWidth: 160,
                  height: 40,
                  buttonColor: Colors.green[700],
                  label: AppLocalizations.of(context).translate("app_forum_btn_search"),
                  labelStyle:  Theme.of(context).textTheme.button,
                  clickHandler: (){
                    widget.onSearchHandler();
                  },
                  iconData: Icons.search,
                  iconSize: 25,
                  iconColor: Colors.white,
                  hasBorder: false,
                  iconPosition: ZButtonIconPosition.right,
                )
            ),
          ],
        )
      );
    }

  @override
  Widget build(BuildContext context) {
    return Stack(
              children: [
                SizedBox(
                    width: Root.AppSize.width - 10,
                    child:
                    Container(
                        width: Root.AppSize.width,
                        // padding: EdgeInsets.all(5),
                        child: Center(
                            child:  Column(
                                children: [
                                  _getTableViewActions(context),
                                  Container(
                                      width: Root.AppSize.width,
                                      height: 30,
                                      color: Theme.of(context).secondaryHeaderColor,
                                      child: Row(
                                          children:[
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                    padding: EdgeInsets.only(left: 20),
                                                    child: Text(AppLocalizations.of(context).translate("app_forum_column_from"), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                                    )
                                                )
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                    child: Text(AppLocalizations.of(context).translate("app_forum_column_title"), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                                    )
                                                )
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                    child: Text(AppLocalizations.of(context).translate("app_forum_column_date"), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                                    )
                                                )
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                    child: Text(AppLocalizations.of(context).translate("app_forum_column_replies"), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ZButton(
                                            minWidth: 40,
                                            height: 40,
                                            key: _btnLeftKey,
                                            iconData: Icons.arrow_back_ios,
                                            iconColor: Colors.blue,
                                            iconSize: 30,
                                            clickHandler: _onPreviousPage,
                                            startDisabled: true
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
                                                          textAlign: TextAlign.center,
                                                          fontWeight: FontWeight.w100),
                                                        "b": Style(fontWeight: FontWeight.w700),
                                                        }))),
                                          ),
                                          ZButton(
                                            minWidth: 40,
                                            height: 40,
                                            key: _btnRightKey,
                                            iconData: Icons.arrow_forward_ios,
                                            iconColor: Colors.blue,
                                            iconSize: 30,
                                            clickHandler: _onNextPage,
                                            startDisabled: true,
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
                        myWidth: Root.AppSize.width - 10,
                        myHeight: widget.myHeight
                )
                    : Container(),
                _showNewPost ? Center(child: ForumNewPost(
                    parentSize: new Size(Root.AppSize.width - 10, Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding - 50),
                    forumId: _criteria["forumId"],
                    parent: null,
                    onCloseBtnHandler: _onNewPostCloseHandler))
                    : Container(),
                _isLoading ? _loadingView() : Container()
              ],
            );
      }

}
