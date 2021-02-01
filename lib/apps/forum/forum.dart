import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/forum_abstract.dart';
import 'package:zoo_flutter/apps/forum/models/forum_category_model.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/forum/forum_search.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

import '../../main.dart';

class Forum extends StatefulWidget {
  Forum({this.onClose, this.setBusy});

  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;

  ForumState createState() => ForumState();
}

class ForumState extends State<Forum> with SingleTickerProviderStateMixin {
  ForumState();

  dynamic _initOptions;

  double _restHeight = 40;

  bool _ready = false;

  List<Widget>_tabs;
  List<ForumAbstract> _forumViews;
  List<GlobalKey<ForumAbstractState>> _forumViewKeys;

  RPC _rpc;
  GlobalKey _key = GlobalKey();
  dynamic _resData;

  Size size;
  TabController _tabController;

  bool _forumSearchVisible = false;
  GlobalKey<ForumAbstractState> _searchForumKey;
  bool _searchTabVisible = false;

  int _selectedTabIndex = 0;

  _onOpenSearchHandler(){
    setState(() {
      _forumSearchVisible = true;
    });
  }

  _onCloseSearchHandler(){
    setState(() {
      _forumSearchVisible = false;
    });
  }

  _onSearchHandler(dynamic criteria){
     print("Lets search for criteria");
      setState(() {
        _searchTabVisible = true;
        _searchForumKey.currentState.refresh(criteria);
        _tabController.index = _tabs.length-1;
      });
    }


  Widget _loadingView() {
    return SizedBox(
        width: Root.AppSize.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding,
        height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
          width: Root.AppSize.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding,
          height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
          child:
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              backgroundColor: Colors.white,
            ),
          ),

        ));
  }

  @override
  void initState() {
    super.initState();
    print("forum initState");
    _rpc = RPC();

    //add listener
    AppProvider.instance.addListener(_onAppProviderListener);
    _onAppProviderListener();

    _getForumList();
  }

  _onAppProviderListener(){
    print("_onAppProviderListener");
    if (AppProvider.instance.currentAppInfo.id == AppProvider.instance.getAppInfo(AppType.Forum).id){
      _initOptions = AppProvider.instance.currentAppInfo.options;
      if (_initOptions != null){
        print("initOptions forumId = "+_initOptions["forumId"].toString());
        print("initOptions topicId = "+_initOptions["topicId"].toString());
        _selectedTabIndex = int.parse(_initOptions["forumId"].toString()) - 1;

      } else {
        _selectedTabIndex = 0;
        print("_initOptions = null");
      }
      print("_onAppProviderListener, _selectedTabIndex = "+_selectedTabIndex.toString());

      if (_ready){
        print("_ready = true");
        _tabController.animateTo(_selectedTabIndex);
        _forumViewKeys[_tabController.index].currentState.start(_initOptions != null ? int.parse(_initOptions["topicId"].toString()) : null);
      }
    }
  }

  _getForumList() async {
    print("_getForumList, _selectedTabIndex = "+_selectedTabIndex.toString());
    var res = await _rpc.callMethod("OldApps.Forum.getForumList", []);

    if (res["status"] == "ok") {
      print("forumList: ");
      // print(res["data"]);

      _resData = res["data"];

      _tabController = TabController(initialIndex: _selectedTabIndex, length: _resData.length+1, vsync: this);
      _tabController.addListener(() => _onChangeTab() );

      _forumViews = [];
      _forumViewKeys = [];

      for (int i = 0; i < _resData.length; i++) {
          ForumCategoryModel cat = ForumCategoryModel.fromJSON(_resData[i]);
          GlobalKey<ForumAbstractState> _viewKey = new GlobalKey<ForumAbstractState>();
          _forumViewKeys.add(_viewKey);
          _forumViews.add(
              ForumAbstract(
                  key: _viewKey,
                  criteria: { "forumId" : cat.id },
                  onSearchHandler: _onOpenSearchHandler,
                  myHeight: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding - _restHeight,
                  loadAuto: i == _selectedTabIndex,
                  topicId: _initOptions != null ? int.parse(_initOptions["topicId"].toString()) : null
              ),
          );
        }

        _searchForumKey = GlobalKey<ForumAbstractState>();
        _forumViews.add(ForumAbstract(key: _searchForumKey, criteria: null, loadAuto: false, onSearchHandler: _onOpenSearchHandler, myHeight:  Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding - _restHeight));

        setState(() {
         _ready = true;
        });
    } else {
      print("ERROR");
      print(res["status"]);
    }
    return res;
  }

  _onChangeTab(){
    //zero out init
    _initOptions = null;
    print("onChangeTab");
    setState(() {
      print("Selected Index: " + _tabController.index.toString());
      if (_tabController.index < 8)
        _forumViewKeys[_tabController.index].currentState.start(_initOptions != null ? int.parse(_initOptions["topicId"].toString()) : null);
        _selectedTabIndex = _tabController.index;
    });
  }

  getTabs(BuildContext context) {
    _tabs = [];

    for (int i = 0; i < _resData.length; i++) {
      ForumCategoryModel cat = ForumCategoryModel.fromJSON(_resData[i]);
      _tabs.add(new Container(
        width: 90,
        height: 30,
        padding: EdgeInsets.all(3),
        child:
        Text(AppLocalizations.of(context).translate("app_forum_category_" + cat.id.toString()),
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1),
      ));
    }

    _tabs.add(Visibility(
      visible: _searchTabVisible,
      child: Container(
        width: 90,
        height: 30,
        padding: EdgeInsets.all(3),
        child: Text(AppLocalizations.of(context).translate("app_forum_search"), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      )),
    );

    return _tabs;
  }

  @override
  Widget build(BuildContext context) {
    print("FORUM BUILD, _selectedTabIndex = "+_selectedTabIndex.toString());
    return !_ready
        ? _loadingView()
        : SizedBox(
        width: Root.AppSize.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding,
        height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 30,
                  margin: EdgeInsets.only(top: 5),
                  child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      // indicatorSize: TabBarIndicatorSize.label,
                      // labelPadding: EdgeInsets.all(1.0),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(color: Color(0xFF222222), width: 2.0),
                        insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      ),
                      unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xffA7A7A7)),
                      tabs: getTabs(context))),
              IndexedStack(
                  index : _selectedTabIndex,
                  children: _forumViews
              )
            ],
          ),
          _forumSearchVisible ? Center(child: ForumSearch(onCloseBtnHandler: _onCloseSearchHandler, onSearchHandler: _onSearchHandler)) : Container()
        ],
      )
    );
  }
}
