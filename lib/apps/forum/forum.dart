import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/forum_abstract.dart';
import 'package:zoo_flutter/apps/forum/models/forum_category_model.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class Forum extends StatefulWidget {
  Forum({this.onClose, this.setBusy});

  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;

  ForumState createState() => ForumState();
}

class ForumState extends State<Forum> with SingleTickerProviderStateMixin {
  ForumState();

  double _restHeight = 190;

  bool _ready = false;

  List<ForumAbstract> _forumViews;
  List<GlobalKey<ForumAbstractState>> _forumViewKeys;

  RPC _rpc;
  GlobalKey _key = GlobalKey();
  dynamic _resData;

  Size size;
  Offset position;
  TabController _tabController;
  int _selectedTabIndex = 0;

  ForumAbstract _currentForum;

  _onSearchHandler(dynamic criteria){

  }

  @override
  void initState() {
    super.initState();
    print("forum initState");
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

        _tabController = TabController(length: _resData.length, vsync: this);
        _selectedTabIndex = 0;

        _tabController.addListener(() => _onChangeTab() );

        _forumViews = new List<ForumAbstract>();
        _forumViewKeys = new List<GlobalKey<ForumAbstractState>>();

        for (int i = 0; i < _resData.length; i++) {
          ForumCategoryModel cat = ForumCategoryModel.fromJSON(_resData[i]);
          GlobalKey<ForumAbstractState> _viewKey = new GlobalKey<ForumAbstractState>();
          _forumViewKeys.add(_viewKey);
          _forumViews.add(ForumAbstract(key: _viewKey, forumInfo: cat, myHeight: MediaQuery.of(context).size.height - _restHeight));
        }

        _currentForum = _forumViews[0];

        _ready = true;
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

      _selectedTabIndex = _tabController.index;
      _currentForum = _forumViews[_selectedTabIndex];
    });
  }

  getTabs(BuildContext context) {
    List<Widget>_tabs = new List<Widget>();

    for (int i = 0; i < _resData.length; i++) {
      ForumCategoryModel cat = ForumCategoryModel.fromJSON(_resData[i]);
      _tabs.add(new Container(
        // width: 80,
        padding: EdgeInsets.all(3),
        child: Text(AppLocalizations.of(context).translate("app_forum_category_" + cat.code.toString()), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      ));
    }
    return _tabs;
  }

  @override
  Widget build(BuildContext context) {
    print("FORUM BUILD");
    return !_ready
        ? Container()
        : Column(
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
                  _currentForum

            ],
          );
  }
}
