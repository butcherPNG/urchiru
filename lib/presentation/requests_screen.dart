import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uchiru/presentation/requests_bloc/requests_bloc.dart';
import 'package:uchiru/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/controller.dart';
import '../classes/Request.dart';
import '../widgets/appBar.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class RequestsScreen extends StatefulWidget {

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  late bool isAdmin;
  Future<bool> checkPermissions() async {
    if(FirebaseAuth.instance.currentUser != null){
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
        value['role'] == 'admin' ? isAdmin = true : isAdmin = false;
      });

    }else{
      isAdmin = false;
    }
    return isAdmin;
  }

  Future<void> loadRequests() async {
    // Load all requests for the current user
    final currentUser = FirebaseAuth.instance.currentUser;
    final userRequestsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('requests');
    final newRequestsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('new_requests');
    final requestsSnap = await userRequestsRef.orderBy('date', descending: true).get();
    final newRequestsSnap = await newRequestsRef.orderBy('date', descending: true).get();

    // Combine the requests and new requests into one list
     allRequests = [
       ...newRequestsSnap.docs.map((doc) => Request(
         doc.id,
         doc['name'],
         doc['phone'],
         doc['email'],
         doc['category'],
         doc['message'],
         doc['date'],
         doc['status'],
       )),
      ...requestsSnap.docs.map((doc) => Request(
        doc.id,
        doc['name'],
        doc['phone'],
        doc['email'],
        doc['category'],
        doc['message'],
        doc['date'],
        doc['status'],
      )),

    ];

    // Update the stream with the new data
    _requestController.add(allRequests!);
  }




  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: myAppBar(),
        body:
        FirebaseAuth.instance.currentUser != null ?
        FutureBuilder(
            future: checkPermissions().then((isAdmin) {
              if (isAdmin) {
                loadRequests();
              }
            }),
            builder: (ctx, snap){
              if (snap.connectionState == ConnectionState.done) {

                return isAdmin == true ?
                Center(
                  child: Container(
                    width: 1200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        requests_list(context),
                        selected_requset(context),
                      ],
                    ),
                  ),
                )
                    : Center(child: SelectableText('В доступе отказано', style: offerTxt(color: dark, size: 48),),);
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
        )
            : Center(child: SelectableText('В доступе отказано', style: offerTxt(color: dark, size: 48),),),
      );
    }

  }
StreamController<List<Request>> _requestController = StreamController<List<Request>>.broadcast(sync: true);

Widget requests_list(BuildContext context) {
  return StreamBuilder<List<Request>>(
      stream: _requestController.stream,
      builder: (BuildContext context, AsyncSnapshot<List<Request>> snap) {
        if (snap.hasData) {
          return Container(
              width: 250,
              height: MediaQuery.of(context).size.height - 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: blue,
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ListView.builder(
                      itemCount: allRequests?.length,
                      itemBuilder: (ctx, index){

                        return ListTile(
                          title: Text(
                            "${allRequests![index].name}, ${DateFormat('dd.MM').format(allRequests![index].date.toDate())} в ${DateFormat('HH:mm').format(allRequests![index].date.toDate())}"),
                        subtitle: Text(allRequests![index].message, maxLines: 1, overflow: TextOverflow.ellipsis,),
                          onTap: (){
                            selectedRequestCubit.select(index);
                          },
                          trailing:
                          allRequests![index].status == 'new'
                          ? Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              color: Colors.red,
                            ),
                            child: Center(child: Text('Новая', style: blockTxt(color: Colors.white, size: 16),),),
                          )
                          : SizedBox.shrink(),
                        );
                      }
                  )),
              );
        } else if (!snap.hasData) {
          return Container(
            width: 250,
            height: MediaQuery.of(context).size.height - 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: blue,
            ),
            child: Center(
              child: InkResponse(
                onTap: (){print(allRequests);},
                child: Text(
                  'Заявок еще нет!',
                  style: blockTxt(color: dark),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}
List<Request>? allRequests;
List<Request>? sorted;
int? selectedRequset;
Widget selected_requset(BuildContext context) {
  return BlocBuilder<SelectedRequestCubit, int?>(
    bloc: selectedRequestCubit,
    builder: (context, selectedIndex) {
      return Container(
        width: 900,
        height: MediaQuery.of(context).size.height - 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: blue,
        ),
        child: Center(
          child: selectedIndex != null ?
          Container(
            width: 700,
            child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      "Имя: ${allRequests![selectedIndex].name}",
                      style: navTxt(
                        color: dark,
                        fontSize: 24,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SelectableText(
                      "Почта: ${allRequests![selectedIndex].email}",
                      style: navTxt(
                        color: dark,
                        fontSize: 24,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SelectableText(
                      "Номер телефона: ${allRequests![selectedIndex].phone}",
                      style: navTxt(
                        color: dark,
                        fontSize: 24,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SelectableText(
                      "Категория: ${allRequests![selectedIndex].category}",
                      style: navTxt(
                        color: dark,
                        fontSize: 24,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SelectableText(
                      "Сообщение:",
                      style: navTxt(
                        color: dark,
                        fontSize: 24,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SelectableText(
                      allRequests![selectedIndex].message,
                      style: navTxt(
                        color: dark,
                        fontSize: 18,
                        weight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20,),
                    allRequests![selectedIndex].status == 'new'
                        ? button(onClick: () async {
                      await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('new_requests')
                                      .doc(allRequests![selectedIndex].id)
                                      .update({'status': 'checked'});
                      DocumentSnapshot snap = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth
                          .instance.currentUser!.uid)
                          .collection('new_requests')
                          .doc(allRequests![selectedIndex].id).get();
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth
                          .instance.currentUser!.uid)
                          .collection('requests')
                          .doc(allRequests![selectedIndex].id).set(snap.data() as Map<String, dynamic>);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth
                          .instance.currentUser!.uid)
                          .collection('new_requests')
                          .doc(allRequests![selectedIndex].id).delete().then((value){
                            html.window.location.reload();

                      });



                                }, text: 'Отметить как просмотренное')
                        : SizedBox.shrink()
                  ],
                ),
            ),
          )
          : Text(
            'Выберете заявку',
            style: navTxt(
              color: dark,
              fontSize: 32,
              weight: FontWeight.bold,
            ),
          ),
        ),
      );
    },
  );
}





final selectedRequestCubit = SelectedRequestCubit();
class SelectedRequestCubit extends Cubit<int?> {
  SelectedRequestCubit() : super(null);

  void select(int? index) => emit(index);
}