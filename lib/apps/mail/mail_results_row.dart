import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/mail/mail_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/widgets/simple_user_renderer.dart';

class MailResultsRow extends StatefulWidget {
  MailResultsRow({Key key, this.onSubjectTap}) : super(key: key);

  final Function onSubjectTap;

  static double myHeight = 30;

  MailResultsRowState createState() => MailResultsRowState(key: key);
}

class MailResultsRowState extends State<MailResultsRow> {
  MailResultsRowState({Key key});

  int dayMilliseconds = 86400000;
  int twoDayMilliseconds = 172800000;
  int weekMilliseconds = 604800000;
  bool _selected = false;

  double _iconSize = MailResultsRow.myHeight * 0.5;
  bool _hover = false;

  int _id;
  UserInfo _userInfo;
  String _subject = "";
  dynamic _date;
  int _read = 0;

  getId() {
    return _id;
  }

  setRead(bool value) {
    setState(() {
      _read = value ? 1 : 0;
    });
  }

  setSelected(bool value) {
    setState(() {
      _selected = value;
    });
  }

  update(MailInfo data) {
    print("update: ${data.subject}");
    setState(() {
      _id = data.id;
      _userInfo = data.from != null ? data.from : data.to;
      _subject = _normalizeTitle(data);
      _date = data.date;
      _read = data.read;
    });
  }

  _normalizeTitle(MailInfo data) {
    if (data.type == "gift") {
      return AppLocalizations.of(context).translate("app_gifts_${data.subject}_subject");
    }

    return data.subject;
  }

  clear() {
    setState(() {
      _id = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_id != null) {
          setState(() {
            _selected = true;
          });

          widget.onSubjectTap(_id, widget.key);
        }
      },
      child: MouseRegion(
        onHover: (e) {
          setState(() {
            _hover = true;
          });
        },
        onExit: (e) {
          setState(() {
            _hover = false;
          });
        },
        child: Container(
          width: 555,
          height: MailResultsRow.myHeight,
          decoration: BoxDecoration(
              color: _selected
                  ? Colors.blueGrey.shade200
                  : _hover
                      ? Colors.blueGrey.shade50
                      : null,
              border: Border(
                right: BorderSide(color: Colors.black26, width: 1),
                left: BorderSide(color: Colors.black26, width: 1),
                bottom: BorderSide(color: Colors.black26, width: 1),
              )),
          child: _id == null
              ? Container()
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: Colors.black26, width: 1)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Container(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: Colors.black26, width: 1)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: _userInfo == null
                            ? Container()
                            : SimpleUserRenderer(
                                showOverState: false,
                                userInfo: _userInfo,
                                selected: false,
                                onSelected: (username) {},
                                onOpenProfile: (userId) {
                                  PopupManager.instance.show(context: context, popup: PopupType.Profile, options: int.parse(userId), callbackAction: (retValue) {});
                                },
                              ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: Colors.black26, width: 1)),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [Flexible(child: Text(_subject, style: TextStyle(color: Colors.black, fontWeight: _read == 0 ? FontWeight.bold : FontWeight.normal, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis))],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: MailResultsRow.myHeight,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Utils.instance.getNiceDate(int.parse(_date["__datetime__"].toString())),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
