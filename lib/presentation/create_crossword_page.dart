import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uchiru/widgets/appBar.dart';

import '../styles/styles.dart';

class CreateCrossword extends StatefulWidget {
  CreateCrossword({required this.id, required this.lessonID});
  final String id;
  final String lessonID;
  @override
  _CreateCrosswordState createState() => _CreateCrosswordState();
}

class _CreateCrosswordState extends State<CreateCrossword> {
  TextEditingController firstWord = TextEditingController();
  TextEditingController taskName = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController> words = [];
  List<bool> textfieldChange = [];
  int txtindex = 0;

  Widget textfield(TextEditingController wordController, int index){
    return Container(
      width: 400,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: Offset(0, 4),
              blurRadius: 16,
            )
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          onChanged: (text){

            if(text.trim().isNotEmpty && textfieldChange[index] == false){
              setState((){
                words.add(TextEditingController());
                txtindex++;
                textfields.add(textfield(words[txtindex], txtindex));
                textfieldChange.add(false);
                // listStream = Stream.fromIterable([textfields]);
                textfieldChange[index] = true;
              });

            }else if (text.trim().isEmpty && textfieldChange[index] == true){
              setState(() {
                words.removeAt(txtindex);
                textfields.removeAt(txtindex);
                textfieldChange.removeAt(txtindex);
                txtindex--;
                textfieldChange[index] = false;
              });
            }
          },
            validator: (value) {
              if (index == 0){
                if (value!.isEmpty) {
                  return 'Это поле не может быть пустым';
                }
                if (!value.contains('/')) {
                  return 'Неверное форматирование задачи. Поле должно содержать /.';
                }
                final parts = value.split('/');
                if (parts[0].isEmpty) {
                  return 'Неверное форматирование задачи. Перед / должно быть слово';
                }
                if(parts[1].isEmpty){
                  return 'Неверное форматирование задачи. После / должно быть описание';
                }
                return null;
              }
              if(value!.trim().isNotEmpty){
                if (!value.contains('/')) {
                  return 'Неверное форматирование задачи. Поле должно содержать /.';
                }
                final parts = value.split('/');
                if (parts[0].isEmpty) {
                  return 'Неверное форматирование задачи. Перед / должно быть слово';
                }
                if(parts[1].isEmpty){
                  return 'Неверное форматирование задачи. После / должно быть описание';
                }
                return null;
              }

              return null;
            },
          controller: wordController,
          decoration: InputDecoration(
            hintText: 'Слово / Описание',
            hintStyle: navTxt(fontSize: 16, weight: FontWeight.w500, color: Color(0xffC6C6C6)),
            contentPadding: EdgeInsets.only(left: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
            hoverColor: Colors.transparent,
          ),

        ),
      ),
    );
  }
  List<Widget> textfields = [];
  late Stream<List<Widget>> listStream;
  @override
  void initState() {
    words.add(firstWord);
    textfields.add(textfield(firstWord, txtindex));
    textfieldChange.add(false);
    listStream = Stream.fromIterable([textfields]);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: myAppBar(),
      floatingActionButton: SizedBox(
        width: 250,
        height: 60,
        child: button(onClick: () async {
          if(formKey.currentState!.validate() == true){
            List<Map<String, dynamic>> wordsToBD = [];
            for (int i = 0; i < textfields.length; i++){
              if (words[i].text.isNotEmpty){
                var parts = words[i].text.split('/');
                wordsToBD.add(
                    {
                      'name': parts[0],
                      'description': parts[1],
                    }
                );
              }
            }
            await FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.id)
                    .collection('lessons')
                    .doc(widget.lessonID)
                    .update({
              'words': wordsToBD
            });
            context.goNamed('groups_detail', pathParameters: {'groupId': widget.id});
              }
        }, text: 'Сохранить и выйти'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: listStream,
          builder: (context, snap){
            if(snap.hasData){
              return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 400,
                        height: 600,
                        child: ListView.builder(
                            itemCount: textfields.length,
                            itemBuilder: (context, index){
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: textfields[index],
                                  ),
                                  textfields.length == index
                                      ? TextButton(onPressed: (){
                                    setState((){
                                      words.add(TextEditingController());
                                      txtindex++;
                                      textfields.add(textfield(words[txtindex], txtindex));
                                      listStream = Stream.fromIterable([textfields]);
                                    });
                                  }, child: Text('Добавить слово'))
                                      : SizedBox.shrink()
                                ],
                              );
                            }
                        ),
                      ),


                    ],
                  )
              );
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }
}