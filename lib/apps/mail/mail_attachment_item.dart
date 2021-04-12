import 'package:flutter/material.dart';

class MailAttachmentItem extends StatelessWidget{
  MailAttachmentItem({Key key, this.id, this.imageId, this.onTap }) : super(key: key);

  final int id;
  final int imageId;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>onTap(imageId),
      child:  Container(
          margin: EdgeInsets.symmetric(horizontal: 3),
          color: Theme.of(context).secondaryHeaderColor,
          width: 80,
          height: 20,
          child: Center(
            child: Text("Photo "+(id+1).toString(), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center)
          ),
        )
    );
  }



}
