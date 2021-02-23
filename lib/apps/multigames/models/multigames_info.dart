class GameInfo {
  final String gameid;
  final String name;
  final String variation;
  final String bgImage;
  final String orientation;
  final String icon;
  final String gameUrl;
  final String fbNamespace;
  final String publisherLogo;
  final String terms;
  final String policy;
  final bool zooOnly;
  final String category;

  GameInfo({
    this.gameid,
    this.name,
    this.variation,
    this.orientation,
    this.bgImage,
    this.icon,
    this.publisherLogo,
    this.gameUrl,
    this.terms,
    this.policy,
    this.fbNamespace,
    this.zooOnly,
    this.category
  });

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
      gameid: json['gameid'] as String,
      name: json['name'] as String,
      variation: json['variation'],
      orientation: json['orientation'] as String,
      bgImage: json['bgImage'] as String,
      icon: json['icon'] as String,
      publisherLogo: json['publisherLogo'] as String,
      gameUrl: json['gameUrl'] as String,
      terms: json['terms'] as String,
      policy: json['policy'] as String,
      fbNamespace: json['fbNamespace'] as String,
      zooOnly: json['zooOnly'] as bool,
      category: json['category'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'gameid': this.gameid,
      'name': this.name,
      'variation': this.variation,
      'bgImage': this.bgImage,
      'orientation': this.orientation,
      'icon': this.icon,
      'gameUrl': this.gameUrl,
      'fbNamespace': this.fbNamespace,
      'publisherLogo': this.publisherLogo,
      'terms': this.terms,
      'policy': this.policy,
      'category' : this.category
    };
  }
}

class GamesInfo {
  List<GameInfo> games;
  String likeUrl;

  GamesInfo({this.games, this.likeUrl});

  factory GamesInfo.fromJson(Map<String, dynamic> json) {
    return GamesInfo(
      games: (json['games'] as List)?.map((e) => e == null ? null : GameInfo.fromJson(e as Map<String, dynamic>))?.toList(),
      likeUrl: json['likeUrl'] as String,
    );
  }
}
