class SinglePlayerGameInfo{
  final String gameName;
  final String gameDesc;
  final String gameId;
  final String gameIcon;
  final String gameCode;
  final int gameWidth;
  final int gameHeight;
  final String category;
  final int order;

  SinglePlayerGameInfo({this.gameName, this.gameDesc, this.gameId, this.gameIcon, this.gameCode, this.gameWidth, this.gameHeight, this.category, this.order});

  factory SinglePlayerGameInfo.fromJson(Map<String, dynamic> json) {
    return new SinglePlayerGameInfo(
        gameName: json['gameName'] as String,
        gameDesc: json['gameDesc'] as String,
        gameId: json['gameId'] as String,
        gameIcon: json['gameIcon'] as String,
        gameCode: json['gameCode'] as String,
        gameWidth: json['gameWidth'] as int,
        gameHeight: json['gameHeight'] as int,
        category: json['category'] as String,
        order: json['order'] as int
    );
  }
}

class SinglePlayerGamesInfo{
  List<SinglePlayerGameInfo> singlePlayerGames;

  SinglePlayerGamesInfo({this.singlePlayerGames});

  factory SinglePlayerGamesInfo.fromJson(Map<String, dynamic> json) {
    return SinglePlayerGamesInfo(
        singlePlayerGames: (json['singleplayergames'] as List)
            ?.map((e) => e == null ? null : SinglePlayerGameInfo.fromJson(e as Map<String, dynamic>))
            ?.toList()
    );
  }
}
