import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/utils.dart';

class PhotoViewer extends StatelessWidget{
  PhotoViewer({this.size, this.photoId});

  final Size size;
  final int photoId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        Utils.instance.getUserPhotoUrl(photoId: photoId.toString(),size: "normal"),
      fit: BoxFit.contain)
    );
  }


}