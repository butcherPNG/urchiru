


import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uchiru/presentation/group_detail_page.dart';
import 'package:uchiru/widgets/appBar.dart';

import '../styles/styles.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});





  @override
  State<Groups> createState() => _GroupsState();
}


class _GroupsState extends State<Groups> with TickerProviderStateMixin {

  TextEditingController groupNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void initState() {

    super.initState();
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
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('groups').snapshots(),
                  builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snap){
                    var groups = snap.data!.docs.where((doc) =>
                    doc.get('teacher') == FirebaseAuth.instance.currentUser!
                        .email).toList();
                    if(snap.hasData){


                      return groups.isNotEmpty
                      ? Center(
                        child: SizedBox(
                          width: 1200,
                          height: MediaQuery.of(context).size.height - 100,

                          child: Scaffold(
                            floatingActionButton: SizedBox(
                              width: 200,
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
                                                            if (v!.trim().isEmpty){
                                                              return 'Это поле не может быть пустым';
                                                            }
                                                          },
                                                          controller: groupNameController,
                                                          decoration: InputDecoration(
                                                            hintText: 'Имя группы',
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
                                                              var id = FirebaseFirestore.instance.collection('groups').doc().id;
                                                              await FirebaseFirestore.instance.collection('groups').doc(id).set({
                                                                'id': id,
                                                                'name': groupNameController.text,
                                                                'teacher': FirebaseAuth.instance.currentUser!.email,
                                                                'students': [],
                                                              });
                                                              Navigator.of(context).pop();
                                                            }
                                                          },
                                                          text: 'Создать'
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
                                  text: 'Создать группу'),
                            ),
                            body: Container(
                              width: 1200,
                              height: MediaQuery.of(context).size.height - 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: blue,
                              ),
                              child: ListView.builder(
                                itemCount: groups.length,
                                itemBuilder: (ctx, index){
                                  return Padding(
                                    padding: EdgeInsets.all(20),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(300)),
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          color: yellow,
                                          child: Center(child: Icon(Icons.group, color: Colors.white,)),
                                        ),
                                      ),
                                      title: Text(groups[index]['name'], style: navTxt(fontSize: 20, weight: FontWeight.bold, color: dark),),
                                      subtitle: Text('Учеников: ${groups[index]['students'].length}', style: navTxt(fontSize: 16, weight: FontWeight.w400, color: dark),),
                                      onTap: (){
                                        context.goNamed('groups_detail', pathParameters: {'groupId': groups[index]['id']});
                                        // AutoRouter.of(context).push(GroupsDetail(id: groups[index]['id']).toRoute());

                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ),
                      )
                      : Center(
                        child: Container(
                            width: 1200,
                            height: MediaQuery.of(context).size.height - 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: blue,
                            ),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SelectableText('Вы не создали ни одной группы', style: offerTxt(color: dark, size: 48),),
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
                                                                  if (v!.trim().isEmpty){
                                                                    return 'Это поле не может быть пустым';
                                                                  }
                                                                },
                                                                controller: groupNameController,
                                                                decoration: InputDecoration(
                                                                  hintText: 'Имя группы',
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
                                                                    var id = FirebaseFirestore.instance.collection('groups').doc().id;
                                                                    await FirebaseFirestore.instance.collection('groups').doc(id).set({
                                                                      'id': id,
                                                                      'name': groupNameController.text,
                                                                      'teacher': FirebaseAuth.instance.currentUser!.email,
                                                                      'students': [],
                                                                    });
                                                                    Navigator.of(context).pop();
                                                                  }
                                                                },
                                                                text: 'Создать'
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
                                        text: 'Создать группу'
                                    )

                                  ],
                                )
                            )
                        ),
                      );
                    }else if (!snap.hasData || groups.isEmpty){
                      return Center(
                        child: Container(
                            width: 1200,
                            height: MediaQuery.of(context).size.height - 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: blue,
                            ),
                            child: Center(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              SelectableText('Вы не создали ни одной группы', style: offerTxt(color: dark, size: 48),),
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
                                                              if (v!.trim().isEmpty){
                                                                return 'Это поле не может быть пустым';
                                                              }
                                                            },
                                                            controller: groupNameController,
                                                            decoration: InputDecoration(
                                                              hintText: 'Имя группы',
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
                                                                var id = FirebaseFirestore.instance.collection('groups').doc().id;
                                                                await FirebaseFirestore.instance.collection('groups').doc(id).set({
                                                                  'id': id,
                                                                  'name': groupNameController.text,
                                                                  'teacher': FirebaseAuth.instance.currentUser!.email,
                                                                  'students': [],
                                                                });
                                                                Navigator.of(context).pop();
                                                              }
                                                            },
                                                            text: 'Создать'
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
                                  text: 'Создать группу'
                                )

                              ],
                            )
                          )
                        ),
                      );
                    }else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                  }
              )
              : StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('groups').snapshots(),
                  builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snap){
                    var groups = snap.data!.docs.where((doc) =>
                        (doc.get('students') as List<dynamic>).any((student) => student['email'] == FirebaseAuth.instance.currentUser!.email)
                    ).toList();
                    if(snap.hasData && groups.isNotEmpty){
                      return Center(
                        child: SizedBox(
                            width: 1200,
                            height: MediaQuery.of(context).size.height - 100,

                            child: Scaffold(
                              body: Container(
                                width: 1200,
                                height: MediaQuery.of(context).size.height - 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: blue,
                                ),
                                child: ListView.builder(
                                  itemCount: groups.length,
                                  itemBuilder: (ctx, index){
                                    return Padding(
                                      padding: EdgeInsets.all(20),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(300)),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            color: yellow,
                                            child: Center(child: Icon(Icons.group, color: Colors.white,)),
                                          ),
                                        ),
                                        title: Text(groups[index]['name'], style: navTxt(fontSize: 20, weight: FontWeight.bold, color: dark),),
                                        subtitle: Text('Учеников: ${groups[index]['students'].length}', style: navTxt(fontSize: 16, weight: FontWeight.w400, color: dark),),
                                        onTap: (){
                                          context.goNamed('groups_detail', pathParameters: {'groupId': groups[index]['id']});
                                          // AutoRouter.of(context).push(GroupsDetail(id: groups[index]['id']).toRoute());

                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                        ),
                      );
                    }else if (!snap.hasData || groups.isEmpty){
                      return Center(
                        child: Container(
                            width: 1200,
                            height: MediaQuery.of(context).size.height - 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: blue,
                            ),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SelectableText('Вы не состоите ни в одной группе', style: offerTxt(color: dark, size: 48),),
                                    SizedBox(height: 20,),
                                    SelectableText('Свяжитесь с Вашим учителем для получения доступа к заданиям', style: navTxt(color: dark, fontSize: 24, weight: FontWeight.w500),),

                                  ],
                                )
                            )
                        ),
                      );
                    }else{
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  }
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

