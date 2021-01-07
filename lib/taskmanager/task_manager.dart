import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/taskmanager/task_manager_settings_button.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/taskmanager/task_manager_star_widget.dart';
import 'package:zoo_flutter/taskmanager/task_manager_coins_widget.dart';
import 'package:zoo_flutter/taskmanager/task_manager_zlvl_widget.dart';

class TaskManager extends StatefulWidget{
  TaskManager();

  TaskManagerState createState() => TaskManagerState();
}

class TaskManagerState extends State<TaskManager>{
  TaskManagerState();

  _onOpenNotifications(){
    AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("unavailable_service"));
  }

  _onOpenMail(){
    PopupManager.instance.show(context: context, popup: PopupType.Mail);
  }

  @override
  Widget build(BuildContext context) {
    var userLogged = context.select((UserProvider p) => p.logged);

   return Container(
     width: MediaQuery.of(context).size.width,
     height: GlobalSizes.taskManagerHeight,
     alignment: Alignment.topCenter,
     child: Container(
       height: GlobalSizes.taskManagerHeight-10,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            new BoxShadow(color: Color(0x15000000), offset: new Offset(0.0, 5.0), blurRadius: 4, spreadRadius: 5),
          ],
        ),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Container(margin: EdgeInsets.only(left: 10), child: Image.asset("assets/images/taskmanager/zoo_logo.png")),
           Expanded(child: Container()),
           userLogged ? Container() : ZButton(
            minWidth: 145,
             height: 40,
             buttonColor: Theme.of(context).buttonColor,
             label : AppLocalizations.of(context).translate("taskmanager_btn_signup"),
             labelStyle: Theme.of(context).textTheme.headline2,
             iconData: Icons.person_add_alt_1_rounded,
             iconSize: 30,
             iconColor: Theme.of(context).backgroundColor,
             iconPosition: ZButtonIconPosition.right,
             clickHandler: (){
               PopupManager.instance.show(context: context, popup: PopupType.Signup);
             },
           ),
           SizedBox(width: 10),
           userLogged ? Container() : ZButton(
             minWidth: 145,
             height: 40,
             buttonColor: Colors.white,
             label : AppLocalizations.of(context).translate("taskmanager_btn_login"),
             labelStyle: Theme.of(context).textTheme.headline3,
             iconData: Icons.login,
             iconSize: 30,
             iconColor: Theme.of(context).primaryColor,
             iconPosition: ZButtonIconPosition.right,
             clickHandler: (){
               PopupManager.instance.show(context: context, popup: PopupType.Login,  callbackAction: (retValue) {});
             },
           ),
           !userLogged ? Container() : TaskManagerZLevelWidget(),
           SizedBox(width: 20),
           !userLogged ? Container() : TaskManagerCoinsWidget(),
           SizedBox(width: 20),
           !userLogged ? Container() : TaskManagerStarWidget(),
           SizedBox(width: 20),
           !userLogged ? Container() : Tooltip(
             message: AppLocalizations.of(context).translate("taskmanager_icon_mail_tooltip"),
             child: ZButton(
               minWidth:70,
               height: 40,
               buttonColor: Colors.white,
               iconData: Icons.mail,
               iconSize: 30,
               iconColor: Theme.of(context).primaryColor,
               clickHandler: (){
                 _onOpenMail();
               },
             ),
           ),
           SizedBox(width: 10),
           !userLogged ? Container() : Tooltip(
             message: AppLocalizations.of(context).translate("taskmanager_icon_notif_tooltip"),
             child: ZButton(
               minWidth:70,
               height: 40,
               buttonColor: Colors.white,
               iconData: Icons.notifications,
               iconSize: 30,
               iconColor: Theme.of(context).primaryColor,
               clickHandler: (){
                 _onOpenNotifications();
               },
             ),
           ),
           SizedBox(width: 10),
           !userLogged ? Container() : TaskManagerSettingsButton()
         ],
       ),
     )
   );
  }


}

