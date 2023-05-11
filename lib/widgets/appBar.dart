import 'dart:ui';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:uchiru/presentation/SignUpScreen.dart';
import '../classes/Request.dart';
import '../styles/styles.dart';
import 'onHoverWidget.dart';

class myAppBar extends StatefulWidget implements PreferredSizeWidget{


  const myAppBar({
    Key? key,

  }) : super(key: key);

  @override
  _myAppBarState createState() => _myAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(70.0);


}
final FirebaseAuth auth = FirebaseAuth.instance;
int newMessagesCount = 0;
class _myAppBarState extends State<myAppBar> with SingleTickerProviderStateMixin{

  String profilePic = '';
  String? username;
  String role = '';
  List<Request> requests = [];

  Future<void> getUserInfo() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get();
    setState(() {
      username = doc.data()!['username'] ?? 'No name';
      profilePic = doc.data()!['imgUrl'];
      role = doc.data()!['role'];
    });
  }

  Future<List<Request>> getRequests() async {
    if(role == 'admin'){
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('new_requests')
          .get();
      return querySnapshot.docs.map((doc) {
        final request = Request(
            doc.id,
            doc['name'],
            doc['phone'],
            doc['email'],
            doc['category'],
            doc['message'],
            doc['date'],
            doc['status']
        );
        if (request.status == 'new') {
          newMessagesCount++;
        }
        return request;
      }).toList();
    }else{
      return [];
    }
  }
  Future <myAppBar> refresh() async{

    
    return myAppBar();
  }
  
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return auth.currentUser != null ? StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(
            auth.currentUser!.uid).collection('new_requests').snapshots(),
        builder: (ctx, snap){

          if(snap.hasData){
            return Container(
              decoration: BoxDecoration(
                color: nightBlue,
              ),
              child: Center(
                child: Container(
                  width: 1200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          context.goNamed('/');
                        },
                        child: SvgPicture.asset('assets/logo.svg', width: 100, height: 40,),
                      ),

                      Container(
                        width: auth.currentUser == null ? 591 : 700,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OnHoverWidget(
                                builder: (bool isHovered){
                                  return InkResponse(
                                    onTap: (){
                                      context.goNamed('/');
                                    },
                                    child: Text('Главная', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                                  );
                                }
                            ),

                            OnHoverWidget(
                                builder: (bool isHovered){
                                  return InkResponse(
                                    onTap: (){},
                                    child: Text('Контакты', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                                  );
                                }
                            ),

                            OnHoverWidget(
                                builder: (bool isHovered){
                                  return InkResponse(
                                    onTap: (){},
                                    child: Text('О платформе', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                                  );
                                }
                            ),

                            OnHoverWidget(
                                builder: (bool isHovered){
                                  return auth.currentUser == null ? InkResponse(
                                    onTap: (){
                                      context.goNamed('/signup');
                                    },
                                    child: Text('Вход', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                                  ) : DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        customButton: SizedBox(
                                          width: 180,
                                          child: Center(
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    color: lightBlue,
                                                    child: Center(
                                                      child: profilePic == ''
                                                          ? Icon(Icons.person, size: 30, color: nightBlue,)
                                                          : Image.network(profilePic!, fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                ),
                                                snap.data!.docs.isNotEmpty && role == 'admin'
                                                    ? Padding(
                                                  padding: EdgeInsets.only(left: 30),
                                                  child: Container(
                                                    width: 25,
                                                    height: 25,
                                                    decoration: const BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.all(Radius.circular(50))
                                                    ),
                                                    child: Center(
                                                      child: Icon(Icons.notifications, color: Colors.white, size: 15,),
                                                    ),
                                                  ),
                                                )
                                                    : SizedBox.shrink(),

                                              ],
                                            ),
                                          ),
                                        ),
                                        items: [
                                          ...MenuItems.routeItem.map(
                                                (item) => DropdownMenuItem<MenuItem>(
                                                enabled: role == 'admin' ? true : false,
                                                value: item,
                                                child: Container(
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: username == null
                                                      ? CircularProgressIndicator()
                                                      : Text(username ?? '...',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: navTxt(
                                                          fontSize: 20,
                                                          weight: FontWeight.w600,
                                                          color: dark)),

                                                )),
                                          ),
                                          if(role == 'admin')
                                            ...MenuItems.messages.map(
                                                    (item) => DropdownMenuItem<MenuItem>(
                                                    value: item,
                                                    child: MenuItems.buildItem(item)
                                                )
                                            ),

                                          // const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
                                          ...MenuItems.secondItems.map(
                                                (item) => DropdownMenuItem<MenuItem>(
                                              value: item,
                                              child: MenuItems.buildItem(item),
                                            ),
                                          ),
                                          ...MenuItems.thirdItems.map(
                                                (item) => DropdownMenuItem<MenuItem>(
                                              value: item,
                                              child: MenuItems.buildItem(item),
                                            ),
                                          ),
                                        ],
                                        buttonStyleData: ButtonStyleData(
                                            padding: EdgeInsets.only(right: 60)
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          width: 180,
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
                                        ),
                                        onChanged: (value) {
                                          MenuItems.onChanged(context, value as MenuItem);
                                        },

                                      )
                                  );
                                }
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }else if (!snap.hasData){
            return Container(
              decoration: BoxDecoration(
                color: nightBlue,
              ),
              child: Center(
                child: Container(
                  width: 1200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){},
                        child: SvgPicture.asset('assets/logo.svg', width: 100, height: 40,),
                      ),

                      Container(
                        width: auth.currentUser == null ? 591 : 700,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OnHoverWidget(
                                builder: (bool isHovered){
                                  return InkResponse(
                                    onTap: (){},
                                    child: Text('Главная', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                                  );
                                }
                            ),

                            OnHoverWidget(
                                builder: (bool isHovered){
                                  return InkResponse(
                                    onTap: (){},
                                    child: Text('Контакты', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                                  );
                                }
                            ),

                            OnHoverWidget(
                                builder: (bool isHovered){
                                  return InkResponse(
                                    onTap: (){},
                                    child: Text('О платформе', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                                  );
                                }
                            ),

                            OnHoverWidget(
                                builder: (bool isHovered){
                                  return auth.currentUser == null ? InkResponse(
                                    onTap: (){
                                      context.goNamed('/signup');
                                    },
                                    child: Text('Вход', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                                  ) : SizedBox(
                                    width: 180,
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          color: lightBlue,
                                          child: Center(
                                            child: profilePic == ''
                                                ? Icon(Icons.person, size: 30, color: nightBlue,)
                                                : Image.network(profilePic!, fit: BoxFit.cover,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }else{
            return Container(
              decoration: BoxDecoration(
                color: nightBlue,
              ),
            );
          }
        }
    )
    : Container(
      decoration: BoxDecoration(
        color: nightBlue,
      ),
      child: Center(
        child: Container(
          width: 1200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){},
                child: SvgPicture.asset('assets/logo.svg', width: 100, height: 40,),
              ),

              Container(
                width: auth.currentUser == null ? 591 : 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OnHoverWidget(
                        builder: (bool isHovered){
                          return InkResponse(
                            onTap: (){},
                            child: Text('Главная', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                          );
                        }
                    ),

                    OnHoverWidget(
                        builder: (bool isHovered){
                          return InkResponse(
                            onTap: (){},
                            child: Text('Контакты', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                          );
                        }
                    ),

                    OnHoverWidget(
                        builder: (bool isHovered){
                          return InkResponse(
                            onTap: (){print(auth.currentUser);},
                            child: Text('О платформе', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                          );
                        }
                    ),

                    OnHoverWidget(
                        builder: (bool isHovered){
                          return auth.currentUser == null ? InkResponse(
                            onTap: (){
                              context.goNamed('/signup');


                            },
                            child: Text('Вход', style: navTxt(fontSize: 20, weight: FontWeight.w600, color: isHovered ? blue : Colors.white),),
                          ) : const SizedBox.shrink();
                        }
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



}





class MenuItem {
  final String text;


  const MenuItem({
    required this.text,

  });


}


class MenuItems {

  static const List<MenuItem> secondItems = [settings, history, author];
  static const List<MenuItem> thirdItems = [exit];
  static const List<MenuItem> messages = [message];
  static const List<MenuItem> routeItem = [route];

  static const settings = MenuItem(text: 'Настройки',);
  static const history = MenuItem(text: 'Платформа',);
  static const author = MenuItem(text: 'Стать учителем',);
  static const exit = MenuItem(text: 'Выход',);
  static const message = MenuItem(text: 'Заявки',);
  static const route = MenuItem(text: 'da',);

  static Widget buildItem(MenuItem item) {
    if(item.text == 'Заявки'){
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(
              auth.currentUser!.uid).collection('new_requests').snapshots(),
          builder: (ctx, snap){
            if(snap.hasData || !snap.hasData){
              return Row(
                children: [

                  const SizedBox(
                    width: 10,
                  ),

                  Text(
                    item.text,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  snap.data!.docs.isEmpty
                      ? SizedBox.shrink() : Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: Center(
                      child: Text(snap.data!.docs.length.toString() ?? '...', style: navTxt(fontSize: 14, weight: FontWeight.w500, color: Colors.white),),
                    ),
                  )
                ],
              );
            }else{
              return Row(
                children: [

                  const SizedBox(
                    width: 10,
                  ),

                  Text(
                    item.text,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Container(
                    width: 25,
                    height: 25,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              );
            }
          }
      );
    }else{
      return Row(
        children: [

          const SizedBox(
            width: 10,
          ),

          Text(
            item.text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      );
    }
  }
  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {

      case MenuItems.settings:
      //Do something

        break;
      case MenuItems.history:
        context.goNamed('/platform');

        break;
      case MenuItems.author:
      //Do something
        break;

      case MenuItems.exit:
        FirebaseAuth.instance.signOut();
        context.goNamed('/');
        break;

      case MenuItems.route:

        break;

      case MenuItems.message:
        context.goNamed('/dashboard');

        break;
    }
  }
}


