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

  GameInfo({this.gameid, this.name, this.variation, this.orientation, this.bgImage, this.icon, this.publisherLogo, this.gameUrl, this.terms, this.policy, this.fbNamespace});

  factory GameInfo.fromJson(Map<String, dynamic> json) => _$GameInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GameInfoToJson(this);
}

GameInfo _$GameInfoFromJson(Map<String, dynamic> json) {
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
  );
}

Map<String, dynamic> _$GameInfoToJson(GameInfo instance) => <String, dynamic>{
  'gameid': instance.gameid,
  'name' : instance.name,
  'variation' : instance.variation,
  'bgImage': instance.bgImage,
  'orientation': instance.orientation,
  'icon': instance.icon,
  'gameUrl': instance.gameUrl,
  'fbNamespace': instance.fbNamespace,
  'publisherLogo': instance.publisherLogo,
  'terms': instance.terms,
  'policy': instance.policy,
};


class GamesInfo {
  List<GameInfo> games;
  String likeUrl;

  GamesInfo({this.games, this.likeUrl});

  factory GamesInfo.fromJson(Map<String, dynamic> json) => _$GamesInfoFromJson(json);
}

GamesInfo _$GamesInfoFromJson(Map<String, dynamic> json) {
  return GamesInfo(
    games: (json['games'] as List)
        ?.map((e) =>
    e == null ? null : GameInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    likeUrl: json['likeUrl'] as String,
  );
}

Map<String, dynamic> _$GamesInfoToJson(GamesInfo instance) => <String, dynamic>{
  'games': instance.games?.map((e) => e?.toJson())?.toList(),
  'likeUrl': instance.likeUrl,
};