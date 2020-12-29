import 'dart:core';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class ChatEmoticonsLayer extends StatelessWidget {
  static List<dynamic> emoticons = [
    {
      "code": "em_5",
      "keys": [";;)"]
    },
    {
      "code": "em_48",
      "keys": ["_):)"]
    },
    {
      "code": "em_21",
      "keys": [":))"]
    },
    {
      "code": "em_20",
      "keys": [":(("]
    },
    {
      "code": "em_19",
      "keys": ["_:)"]
    },
    {
      "code": "em_1",
      "keys": [":)"]
    },
    {
      "code": "em_2",
      "keys": [":("]
    },
    {
      "code": "em_3",
      "keys": [";)"]
    },
    {
      "code": "em_6",
      "keys": ["_:D_", "_:d_"]
    },
    {
      "code": "em_4",
      "keys": [":D", ":d"]
    },
    {
      "code": "em_7",
      "keys": [":-/"]
    },
    {
      "code": "em_8",
      "keys": [":x", ":X"]
    },
    {
      "code": "em_9",
      "keys": [":'_"]
    },
    {
      "code": "em_47",
      "keys": ["_:P", "_:p"]
    },
    {
      "code": "em_10",
      "keys": [":P", ":p"]
    },
    {
      "code": "em_11",
      "keys": [":-*"]
    },
    {
      "code": "em_12",
      "keys": ["=(("]
    },
    {
      "code": "em_13",
      "keys": [":-O", ":-o"]
    },
    {
      "code": "em_14",
      "keys": ["X(", "x("]
    },
    {
      "code": "em_15",
      "keys": [":_"]
    },
    {
      "code": "em_16",
      "keys": ["B-)", "b-)"]
    },
    {
      "code": "em_17",
      "keys": [":-S", ":-s"]
    },
    {
      "code": "em_18",
      "keys": ["#.-S", "#.-s"]
    },
    {
      "code": "em_22",
      "keys": [":|"]
    },
    {
      "code": "em_23",
      "keys": ["/:)"]
    },
    {
      "code": "em_24",
      "keys": ["=))"]
    },
    {
      "code": "em_25",
      "keys": ["O:)", "o:)"]
    },
    {
      "code": "em_26",
      "keys": [":-B", ":-b"]
    },
    {
      "code": "em_27",
      "keys": ["=;"]
    },
    {
      "code": "em_28",
      "keys": ["l-|"]
    },
    {
      "code": "em_29",
      "keys": ["8-|"]
    },
    {
      "code": "em_30",
      "keys": ["L-)", "l-)"]
    },
    {
      "code": "em_31",
      "keys": [":-&"]
    },
    {
      "code": "em_32",
      "keys": [":-\$"]
    },
    {
      "code": "em_33",
      "keys": ["[-("]
    },
    {
      "code": "em_34",
      "keys": [":O)", ":o)"]
    },
    {
      "code": "em_35",
      "keys": ["8-}"]
    },
    {
      "code": "em_36",
      "keys": ["_:-P", "_:-p"]
    },
    {
      "code": "em_37",
      "keys": ["(:|"]
    },
    {
      "code": "em_38",
      "keys": ["=P!", "=p!"]
    },
    {
      "code": "em_39",
      "keys": [":-?"]
    },
    {
      "code": "em_40",
      "keys": ["#o", "#O"]
    },
    {
      "code": "em_41",
      "keys": ["=D_", "=d_"]
    },
    {
      "code": "em_42",
      "keys": [":-SS", ":-ss"]
    },
    {
      "code": "em_43",
      "keys": ["@-)"]
    },
    {
      "code": "em_44",
      "keys": [":^o", ":^O"]
    },
    {
      "code": "em_45",
      "keys": [":-w", ":-W"]
    },
    {
      "code": "em_46",
      "keys": [":-_"]
    },
    {
      "code": "em_49",
      "keys": ["(I)", "(i)"]
    },
    {
      "code": "em_50",
      "keys": ["(D)", "(d)"]
    },
    {
      "code": "em_51",
      "keys": ["(W)", "(w)"]
    },
    {
      "code": "em_52",
      "keys": ["(so)"]
    },
    {
      "code": "em_53",
      "keys": ["(ip)"]
    },
    {
      "code": "em_54",
      "keys": ["(u)", "(U)"]
    },
    {
      "code": "em_55",
      "keys": ["(!)"]
    },
    {
      "code": "em_56",
      "keys": ["(})"]
    },
    {
      "code": "em_57",
      "keys": ["({)"]
    },
    {
      "code": "em_58",
      "keys": ["(L)", "(l)"]
    },
    {
      "code": "em_59",
      "keys": ["(K)", "(k)"]
    },
    {
      "code": "em_60",
      "keys": ["(8)"]
    }
  ];

  final Function(String code) onSelected;
  ChatEmoticonsLayer({this.onSelected});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 8,
        children: emoticons.map((e) => _emoticon(e["code"])).toList(),
        childAspectRatio: 16 / 9,
      ),
    );
  }

  static getIndexFromCode(String code) {
    return int.parse(code.split('_')[1]);
  }

  static getEmoPath(String code) {
    var index = getIndexFromCode(code);
    return window.location.toString().split('?')[0] + "assets/assets/images/emoticons/$index.gif";
  }

  Widget _emoticon(String code) {
    var emoIndex = getIndexFromCode(code);
    var htmlData = """
          <img src='${getEmoPath(code)}'>
          </img>
         """;
    return GestureDetector(
      onTap: () {
        print("taped : $code");
        onSelected(code);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[800],
            width: 0.1,
          ),
        ),
        child: Center(
          child: IgnorePointer(
            child: Html(
              data: htmlData,
              style: {
                "html": Style(textAlign: TextAlign.center),
              },
            ),
          ),
        ),
      ),
    );
  }
}
