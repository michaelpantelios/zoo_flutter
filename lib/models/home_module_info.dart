
enum ModulePosition { left, middle, right}

class HomeModuleInfo {
  String title;
  String imagePath;
  String mainText;
  ModulePosition position;

  HomeModuleInfo({
    this.title,
    this.imagePath,
    this.mainText,
    this.position
});
}