import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/chat/chat_emoticons_layer.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ChatInfo {
  String msg;
  String from;
  String to;
  final Color colour;
  final String fontFace;
  final int fontSize;
  final bool bold;
  final bool italic;

  ChatInfo({this.msg = "", this.colour = Colors.black, this.fontFace = "Verdana", this.fontSize = 12, this.bold = false, this.italic = false, this.from});

  @override
  String toString() {
    return "${msg}, ${colour}, ${fontFace}, ${fontSize}, ${bold}, ${italic}, to:: ${to}, from:: ${from}";
  }
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

  Color _pickerColor = Color(0xff000000);
  Color _currentColor =  Color(0xff000000);
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

    _loadSavedPrefs();
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

  _loadSavedPrefs() {
    Map<String, dynamic> chatPrefs = UserProvider.instance.chatPrefs;
    _currentColor = chatPrefs != null && chatPrefs["color"] != null ? Color(chatPrefs["color"]) : Color(0xff000000);
    _pickerColor = _currentColor;
    _fontFaceSelected = chatPrefs != null && chatPrefs["family"] != null ? chatPrefs["family"] : "Verdana";
    _fontSizeSelected = chatPrefs != null && chatPrefs["size"] != null ? chatPrefs["size"] : 12;
  }

  _saveColor(int color) {
    Map<String, dynamic> chatPrefs = UserProvider.instance.chatPrefs;
    chatPrefs["color"] = color;
    UserProvider.instance.chatPrefs = chatPrefs;
  }

  _saveFontSize(int size) {
    Map<String, dynamic> chatPrefs = UserProvider.instance.chatPrefs;
    chatPrefs["size"] = size;
    UserProvider.instance.chatPrefs = chatPrefs;
  }

  _saveFontFamily(String family) {
    Map<String, dynamic> chatPrefs = UserProvider.instance.chatPrefs;
    chatPrefs["family"] = family;
    UserProvider.instance.chatPrefs = chatPrefs;
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
        colour: _currentColor,
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
    setState(() => _pickerColor = color);
  }

  getFieldsInputDecoration() {
    return InputDecoration(
      fillColor: Color(0xffffffff),
      filled: false,
      enabledBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      errorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      focusedBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      focusedErrorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
                              pickerColor: _pickerColor,
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
                                setState(() => _currentColor = _pickerColor);
                                _saveColor(_currentColor.value);
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
                    color: _currentColor,
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
                    _saveFontFamily(_fontFaceSelected);
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
                      _saveFontSize(_fontSizeSelected);
                    });
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 20),
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
                      decoration: getFieldsInputDecoration(),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    _sendMsg();
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 110,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xff3c8d40),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              AppLocalizations.of(context).translate("app_chat_btn_send"),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Container(
                              width: 20,
                              height: 20,
                              child: Image.asset(
                                "assets/images/mail/mail_send.png",
                                color: Color(0xffffffff),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
