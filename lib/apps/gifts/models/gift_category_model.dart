class GiftCategoryModel {
  final int id;
  final String code;

  GiftCategoryModel({this.id, this.code});

  factory GiftCategoryModel.fromJSON(data) {
    return GiftCategoryModel(
        id: data["id"],
        code: data["code"]
    );
  }
}