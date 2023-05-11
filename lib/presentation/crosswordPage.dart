

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uchiru/styles/styles.dart';
import 'package:uchiru/widgets/appBar.dart';


import '../classes/Crossword.dart';
import '../crossword_bloc.dart';
import '../helpers/DrawerHelper.dart';


class CrosswordPage extends StatefulWidget {
  String groupId;
  String taskID;

  CrosswordPage({
    required this.groupId,
    required this.taskID,
  });

  Crossword? c;

  @override
  _CrosswordPageState createState() => _CrosswordPageState();
}

class _CrosswordPageState extends State<CrosswordPage> {
  List<String> wordsDescriptions = [];
  List<String> wordsDescriptionsHoriz = [];
  List<String> wordsDescriptionsVert = [];
  String? jsonList;
  String? jsonString;
  Future<void> getJson() async {
      var task = await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).collection('lessons').doc(widget.taskID).get();

      jsonList = json.encode(task['words']) as String?;

      return Future.value(jsonList!)
          .then(parseWords);

  }

  @override
  void initState() {
    getJson();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    widget.c = Crossword(15, 15);
    widget.c!.reset();



    return BlocProvider<CrosswordBloc>(
        create: (context) => CrosswordBloc(),
        child: FutureBuilder(
            // future: _read(context, 'data/data2.json').then(parseWords),
            future: getJson(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                double width = MediaQuery.of(context).size.width;
                double height = MediaQuery.of(context).size.height;

                print(" Cruciverba : \n " + widget.c.toString());
                MyDrawerHelper myDrawerHelper = MyDrawerHelper();
                var row = myDrawerHelper.getRowsInSquare(context, width, widget.c!);


                return Scaffold(
                    appBar: myAppBar(),
                    body: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: row,
                              ),
                            ),
                            button(onClick: (){BlocProvider.of<CrosswordBloc>(context).add(CrosswordCheckEvent());},
                                text: 'Проверить'),
                            SizedBox(height: 40,),
                            Container(
                              alignment: Alignment.center,
                              width: 1200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 550,
                                    height: 550,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Слова по вертикали:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                        Expanded(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: widget.c!.descriptionsVert.length,
                                                itemBuilder: (context, index){
                                                  return Text("${widget.c!.descriptionsVert[index].index}. ${widget.c!.descriptionsVert[index].description}", style: TextStyle(fontSize: 18),);
                                                }
                                            ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  SizedBox(
                                    width: 550,
                                    height: 550,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Слова по горизонтали:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                                        Expanded(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: widget.c!.descriptionsHoriz.length,
                                                itemBuilder: (context, index){
                                                  return Text("${widget.c!.descriptionsHoriz[index].index}. ${widget.c!.descriptionsHoriz[index].description}", style: TextStyle(fontSize: 18),);
                                                }
                                            ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                    )

                );
              } else {
                return Scaffold(
                    body: Center(
                      child: new SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: new CircularProgressIndicator(
                          value: null,
                          strokeWidth: 7.0,
                        ),
                      ),
                    ));
              }
            }),
    );
  }

  void actualizeData() {
    var count = widget.c!.getN() * widget.c!.getM();

    var board = widget.c!.getBoard();
    var p = 0;

    for (var i = 0; i < widget.c!.getN(); i++) {
      for (var j = 0; j < widget.c!.getM(); j++) {
        var letter = board[i][j] == '*' ? ' ' : board[i][j];

        if (letter != ' ') count--;

        p++;
      }
    }
  }

  Future<void> parseWords(String s) async {
    List<dynamic> data;

    data = json.decode(s);

    int i = 0;



    data.forEach((record) {

      String parola = record["name"].toString().toLowerCase();
      String description = record["description"].toString().toLowerCase();
      if (!widget.c!.isCompleted() /*i++ < 9000*/) {

        if (widget.c!.addWord(parola, description) == 0) {

          // orrizzontale
        } else if (widget.c!.addWord(parola, description) == 1) {

          // verticale
        } else {
          // non usata
        }
      } else {
        return;
      }

    });

    actualizeData();
  }

}