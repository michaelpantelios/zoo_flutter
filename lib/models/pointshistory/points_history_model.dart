class PointsHistoryModel {
  final String action;
  final dynamic date;
  final dynamic points;

  PointsHistoryModel({this.action, this.date, this.points});

  factory PointsHistoryModel.fromJSON(data){
    return PointsHistoryModel(
      action: data["action"],
      date: data["date"],
      points: data["points"]
    );
  }
}