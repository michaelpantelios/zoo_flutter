import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zoo_flutter/apps/forum/models/forum_category_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_record_model.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/apps/forum/forum_abstract.dart';

class Forum extends StatefulWidget {
  Forum({this.onClose, this.setBusy});

  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;

  ForumState createState() => ForumState();
}

class ForumState extends State<Forum> with SingleTickerProviderStateMixin {
  ForumState();

  bool _visible = false;

  List<ForumAbstract> _forumViews;
  List<GlobalKey<ForumAbstractState>> _forumViewKeys;

  RPC _rpc;
  GlobalKey _key = GlobalKey();
  dynamic _resData;

  Size size;
  Offset position;
  TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    print("forum initState");
    _rpc = RPC();

    super.initState();
  }

  getForumList() async {
    var res = await _rpc.callMethod("OldApps.Forum.getForumList", []);

    if (res["status"] == "ok") {
      print("forumList: ");
      print(res["data"]);

      setState(() {
        _resData = res["data"];

        _tabController = TabController(length: _resData.length, vsync: this);
        _selectedTabIndex = 0;

        _tabController.addListener(() {
          print("Selected Index: " + _tabController.index.toString());
          _selectedTabIndex = _tabController.index;
          _forumViewKeys[_selectedTabIndex].currentState.start();
        });

        _visible = true;
      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
    return res;
  }

  getTabs(BuildContext context) {
    List<Widget> _tabs = new List<Widget>();

    for(int i=0; i<_resData.length; i++){
      ForumCategoryModel cat = ForumCategoryModel.fromJSON(_resData[i]);
      _tabs.add(new Container(
        width: 100,
        padding: EdgeInsets.all(3),
        child: Text(
            AppLocalizations.of(context).translate("app_forum_category_"+cat.code.toString()),
            style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center),
      ));
    }
     return _tabs;
  }

  getForumViews(double width, double height){
    _forumViews = new List<ForumAbstract>();
    _forumViewKeys = new List<GlobalKey<ForumAbstractState>>();

    for(int i=0; i<_resData.length; i++){
      ForumCategoryModel cat = ForumCategoryModel.fromJSON(_resData[i]);
      GlobalKey<ForumAbstractState> _viewKey = new GlobalKey<ForumAbstractState>();
      _forumViewKeys.add(_viewKey);
      _forumViews.add(
          ForumAbstract(key: _viewKey ,forumInfo: cat, autoLoad: i == 0, myWidth: width, myHeight: height)
      );
    }

    return _forumViews;
  }


  @override
  Widget build(BuildContext context) {

    return !_visible ? Container(child: Center(
        child:
        ZButton(
          label: "Fere to forum",
          buttonColor: Colors.green,
          clickHandler: (){
            if (!UserProvider.instance.logged) {
              print("Forum: not logged");
             } else {
              var res = getForumList();
            }
          },
        )

    )) : Column(
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
                        tabs: getTabs(context)
                    )
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 120,
                  child:  TabBarView(
                    controller: _tabController,
                    children: getForumViews(MediaQuery.of(context).size.width - 10, MediaQuery.of(context).size.height - 140),
                  )
                )
              ],
            );
    }
}
