import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
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

import '../../main.dart';

enum ModulePositions { pos1, pos2, pos3, pos4, pos5, pos6, pos7 }
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  final double _maxWidth = 960;
  ScrollController _scrollController = ScrollController();

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
      height: Root.AppSize.height - GlobalSizes.taskManagerHeight - 2 * GlobalSizes.fullAppMainPadding,
      alignment: Alignment.center,
      child: Container(
          width: _maxWidth+10,
          child: DraggableScrollbar(
                alwaysVisibleScrollThumb: true,
                controller: _scrollController,
                heightScrollThumb: 150.0,
                backgroundColor: Theme.of(context).backgroundColor,
                scrollThumbBuilder: (
                    Color backgroundColor,
                    Animation<double> thumbAnimation,
                    Animation<double> labelAnimation,
                    double height, {
                      Text labelText,
                      BoxConstraints labelConstraints,
                    }) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xff616161),
                      borderRadius: BorderRadius.circular(4.5),
                    ),
                    height: 150,
                    width: 9.0,
                    );
                },
                child: ListView(
                  // physics: ClampingScrollPhysics(),
                  controller: _scrollController,
                  children: [ Container(
                      width: _maxWidth,
                      padding: EdgeInsets.only(right: 10),
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
                          getModuleForPos(ModulePositions.pos7, context),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: FooterLinks(),
                          )
                        ],
                      ))
                    ],
                )
              ),
        )
    );
  }
}