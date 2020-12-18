import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/net/rpc.dart';

class ProfileEdit extends StatefulWidget{
  ProfileEdit({this.info, this.size, this.onClose});

  final ProfileInfo info;
  final Size size;
  final Function(dynamic retValue) onClose;

  ProfileEditState createState() => ProfileEditState();
}

class ProfileEditState extends State<ProfileEdit>{
  ProfileEditState();

  RPC _rpc;

  @override
  Widget build(BuildContext context) {
   return Center(
     child: Text("ERXETAI", style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold))
   );
  }


}