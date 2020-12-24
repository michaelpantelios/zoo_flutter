import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/chat/chat_emoticons_layer.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ChatInfo {
  String msg;
  final Color colour;
  final String fontFace;
  final int fontSize;
  final bool bold;
  final bool italic;
  ChatInfo({this.msg = "", this.colour = Colors.black, this.fontFace = "Verdana", this.fontSize = 13, this.bold = false, this.italic = false});
}

class ChatController extends StatefulWidget {
  final Function(ChatInfo chatInfo) onSend;
  ChatController({this.onSend});

  static List<String> chatFontFaces = [
    "Arial",
    "Arial Black",
    "Comic Sans MS",
    "Courier New",
    "Georgia",
    "Impact",
    "Times New Roman",
    "Trebuchet MS",
    "Verdana",
  ];

  static List<int> chatFontSizes = [
    12,
    13,
    14,
    15,
    16,
  ];
  @override
  State<StatefulWidget> createState() => _ChatControllerState();
}

class _ChatControllerState extends State<ChatController> {
  FocusNode _sendTextFocusNode = FocusNode();

  OverlayEntry _overlayEmoticons;
  Offset rendererPosition;
  Size rendererSize;
  RenderBox renderBox;
  bool isEmoticonsLayerOpen = false;
  final sendMessageController = TextEditingController();

  Color pickerColor = Color(0xff000000);
  Color currentColor = Color(0xff000000);
  List<bool> boldItalicSelection = List.generate(2, (index) => false);
  List<DropdownMenuItem<String>> _fontFaces;
  List<DropdownMenuItem<int>> _fontSizes;
  String _fontFaceSelected;
  int _fontSizeSelected;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    _fontFaces = [];
    _fontSizes = [];
    _fontFaceSelected = "Verdana";
    _fontSizeSelected = 13;
    ChatController.chatFontFaces.forEach((val) {
      _fontFaces.add(
        DropdownMenuItem(
          child: Text(
            val,
            style: TextStyle(fontSize: 12, fontFamily: val),
          ),
          value: val,
        ),
      );
    });

    ChatController.chatFontSizes.forEach((val) {
      _fontSizes.add(
        DropdownMenuItem(
          child: Text(
            val.toString(),
            style: TextStyle(fontSize: 12),
          ),
          value: val,
        ),
      );
    });
  }

  _afterLayout(_) {
    renderBox = context.findRenderObject();
    _sendTextFocusNode.requestFocus();
  }

  _onEmoSelected(String code) {
    print('code: $code');
    _appendEmoticon(code);
    _closeEmoticons();
    _sendTextFocusNode.requestFocus();
  }

  _appendEmoticon(String code) {
    var emoItem = ChatEmoticonsLayer.emoticons.firstWhere((element) => element["code"] == code, orElse: () => null);
    print(emoItem);
    if (emoItem != null) {
      sendMessageController.text = sendMessageController.text + emoItem["keys"][0];
    }
  }

  void _closeEmoticons() {
    _overlayEmoticons.remove();
    isEmoticonsLayerOpen = !isEmoticonsLayerOpen;
  }

  void _openEmoticons() {
    _findEmoticonsLayerPosition();
    _overlayEmoticons = _overlayMenuBuilder();
    Overlay.of(context).insert(_overlayEmoticons);
    isEmoticonsLayerOpen = !isEmoticonsLayerOpen;
  }

  _findEmoticonsLayerPosition() {
    rendererSize = renderBox.size;
    rendererPosition = renderBox.localToGlobal(Offset.zero);
  }

  @override
  void dispose() {
    sendMessageController.dispose();
    super.dispose();
  }

  OverlayEntry _overlayMenuBuilder() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        top: rendererPosition.dy + rendererSize.height - 300,
        left: rendererPosition.dx + 10,
        width: 400,
        child: Material(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[800],
                width: 0.1,
              ),
            ),
            child: ChatEmoticonsLayer(onSelected: (emoIndex) => _onEmoSelected(emoIndex)),
          ),
        ),
      );
    });
  }

  _sendMsg() {
    widget.onSend(
      ChatInfo(
        msg: sendMessageController.text,
        colour: currentColor,
        bold: boldItalicSelection[0],
        italic: boldItalicSelection[1],
        fontFace: _fontFaceSelected,
        fontSize: _fontSizeSelected,
      ),
    );
    sendMessageController.clear();
    _sendTextFocusNode.requestFocus();
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.emoji_emotions, color: Colors.orange),
                      onPressed: () {
                        print("emoticons!");
                        if (isEmoticonsLayerOpen)
                          _closeEmoticons();
                        else
                          _openEmoticons();
                      },
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context).translate("pick_color")),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    paletteType: PaletteType.hsl,
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                    enableAlpha: false,
                                    showLabel: false,
                                    pickerAreaHeightPercent: 0.8,
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(AppLocalizations.of(context).translate("ok")),
                                    onPressed: () {
                                      setState(() => currentColor = pickerColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: currentColor,
                          border: Border.all(color: Colors.grey, width: 0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 25,
                      child: ToggleButtons(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.bold, size: 15),
                          Icon(FontAwesomeIcons.italic, size: 15),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            boldItalicSelection[index] = !boldItalicSelection[index];
                          });
                        },
                        isSelected: boldItalicSelection,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 40,
                      child: DropdownButton(
                        value: _fontFaceSelected,
                        items: _fontFaces,
                        onChanged: (value) {
                          setState(() {
                            _fontFaceSelected = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 40,
                      child: DropdownButton(
                        value: _fontSizeSelected,
                        items: _fontSizes,
                        onChanged: (value) {
                          setState(() {
                            _fontSizeSelected = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 30,
                        child: TextField(
                          focusNode: _sendTextFocusNode,
                          controller: sendMessageController,
                          onSubmitted: (e) => _sendMsg(),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        _sendMsg();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, color: Colors.green, size: 20),
                          Padding(
                            padding: EdgeInsets.all(3),
                            child: Text(
                              AppLocalizations.of(context).translate("app_chat_btn_send"),
                              style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
