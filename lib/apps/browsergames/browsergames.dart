// ignore: avoid_web_libraries_in_flutter
import 'dart:async' show Future;
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;

class BrowserGameInfo{
  final String gameName;
  final String gameDesc;
  final String gameId;
  final String gameIcon;
  final String gameUrl;
  final String category;
  final int order;

  BrowserGameInfo({this.gameName, this.gameDesc, this.gameId, this.gameIcon, this.gameUrl, this.category, this.order});

  factory BrowserGameInfo.fromJson(Map<String, dynamic> json) {
    return new BrowserGameInfo(
      gameName: json['gameName'] as String,
      gameDesc: json['gameDesc'] as String,
      gameId: json['gameId'] as String,
      gameIcon: json['gameIcon'] as String,
      gameUrl: json['gameUrl'] as String,
      category: json['category'] as String,
      order: json['order'] as int
    );
  }
}

class BrowserGamesInfo{
  List<BrowserGameInfo> browserGames;

  BrowserGamesInfo({this.browserGames});

  factory BrowserGamesInfo.fromJson(Map<String, dynamic> json) {
   return BrowserGamesInfo(
     browserGames: (json['browsergames'] as List)
         ?.map((e) => e == null ? null : BrowserGameInfo.fromJson(e as Map<String, dynamic>))
         ?.toList()
   );
  }
}

class BrowserGames extends StatefulWidget{
  BrowserGames();

  BrowserGamesState createState() => BrowserGamesState();
}

class BrowserGamesState extends State<BrowserGames>{
  BrowserGamesState();

  Widget content;
  RenderBox renderBox;
  BrowserGamesInfo _gamesData;
  bool _inited = false;
  double myWidth;
  double myHeight;
  List<String> categories = ["strategy", "virtualworlds", "simulation", "farms", "action", "rpg"];

  onGameClickHandler(BrowserGameInfo gameInfo){

  }

  Future<void> loadGames() async {
    String jsonString = await rootBundle.loadString('assets/data/browsergames.json');
    final jsonResponse = json.decode(jsonString);
    _gamesData =  BrowserGamesInfo.fromJson(jsonResponse);
  }

  _afterLayout(_){
    renderBox = context.findRenderObject();
    myWidth = renderBox.size.width;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    content = Container();
    
    loadGames().then((value) => {
      print("browsergames one = "+_gamesData.browserGames[0].gameName)
    });
  }

  @override
  Widget build(BuildContext context) {
   return content;

  }
}