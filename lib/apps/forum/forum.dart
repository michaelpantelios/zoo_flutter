import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/forum_abstract.dart';
import 'package:zoo_flutter/apps/forum/models/forum_category_model.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/forum/forum_search.dart';

class Forum extends StatefulWidget {
  Forum({this.onClose, this.setBusy});

  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;

  ForumState createState() => ForumState();
}

class ForumState extends State<Forum> with SingleTickerProviderStateMixin {
  ForumState();

  RenderBox _renderBox;

  double _restHeight = 190;

  bool _ready = false;
  bool _loadingCategories = true;

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

  _afterLayout(e) {
    _renderBox = context.findRenderObject();
  }

  Widget _loadingView() {
    return _renderBox != null
        ? Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
      width: _renderBox.size.width,
      height: _renderBox.size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              backgroundColor: Colors.white,
            ),
          ),
         Text(
            AppLocalizations.of(context).translate("app_forum_gettingForums"),
            style: TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    )
        : Container();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    print("forum initState");
    _loadingCategories = true;
    _rpc = RPC();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    _getForumList();
  }

  _getForumList() async {
    var res = await _rpc.callMethod("OldApps.Forum.getForumList", []);

    if (res["status"] == "ok") {
      print("forumList: ");
      print(res["data"]);

      setState(() {
        _resData = res["data"];

        _tabController = TabController(initialIndex: 0, length: _resData.length+1, vsync: this);
        // _selectedTabIndex = 0;

        _tabController.addListener(() => _onChangeTab() );

        _forumViews = new List<ForumAbstract>();
        _forumViewKeys = new List<GlobalKey<ForumAbstractState>>();

        for (int i = 0; i < _resData.length; i++) {
          ForumCategoryModel cat = ForumCategoryModel.fromJSON(_resData[i]);
          GlobalKey<ForumAbstractState> _viewKey = new GlobalKey<ForumAbstractState>();
          _forumViewKeys.add(_viewKey);
          _forumViews.add(
              ForumAbstract(
                  key: _viewKey,
                  criteria: { "forumId" : cat.id },
                  onSearchHandler: _onOpenSearchHandler,
                  myHeight: MediaQuery.of(context).size.height - _restHeight,
                  loadAuto: i == 0,
              ),
          );
        }

        _searchForumKey = GlobalKey<ForumAbstractState>();
        _forumViews.add(ForumAbstract(key: _searchForumKey, criteria: null, loadAuto: false, onSearchHandler: _onOpenSearchHandler, myHeight: MediaQuery.of(context).size.height - _restHeight));

        _ready = true;
        _loadingCategories = false;
      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
    return res;
  }

  _onChangeTab(){
    setState(() {
      print("Selected Index: " + _tabController.index.toString());
      if (_tabController.index < 8)
        _forumViewKeys[_tabController.index].currentState.start();
      // _selectedTabIndex = _tabController.index;
    });
  }

  getTabs(BuildContext context) {
    _tabs = new List<Widget>();

    for (int i = 0; i < _resData.length; i++) {
      ForumCategoryModel cat = ForumCategoryModel.fromJSON(_resData[i]);
      _tabs.add(new Container(
        // width: 80,
        padding: EdgeInsets.all(3),
        child: Text(AppLocalizations.of(context).translate("app_forum_category_" + cat.id.toString()), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      ));
    }

    _tabs.add(Visibility(
      visible: _searchTabVisible,
      child: Container(
        padding: EdgeInsets.all(3),
        child: Text(AppLocalizations.of(context).translate("app_forum_search"), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      )),
    );

    return _tabs;
  }

  @override
  Widget build(BuildContext context) {
    print("FORUM BUILD");
    return !_ready
        ? Container()
        : Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.all(5),
                  child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      // labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(color: Color(0xFF222222), width: 2.0),
                        insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      ),
                      unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xffA7A7A7)),
                      tabs: getTabs(context))),
              IndexedStack(
                index : _tabController.index,
                children: _forumViews
              )
            ],
          ),
          _forumSearchVisible ? Center(child: ForumSearch(onCloseBtnHandler: _onCloseSearchHandler, onSearchHandler: _onSearchHandler)) : Container(),
          _loadingCategories ? _loadingView() : Container()
        ],
    );
  }
}
