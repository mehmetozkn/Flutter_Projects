import 'package:flutter/material.dart';
import 'package:kelime_ezberleme_uygulamasi/db/db/db.dart';
import 'package:kelime_ezberleme_uygulamasi/db/models/words.dart';
import 'package:kelime_ezberleme_uygulamasi/global_widget/app_bar.dart';
import 'package:kelime_ezberleme_uygulamasi/global_widget/text_field_builder.dart';
import 'package:kelime_ezberleme_uygulamasi/global_widget/toast.dart';
import 'package:kelime_ezberleme_uygulamasi/methods.dart';

class AddWordPage extends StatefulWidget {
  final int? listID;
  final String? listName;

  const AddWordPage(this.listID, this.listName, {Key? key}) : super(key: key);

  @override
  _AddWordPageState createState() =>
      _AddWordPageState(listName: listName, listID: listID);
}

List<TextEditingController> wordTextEditingList = [];
List<Row> wordListField = [];

class _AddWordPageState extends State<AddWordPage> {
  int? listID;
  String? listName;
  _AddWordPageState({@required this.listID, @required this.listName});

  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 6; ++i)
      wordTextEditingList.add(TextEditingController());

    for (int i = 0; i < 3; ++i) {
      wordListField.add(Row(
        children: [
          Expanded(
              child: textFieldBuilder(
                  textEditingController: wordTextEditingList[2 * i])),
          Expanded(
              child: textFieldBuilder(
                  textEditingController: wordTextEditingList[2 * i + 1])),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
          context,
          left: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22,
          ),
          center: Text(
            listName!,
            style: TextStyle(
                fontFamily: "carter", fontSize: 22, color: Colors.black),
          ),
          right: Icon(
            Icons.add,
            color: Colors.black,
            size: 22,
          ),
          leftWidgetOnClick: () => Navigator.pop(context),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "İngilizce",
                        style: TextStyle(
                            fontSize: 18, fontFamily: "RobotoRegular"),
                      ),
                      Text(
                        "Türkçe",
                        style: TextStyle(
                            fontSize: 18, fontFamily: "RobotoRegular"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: wordListField,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    actionBtn(addRow, Icons.add),
                    actionBtn(save, Icons.save),
                    actionBtn(deleteRow, Icons.remove),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void addRow() {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());

    wordListField.add(Row(
      children: [
        Expanded(
            child: textFieldBuilder(
                textEditingController:
                    wordTextEditingList[wordTextEditingList.length - 2])),
        Expanded(
            child: textFieldBuilder(
                textEditingController:
                    wordTextEditingList[wordTextEditingList.length - 1])),
      ],
    ));
    setState(() => wordListField);
  }

  void save() async {
    int counter = 0;
    bool notEmptyPair = false;

    for (int i = 0; i < wordTextEditingList.length / 2; ++i) {
      String eng = wordTextEditingList[2 * i].text;
      String tr = wordTextEditingList[2 * i + 1].text;

      if (!eng.isEmpty && !tr.isEmpty) {
        counter++;
      } else {
        notEmptyPair = true;
      }
    }

    if (counter >= 1) {
      if (!notEmptyPair) {
        for (int i = 0; i < wordTextEditingList.length / 2; ++i) {
          String eng = wordTextEditingList[2 * i].text;
          String tr = wordTextEditingList[2 * i + 1].text;

          Word word = await DB.instance.insertWord(
              Word(list_id: listID, word_eng: eng, word_tr: tr, status: false));
          print(word.id.toString() +
              " " +
              word.list_id.toString() +
              " " +
              word.word_eng.toString() +
              " " +
              word.word_tr.toString() +
              " " +
              word.status.toString());
        }

        toastMessage("Kelimeler Eklendi.");

        wordTextEditingList.forEach((element) {
          element.clear();
        });
      } else {
        toastMessage("Boş Alanları Doldurun veya Silin");
      }
    } else {
      toastMessage("Minimum 1 çift dolu olmalıdır.");
    }
  }

  void deleteRow() {
    if (wordListField.length != 1) {
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      wordTextEditingList.removeAt(wordTextEditingList.length - 2);

      wordListField.removeAt(wordListField.length - 1);

      setState(() => wordListField);
    } else {
      toastMessage("Minimum 4 çift dolu olmalıdır.");
    }
  }
}

InkWell actionBtn(Function() click, IconData icon) {
  return InkWell(
    onTap: () => click(),
    child: Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.only(bottom: 5, top: 5),
      child: Icon(
        icon,
        size: 28,
      ),
      decoration: BoxDecoration(
        color: Color(Methods.HexaColorConverter("#DCD2FF")),
        shape: BoxShape.circle,
      ),
    ),
  );
}
