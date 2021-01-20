class UserPhotoModel {
  final String title;
  final int imageId;
  final int approved;
  final int main;
  final dynamic date;
  final int personal;

  UserPhotoModel({this.title, this.imageId, this.approved, this.main, this.date, this.personal});

  factory UserPhotoModel.fromJSON(data) {
    return UserPhotoModel(
      title: data["title"],
      imageId: data["imageId"],
      approved: data["approved"],
      main: data["main"],
      date: data["date"],
      personal: data["personal"]
    );
  }
}