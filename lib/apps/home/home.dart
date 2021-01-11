import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/home/footer_links.dart';
import 'package:zoo_flutter/apps/home/modules/banner.dart';
import 'package:zoo_flutter/apps/home/modules/forumHot/forum_hot.dart';
import 'package:zoo_flutter/apps/home/modules/home_profile_view.dart';
import 'package:zoo_flutter/apps/home/modules/new_signup.dart';
import 'package:zoo_flutter/apps/home/modules/news.dart';
import 'package:zoo_flutter/apps/home/modules/online_members.dart';
import 'package:zoo_flutter/apps/home/modules/suggestedGames/suggested_games.dart';
import 'package:zoo_flutter/apps/home/modules/zoo_maniacs.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
enum ModulePositions { pos1, pos2, pos3, pos4, pos5, pos6, pos7 }
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  final double _maxWidth = 960;
  ScrollController _scrollController = ScrollController();
  GlobalKey _fabKey = GlobalKey();
  double allHeight = 1330;
  bool _scrolledTop = true;

  @override
  void initState(){
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("bottom");
      setState(() {
        _scrolledTop = false;
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
     print("top");
     setState(() {
       _scrolledTop = true;
     });
    }
  }

  getModuleForPos(ModulePositions pos, BuildContext context) {
    bool userLogged = context.select((UserProvider user) => user.logged);
    switch (pos) {
      case ModulePositions.pos1:
        return HomeModuleNews();
      case ModulePositions.pos2:
        return HomeModuleForumHot();
      case ModulePositions.pos3:
        return HomeModuleSuggestedGames();
      case ModulePositions.pos4:
        return !userLogged ? HomeModuleNewSignup() : HomeModuleProfileView();
      case ModulePositions.pos5:
        return HomeModuleBanner();
      case ModulePositions.pos6:
        return HomeModuleOnlineMembers();
      case ModulePositions.pos7:
        return HomeModuleManiacs();
      default:
        return HomeModuleNews();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      // padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - 2 * GlobalSizes.fullAppMainPadding,
      alignment: Alignment.center,
      child: Container(
          width: _maxWidth,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              key: _fabKey ,
              child: Icon(_scrolledTop ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_up_outlined, color: Colors.white),
              onPressed: (){
               print("pressed");
               _scrollController.animateTo(
                 _scrolledTop ? allHeight : 0.0,
                 curve: Curves.easeOut,
                 duration: const Duration(milliseconds: 500),
               );
              },
            ),
            appBar: null,
              body: ListView(
                physics: ClampingScrollPhysics(),
                controller: _scrollController,
                children: [
                  Container(
                      color: Color(0xFFE3E4E8),
                      child: Container(
                          width: _maxWidth,
                          child: Column(
                            children: [
                              Container(
                                  height: 604,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              getModuleForPos(ModulePositions.pos1, context),
                                              SizedBox(height: 43),
                                              getModuleForPos(ModulePositions.pos2, context),
                                            ],
                                          )),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(flex: 1, child: getModuleForPos(ModulePositions.pos3, context)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              getModuleForPos(ModulePositions.pos4, context),
                                              getModuleForPos(ModulePositions.pos5, context),
                                            ],
                                          ))
                                    ],
                                  )),
                              SizedBox(height: 20),
                              getModuleForPos(ModulePositions.pos6, context),
                              SizedBox(height: 10),
                              getModuleForPos(ModulePositions.pos7, context)
                            ],
                          ))),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: FooterLinks(),
                  )
                ],
              )
          ),
        )
    );
  }
}