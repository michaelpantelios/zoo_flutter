import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class TaskManager extends StatefulWidget{
  TaskManager();

  TaskManagerState createState() => TaskManagerState();
}

class TaskManagerState extends State<TaskManager>{
  TaskManagerState();

  @override
  Widget build(BuildContext context) {
   return Container(
     width: MediaQuery.of(context).size.width,
     height: GlobalSizes.taskManagerHeight,
     alignment: Alignment.topCenter,
     child: Container(
       height: GlobalSizes.taskManagerHeight-10,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            new BoxShadow(color: Theme.of(context).shadowColor, offset: new Offset(0.0, 5.0), blurRadius: 4, spreadRadius: 5),
          ],
        ),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Container(margin: EdgeInsets.only(left: 10), child: Image.asset("assets/images/taskmanager/zoo_logo.png"))
         ],
       ),
     )
   );
  }


}

