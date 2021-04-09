import 'package:flutter/material.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class MailNewAttachmentItem extends StatelessWidget {
  MailNewAttachmentItem({Key key, this.id, this.attachmentFilename, this.onDelete}): super(key: key);

  final int id;
  final Function onDelete;
  final String attachmentFilename;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 3),
      padding: EdgeInsets.all(5),
      width: 80,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Photo "+(id+1).toString(), style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
          Tooltip(
            message: AppLocalizations.of(context).translate("mail_editorDeleteAttachment"),
            child:  GestureDetector(
                onTap: ()=>onDelete(id),
                child: Container(
                    child: Center(
                        child: Icon(Icons.close, color: Colors.white, size: 20)
                    )
                )
            )
          )
        ],
      )
    );
  }

}