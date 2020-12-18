
class UserVideoInfo{
  final dynamic id;
  final dynamic title;
  final dynamic captureId;
  final dynamic length;
  final dynamic ratingAvg;
  final dynamic ratingNo;
  final dynamic views;

  UserVideoInfo({this.id, this.title, this.captureId, this.length, this.ratingAvg, this.ratingNo, this.views});

  factory UserVideoInfo.fromJSON(data) {
    return UserVideoInfo(
      id: data["id"],
      title: data["title"],
      captureId: data["captureId"],
      length: data["length"],
      ratingAvg: data["ratingAvg"],
      ratingNo: data["ratingNo"],
      views: data["views"],
    );
  }
}