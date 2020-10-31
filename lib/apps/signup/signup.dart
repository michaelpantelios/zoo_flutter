import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/containers/alert/alert_container.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class SignupData {
  String username;
  String email;
  String password;

  SignupData({this.username = "", this.email = "", this.password = ""});
}

class Signup extends StatefulWidget {
  Signup({Key key});

  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  SignupState();

  final GlobalKey _key = GlobalKey();
  final GlobalKey<AlertContainerState> _alertKey =
      new GlobalKey<AlertContainerState>();
  Size size;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordAgainController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _passwordAgainFocusNode = FocusNode();
  SignupData signupData = new SignupData();

  _afterLayout(_) {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    size = renderBox.size;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _key,
      children: [
        // Container(
        //   color: Theme.of(context).canvasColor,
        //   padding: EdgeInsets.all(5),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Padding(
        //         padding: EdgeInsets.all(5),
        //         child: Row(
        //           children: [
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                     AppLocalizations.of(context)
        //                         .translate("app_login_mode_zoo_username"),
        //                     style: Theme.of(context).textTheme.bodyText1,
        //                     textAlign: TextAlign.left),
        //                 Container(
        //                   height: 30,
        //                   child: TextFormField(
        //                     controller: _usernameController,
        //                     focusNode: _usernameFocusNode,
        //                     decoration: InputDecoration(
        //                         contentPadding: EdgeInsets.all(5.0),
        //                         border: OutlineInputBorder()),
        //                     onChanged: (value) {
        //                       signupData.username = value;
        //                     },
        //                     onTap: () {
        //                       _usernameFocusNode.requestFocus();
        //                     },
        //                   ),
        //                 )
        //               ],
        //             ),
        //             SizedBox(
        //               width: 10
        //             ),
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                     AppLocalizations.of(context)
        //                         .translate("app_login_mode_zoo_username"),
        //                     style: Theme.of(context).textTheme.bodyText1,
        //                     textAlign: TextAlign.left),
        //                 Container(
        //                   height: 30,
        //                   child: TextFormField(
        //                     controller: _usernameController,
        //                     focusNode: _usernameFocusNode,
        //                     decoration: InputDecoration(
        //                         contentPadding: EdgeInsets.all(5.0),
        //                         border: OutlineInputBorder()),
        //                     onChanged: (value) {
        //                       signupData.username = value;
        //                     },
        //                     onTap: () {
        //                       _usernameFocusNode.requestFocus();
        //                     },
        //                   ),
        //                 )
        //               ],
        //             )
        //           ],
        //         )
        //       )
        //     ],
        //   )
        // )
      ],
    );
  }
}
