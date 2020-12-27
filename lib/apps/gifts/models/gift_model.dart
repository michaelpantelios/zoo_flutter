class GiftModel {
  final int id;
  final String url;
  final String name;

  GiftModel({this.id, this.url, this.name});

  factory GiftModel.fromJSON(data) {
    return GiftModel(
        id: data["id"],
        url: data["url"],
      name: data["name"]
    );
  }
}