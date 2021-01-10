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

class Home extends StatelessWidget {
  final double _maxWidth = 960;

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
        child:  Scrollbar(
          thickness: 5,
          showTrackOnHover: true,
          isAlwaysShown: true,
          radius: Radius.circular(5),
          child: ListView(
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
        )
        ,
      ),
    );
  }
}
