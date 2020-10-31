import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

typedef OnOkHandler = void Function();
typedef OnCancelHandler = void Function();

class AlertContainer extends StatefulWidget{
  AlertContainer({Key key, this.onOKHandler, this.onCancelHandler }) : super(key: key);

  static int optionsOk = 1;
  static int optionsCancel = 2;
  static int optionInput = 4;

  final OnOkHandler onOKHandler;
  final OnCancelHandler onCancelHandler;

  AlertContainerState createState() => AlertContainerState();
}

class AlertContainerState extends State<AlertContainer>{
  AlertContainerState({Key key, });

  String _contentText;
  String _textFieldValue;
  TextEditingController _textFieldController = TextEditingController();
  FocusNode _textFieldFocusNode = FocusNode();
  Size _size;
  bool show;
  int _options;

  @override
  void initState() {

    _size = new Size(100,100);
    show = false;
    super.initState();
  }

  update(String contentText, Size mySize, int options){
    setState(() {
       print("updateAlert");
       _contentText = contentText;
      _size = mySize;
      _options = options;
      show = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return show ?
      Stack(
      children: [
        Container(
            width: _size.width,
            height: _size.height,
            decoration: BoxDecoration(
                color: new Color.fromRGBO(0, 0, 0, 0.9) // Specifies the background color and the opacity
            ),
            child: Center(
                child: Container(
                    padding: EdgeInsets.all(5),
                    width: _size.width * 0.75,
                    height: _size.height * 0.75,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            color: Theme.of(context).backgroundColor,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.warning_amber_rounded,
                                    size: 25,
                                    color: Colors.red,
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(top: 1, bottom: 1, right: 10),
                                        child: Text(
                                            "ZooAlert",
                                            style: Theme.of(context).textTheme.headline1,
                                            textAlign: TextAlign.left))),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        show = false;
                                      });
                                    },
                                    child: Container(
                                        color: Colors.red,
                                        padding: EdgeInsets.all(3),
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        child: Icon(
                                          Icons.close,
                                          size: 25,
                                          color: Colors.white,
                                        )))
                              ],
                            )),
                        SizedBox(height: 5),
                        Expanded(
                          child: Center(
                            child:
                                Text( _contentText,
                                    style: Theme.of(context).textTheme.headline6)
                            )
                        ),
                        if (_options & AlertContainer.optionInput != 0) Container(
                          height: 30,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: _textFieldController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5.0),
                                border: OutlineInputBorder()),
                            onChanged: (value) {
                              _textFieldValue = value;
                            },
                            onTap: () {
                              _textFieldFocusNode.requestFocus();
                            },
                          ),
                        )
                        else Container(),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (_options & AlertContainer.optionsOk != 0) RaisedButton(
                                color: Colors.white,
                                child: Text(AppLocalizations.of(context).translate("alert_btn_ok"), style: TextStyle(color: Colors.green)),
                                onPressed: (){
                                  setState(() {
                                    widget.onOKHandler();
                                    show = false;
                                  });
                                },
                              ) else Container(),
                              if (_options & AlertContainer.optionsCancel != 0)
                              RaisedButton(
                                   color: Colors.white,
                                   child: Text(AppLocalizations.of(context).translate("alert_btn_cancel"), style: TextStyle(color: Colors.red)),
                                   onPressed: (){
                                     setState(() {
                                       widget.onCancelHandler();
                                       show = false;
                                     });
                                   }
                               ) else Container()
                            ],
                          )
                        )
                      ],
                    )

                )
            )
        ),

      ],
    ) : Container();
  }
}