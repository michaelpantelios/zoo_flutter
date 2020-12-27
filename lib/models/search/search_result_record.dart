class SearchResultRecord {
  final dynamic username;
  final int userId;
  final dynamic star;
  final dynamic hasPhotos;
  final dynamic hasVideos;
  final dynamic online;
  final dynamic lastLogin;
  final dynamic mainPhoto;
  final dynamic me; //sex, age, country, city, zodiacSign
  final dynamic teaser;

  SearchResultRecord({this.username, this.userId, this.star, this.hasPhotos, this.hasVideos, this.online, this.lastLogin, this.mainPhoto, this.me, this.teaser});

  factory SearchResultRecord.fromJSON(data) {
    return SearchResultRecord(
        username: data["username"], userId: int.parse(data["userId"].toString()), star: data["star"], hasPhotos: data["hasPhotos"], hasVideos: data["hasVideos"], online: data["online"], lastLogin: data["lastLogin"], mainPhoto: data["mainPhoto"], me: data["me"], teaser: data["teaser"]);
  }
}
