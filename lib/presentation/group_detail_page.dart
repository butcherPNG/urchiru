import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uchiru/widgets/appBar.dart';

import '../styles/styles.dart';

class GroupsDetail extends StatefulWidget {
  const GroupsDetail({required this.id});
  final String id;





  @override
  State<GroupsDetail> createState() => _GroupsDetailState();
}


class _GroupsDetailState extends State<GroupsDetail> with TickerProviderStateMixin {

  TextEditingController emailController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  late bool isTeacher;
  Future<bool> checkPermissions() async {
    if(FirebaseAuth.instance.currentUser != null){
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
        value['role'] == 'teacher' ? isTeacher = true : isTeacher = false;
      });

    }else{
      isTeacher = false;
    }
    return isTeacher;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body:
      FirebaseAuth.instance.currentUser != null ?
      FutureBuilder(
          future: checkPermissions(),
          builder: (ctx, snap){
            if (snap.connectionState == ConnectionState.done) {

              return isTeacher == true ?
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 1165,
                          child: TabBar(
                              controller: _tabController,
                              tabs: <Widget>[
                                Tab(
                                  child: Text('Задания', style: blockTxt(),),
                                ),
                                Tab(
                                  child: Text('Ученики', style: blockTxt(),),
                                ),
                              ]
                          ),
                        ),
                        Container(
                          width: 1200,
                          height: MediaQuery.of(context).size.height - 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: blue,
                          ),
                          child: TabBarView(
                              controller: _tabController,
                              children: [
                                Center(
                                  child: Files(id: widget.id, isTeacher: isTeacher),
                                ),
                                Center(
                                  child: students(context, widget.id, formKey, emailController),
                                ),
                              ]
                          )
                        )
                      ],
                    ),
                  )
                  : Center(
                child: Container(
                  width: 1200,
                  height: MediaQuery.of(context).size.height - 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: blue,
                  ),
                  child: Files(id: widget.id, isTeacher: isTeacher, ),
                ),
              );



            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
      )
          : Center(child: SelectableText('В доступе отказано', style: offerTxt(color: dark, size: 48),),),
    );
  }
}

Widget students(BuildContext context, id, formKey, emailController){
  return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('groups').snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snap){
        print(id);
        var group = snap.data!.docs.firstWhere((doc) => doc.get('id') == id);
        var students = group.get('students');

        print('Group: $group');
        print('Students: $students');
        if(snap.hasData){

          return students.length != 0
              ? SizedBox(
            width: 900,
            height: 550,
            child: Scaffold(
              floatingActionButton: SizedBox(
                width: 250,
                height: 60,
                child: button(
                    onClick: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return Dialog(
                              child: Container(
                                width: 300,
                                height: 300,
                                color: Colors.white,
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 220,
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
                                            validator: (v){
                                              final RegExp emailRegex = RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                                              );
                                              if (emailRegex.hasMatch(v!) == false){
                                                return 'Введите корректный E-mail';
                                              }
                                              if (v.trim().isEmpty){
                                                return 'Это поле не может быть пустым';
                                              }
                                            },
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              hintText: 'Email ученика',
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
                                      ),
                                      SizedBox(height: 20,),
                                      SizedBox(
                                        width: 220,
                                        height: 60,
                                        child: button(
                                            onClick: () async {
                                              if(formKey.currentState!.validate() == true){
                                                var doc = await FirebaseFirestore.instance.collection('groups').doc(id).get();
                                                var list = doc.data()!['students'];
                                                print('Old list: $list');
                                                list.add({'email': emailController.text});
                                                print('New list: $list');

                                                await FirebaseFirestore.instance.collection('groups').doc(id).update({
                                                  'students': list,
                                                });
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            text: 'Пригласить'
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    },
                    text: 'Пригласить ученика'
                ),
              ),
              body: Container(
                width: 900,
                height: 550,
                color: blue,
                child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (ctx, count){
                      return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(300)),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: yellow,
                                child: Center(child: Icon(Icons.person, color: Colors.white,)),
                              ),
                            ),
                            title: Text('${students[count]['email']}', style: navTxt(fontSize: 20, weight: FontWeight.bold, color: dark),),
                            trailing: InkResponse(
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text('Вы точно хотите удалить пользователя ${students[count]['email']} из группы?'),
                                        actions: [
                                          TextButton(onPressed: () async {
                                            var doc = await FirebaseFirestore.instance.collection('groups').doc(id).get();
                                            var list = doc.data()!['students'];
                                            list.removeAt(count);

                                            print('New list: $list');

                                            await FirebaseFirestore.instance.collection('groups').doc(id).update({
                                              'students': list,
                                            });
                                            Navigator.of(context).pop();
                                          }, child: Text('Да')),
                                          TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Отмена'))
                                        ],
                                      );
                                    }
                                );
                              },
                              child: Icon(Icons.delete, color: pink, size: 30,),
                            ),

                          ),
                      );
                    }
                ),
              ),
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText('Нет добавленных учеников', style: offerTxt(color: dark, size: 48),),
              SizedBox(height: 20,),
              button(
                  onClick: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return Dialog(
                            child: Container(
                              width: 300,
                              height: 300,
                              color: Colors.white,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 220,
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
                                          validator: (v){
                                            final RegExp emailRegex = RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                                            );
                                            if (emailRegex.hasMatch(v!) == false){
                                              return 'Введите корректный E-mail';
                                            }
                                            if (v.trim().isEmpty){
                                              return 'Это поле не может быть пустым';
                                            }
                                          },
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            hintText: 'Email ученика',
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
                                    ),
                                    SizedBox(height: 20,),
                                    SizedBox(
                                      width: 220,
                                      height: 60,
                                      child: button(
                                          onClick: () async {
                                            if(formKey.currentState!.validate() == true){
                                              var doc = await FirebaseFirestore.instance.collection('groups').doc(id).get();
                                              var list = doc.data()!['students'];
                                              print('Old list: $list');
                                              list.add({'email': emailController.text});
                                              print('New list: $list');

                                              await FirebaseFirestore.instance.collection('groups').doc(id).update({
                                                'students': list,
                                              });
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          text: 'Пригласить'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    );
                  },
                  text: 'Пригласить ученика'
              )

            ],
          );

        }else if (!snap.hasData || !group.exists){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText('Нет добавленных учеников', style: offerTxt(color: dark, size: 48),),
              SizedBox(height: 20,),
              button(
                  onClick: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return Dialog(
                            child: Container(
                              width: 300,
                              height: 300,
                              color: Colors.white,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 220,
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
                                          validator: (v){
                                            final RegExp emailRegex = RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                                            );
                                            if (emailRegex.hasMatch(v!) == false){
                                              return 'Введите корректный E-mail';
                                            }
                                            if (v.trim().isEmpty){
                                              return 'Это поле не может быть пустым';
                                            }
                                          },
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            hintText: 'Email ученика',
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
                                    ),
                                    SizedBox(height: 20,),
                                    SizedBox(
                                      width: 220,
                                      height: 60,
                                      child: button(
                                          onClick: () async {
                                            if(formKey.currentState!.validate() == true){
                                              var doc = await FirebaseFirestore.instance.collection('groups').doc(id).get();
                                              var list = doc.data()!['students'];
                                              print('Old list: $list');
                                              list.add({'email': emailController.text});
                                              print('New list: $list');

                                              await FirebaseFirestore.instance.collection('groups').doc(id).update({
                                                'students': list,
                                              });
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          text: 'Пригласить'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    );
                  },
                  text: 'Пригласить ученика'
              )

            ],
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      }
  );
}



class Files extends StatefulWidget {
  Files({required this.id, required this.isTeacher});
  final String id;
  final bool isTeacher;
  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {

  TextEditingController taskName = TextEditingController();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('groups').doc(id).collection('lessons').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap){
          var tasks = snap.data!.docs;
          if(snap.hasData && tasks.isNotEmpty){


            return Center(
              child: SizedBox(
                width: 900,
                height: 550,
                child: Scaffold(
                  floatingActionButton: widget.isTeacher == true ? SizedBox(
                    width: 250,
                    height: 60,
                    child: button(onClick: (){
                      showDialog(
                          context: context,
                          builder: (ctx){
                            return Dialog(
                              child: SizedBox(
                                width: 500,
                                height: 500,
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
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
                                              validator: (v){
                                                if (v!.trim().isEmpty){
                                                  return 'Это поле не может быть пустым';
                                                }
                                              },
                                              controller: taskName,
                                              decoration: InputDecoration(
                                                hintText: 'Название задания',
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
                                        ),
                                        SizedBox(height: 20,),
                                        SizedBox(
                                          width: 220,
                                          height: 60,
                                          child: button(
                                              onClick: () async {
                                                if(formKey.currentState!.validate() == true){
                                                  var newLessonId = FirebaseFirestore.instance.collection('groups').doc(id).collection('lessons').doc().id;
                                                  await FirebaseFirestore.instance.collection('groups').doc(id).collection('lessons').doc(newLessonId).set({
                                                    'id': newLessonId,
                                                    'title': taskName.text,
                                                    'words': [],
                                                  });
                                                  context.pop();
                                                  context.goNamed('lesson_detail', pathParameters: {'groupId': id, 'lessonId': newLessonId});
                                                }
                                              },
                                              text: 'Создать задание'
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    }, text: 'Добавить задание'),
                  ) : SizedBox.shrink(),
                  body: Container(
                    width: 900,
                    height: 550,
                    color: blue,
                    child: GridView.builder(
                        itemCount: tasks.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                        ),
                        itemBuilder: (context, index){
                          return InkResponse(
                            onTap: (){
                              context.goNamed('task_detail', pathParameters: {'groupId': id, 'lessonReadyId': tasks[index]['id']});
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Icon(Icons.file_copy, size: 70, color: nightBlue,),
                                SizedBox(height: 10,),
                                Text(tasks[index]['title'], maxLines: 2, overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ),
            );
          }else if (!snap.hasData || tasks.isEmpty){
            return Center(
              child: SizedBox(
                width: 900,
                height: 550,
                child: Scaffold(
                  body: Container(
                    color: blue,
                    width: 900,
                    height: 550,
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText('Нет заданий', style: offerTxt(color: dark, size: 48),),
                            SizedBox(height: 20,),
                            if (widget.isTeacher == true)
                              button(
                                  onClick: () async {
                                    showDialog(
                                        context: context,
                                        builder: (ctx){
                                          return Dialog(
                                            child: SizedBox(
                                              width: 500,
                                              height: 500,
                                              child: Form(
                                                key: formKey,
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
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
                                                            validator: (v){
                                                              if (v!.trim().isEmpty){
                                                                return 'Это поле не может быть пустым';
                                                              }
                                                            },
                                                            controller: taskName,
                                                            decoration: InputDecoration(
                                                              hintText: 'Название задания',
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
                                                      ),
                                                      SizedBox(height: 20,),
                                                      SizedBox(
                                                        width: 220,
                                                        height: 60,
                                                        child: button(
                                                            onClick: () async {
                                                              if(formKey.currentState!.validate() == true){
                                                                var newLessonId = FirebaseFirestore.instance.collection('groups').doc(id).collection('lessons').doc().id;
                                                                await FirebaseFirestore.instance.collection('groups').doc(id).collection('lessons').doc(newLessonId).set({
                                                                  'id': newLessonId,
                                                                  'title': taskName.text,
                                                                  'words': [],
                                                                });
                                                                context.pop();
                                                                context.goNamed('lesson_detail', pathParameters: {'groupId': id, 'lessonId': newLessonId});
                                                              }
                                                            },
                                                            text: 'Создать задание'
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                  },
                                  text: 'Создать задание'
                              )
                          ],
                        )
                    ),
                  ),
                ),
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }
}

