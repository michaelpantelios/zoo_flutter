
enum ModulePosition { left, middle, right}

class HomeModuleInfoModel {
  String title;
  String imagePath;
  String mainText;
  ModulePosition position;

  HomeModuleInfoModel({
    this.title,
    this.imagePath,
    this.mainText,
    this.position
});
}