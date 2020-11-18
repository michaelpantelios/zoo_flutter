enum ModulePosition { left, middle, right }

class HomeModuleInfoModel {
  String title;
  String imagePath;
  String mainText;
  ModulePosition position;

  changeMainText(value) {
    mainText = value;
  }

  HomeModuleInfoModel({this.title, this.imagePath, this.mainText, this.position});
}
