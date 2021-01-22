
class UserVideoModel{
  final dynamic id;
  final dynamic title;
  final dynamic captureId;
  final dynamic length;
  final dynamic ratingAvg;
  final dynamic ratingNo;
  final dynamic views;

  UserVideoModel({this.id, this.title, this.captureId, this.length, this.ratingAvg, this.ratingNo, this.views});

  factory UserVideoModel.fromJSON(data) {
    return UserVideoModel(
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