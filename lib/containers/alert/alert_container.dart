import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlertContainer extends StatefulWidget{
  AlertContainer({Key key, @required this.parentSize, this.onOKHandler }) : super(key: key);

  static int optionsOk = 1;
  static int optionsCancel = 2;
  static int optionInput = 4;

  final Size parentSize;
  final Action onOKHandler;

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
            width: widget.parentSize.width,
            height: widget.parentSize.height,
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
                        Container(
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
                        ),

                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RaisedButton(
                                color: Colors.white,
                                child: Text("OK", style: TextStyle(color: Colors.green)),
                                onPressed: (){
                                  setState(() {
                                    show = false;
                                  });
                                },
                              ),
                              // RaisedButton(
                              //     color: Colors.red,
                              //     child: Text("Cancel"),
                              //     onPressed: (){}
                              // )
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