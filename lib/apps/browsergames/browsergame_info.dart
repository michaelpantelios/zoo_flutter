
class BrowserGameInfo{
  final String gameName;
  final String gameDesc;
  final String gameId;
  final String gameIcon;
  final String gameUrl;
  final String category;
  int order;

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
