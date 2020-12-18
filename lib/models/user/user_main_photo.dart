class MainPhoto {
  final String width;
  final String height;
  final String id;
  final String imageId;

  MainPhoto({
    this.width,
    this.height,
    this.id,
    this.imageId
  });

  factory MainPhoto.fromJSON(data){
    return MainPhoto(
        width: data["width"],
        height: data["height"],
        id: data["id"],
        imageId: data["image_id"]
    );
  }
}
