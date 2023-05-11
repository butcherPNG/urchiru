
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/md5.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:uchiru/styles/styles.dart';


import '../models/DataBase.dart';

class SignUp extends StatefulWidget{
  @override
  _SignUpState createState() => _SignUpState();

}

class _SignUpState extends State<SignUp>{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String username = '';
  bool isAdmin = false;
  bool register = false;
  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String imgUrl = '';
  bool isLoading = false;


  @override

  Widget build(BuildContext context){
    return Scaffold(
     body: Center(
       child: Container(
         width: 502,
         child: Form(

             key: formKey,
             child: register == true ? Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 TextFormField(

                   decoration: InputDecoration(
                     labelText: 'Придумайте логин',
                     floatingLabelBehavior: FloatingLabelBehavior.always,
                     contentPadding: EdgeInsets.all(16),
                     fillColor: Colors.white,
                     filled: true,
                     counter: Offstage(),
                     errorStyle: TextStyle(fontSize: 12),
                     border: OutlineInputBorder(),
                   ),
                   validator: (v){
                     final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
                     if(v!.contains(validCharacters) == false) {
                       return 'Придумай что нибудь поинтереснее!';
                     }else if (v.length > 15){
                       return 'Зачем тебе столько много букв?';
                     }else if (v.length < 3) {
                       return 'Слишком короткий логин!';
                     }else if (v.isEmpty) {
                       return 'Введите логин епта!';
                     }
                   },
                   onChanged: (v){
                     if (v != null){
                       username = v;
                     }
                   },
                 ),
                 SizedBox(height: 16,),
                 TextFormField(

                   decoration: InputDecoration(
                     labelText: 'Ваш E-mail',
                     floatingLabelBehavior: FloatingLabelBehavior.always,
                     contentPadding: EdgeInsets.all(16),
                     fillColor: Colors.white,
                     filled: true,
                     counter: Offstage(),
                     errorStyle: TextStyle(fontSize: 12),
                     border: OutlineInputBorder(),
                   ),
                   validator: (string){
                     final RegExp emailRegex = RegExp(
                         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                     );
                     if (emailRegex.hasMatch(string!) == false){
                       return 'Введите нормальный E-mail';
                     }
                     if (string.isEmpty) return 'Введите E-mail';
                   },
                   onChanged: (v){
                     if (v.isNotEmpty){
                       emailController.text = v;
                     }
                   },
                 ),
                 SizedBox(height: 16,),
                 TextFormField(
                   obscureText: !_passwordVisible,
                   inputFormatters: [
                     LengthLimitingTextInputFormatter(32),
                   ],

                   decoration: InputDecoration(
                     labelText: 'Придумайте пароль',

                     floatingLabelBehavior: FloatingLabelBehavior.always,
                     contentPadding: EdgeInsets.all(16),
                     fillColor: Colors.white,
                     filled: true,
                     counter: Offstage(),
                     errorStyle: TextStyle(fontSize: 12),
                     border: OutlineInputBorder(),
                     suffixIcon: IconButton(
                       icon: Icon(
                         _passwordVisible
                             ? Icons.visibility
                             : Icons.visibility_off,

                       ),
                       onPressed: () {
                         setState(() {
                           _passwordVisible = !_passwordVisible;
                         });
                       },
                     ),

                   ),

                   validator: (v){
                     if (v!.length < 6){
                       return 'Пароль должен состоять не менее чем из 6 букв';
                     }
                     if (v.isEmpty){
                       return 'Введите пароль)';
                     }
                   },
                   onChanged: (v){
                     if (v.isNotEmpty){
                       passwordController.text = v;
                     }
                   },
                 ),
                 SizedBox(height: 20,),
                 ElevatedButton(
                     child: isLoading == false ? Text('Регистрация', style:
                     GoogleFonts.montserrat(
                         textStyle: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Colors.white,
                         )
                     ),)
                     : Center(child: CircularProgressIndicator(),),
                     style: ButtonStyle(
                       backgroundColor:  MaterialStateProperty.all(nightBlue),
                       minimumSize: MaterialStateProperty.all(const Size(502.0, 65.0)),

                       shape: MaterialStateProperty.all(
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                       ),
                     ),
                     onPressed: () async {
                       if (formKey.currentState!.validate() == true){
                          setState(() {
                            isLoading = true;
                          });
                         try {
                           await Authent()
                               .createUserWithEmailAndPassword(emailController.text, passwordController.text,
                               username, imgUrl,)
                               .then((value) async {
                             FirebaseAuth.instance.signInWithCredential(EmailAuthProvider.credential(
                               email: emailController.text.trim(),
                               password: passwordController.text.trim(),

                             ));
                             setState(() {
                               isLoading = false;
                             });
                             context.goNamed('/');
                           });
                         } on FirebaseException catch (e) {
                           setState(() {
                             isLoading = false;
                           });
                           if (e.code == 'weak-password'){
                             ScaffoldMessenger.of(context)
                                 .showSnackBar(const SnackBar(
                               content: Text('Password is weak'),
                             ));
                           }else if (e.code == 'email-already-in-use'){
                             ScaffoldMessenger.of(context)
                                 .showSnackBar(const SnackBar(
                               content: Text('Такой email уже используется!'),
                             ));
                           }
                         }

                       }

                     }
                 ),
                 SizedBox(height: 16,),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [

                     Text('Уже зарегистрированы?', style:
                     GoogleFonts.montserrat(
                         textStyle: TextStyle(
                           fontSize: 16,

                           color: Colors.black,
                         )
                     ),),
                     TextButton(
                         style: TextButton.styleFrom(
                           textStyle: const TextStyle(fontSize: 15),
                         ),
                         onPressed: (){
                           setState((){
                             register = false;
                           });
                         },
                         child: Text('Войти', style: GoogleFonts.montserrat(
                             textStyle: TextStyle(
                               fontSize: 16,


                             )
                         ),)
                     )
                   ],
                 ),
               ],
             ) :
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 35,),
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.all(16),
                    fillColor: Colors.white,
                    filled: true,
                    counter: Offstage(),
                    errorStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                  validator: (string){
                    final RegExp emailRegex = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                    );
                    if (emailRegex.hasMatch(string!) == false){
                      return 'Введите нормальный E-mail';
                    }
                    if (string.isEmpty) return 'Введите E-mail';
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  obscureText: !_passwordVisible,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(32),
                  ],
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Пароль',

                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.all(16),
                    fillColor: Colors.white,
                    filled: true,
                    counter: Offstage(),
                    errorStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,

                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),

                  ),

                  validator: (v){
                    if (v!.length < 6){
                      return 'Пароль должен состоять не менее чем из 6 букв';
                    }
                    if (v.isEmpty){
                      return 'Введите пароль)';
                    }
                  },
                ),

                SizedBox(height: 20,),

                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate() == true){
                      setState(() {
                        isLoading = true;
                      });
                      try{
                        await Authent().loginWithEmailAndPassword(emailController.text, passwordController.text).then((value){
                          setState(() {
                            isLoading = false;
                          });
                          context.goNamed('/');

                        });
                      } on FirebaseException catch (e){
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Неправильный логин или пароль!'),
                        ));
                      }

                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all(nightBlue),
                    minimumSize: MaterialStateProperty.all(const Size(502.0, 65.0)),

                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: isLoading == false ? Text('Войти', style:
                      GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                      ),)
                  : Center(child: CircularProgressIndicator(),),
                ),
                SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text('Еще не аккаунта?', style:
                    GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 16,

                          color: Colors.black,
                        )
                    )),
                    TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: (){
                          setState((){
                            register = true;
                          });
                        },
                        child: Text('Зарегистрироваться', style:
                        GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 16,


                            )
                        ))
                    )
                  ],
                ),
              ],
            )


         ),
         )
       )

    );
  }

}



class Authent{
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> getCurrentUser() async {
    return await auth.currentUser!;
  }

  Future<void> createUserWithEmailAndPassword(

      String email, String password,  String username, String imageUrl) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth is FirebaseAuthWeb){
      firebaseAuth.setPersistence(Persistence.SESSION);
    }
    final bytes = utf8.encode(password);
    final uint8List = Uint8List.fromList(bytes);
    final sha256 = SHA256Digest();
    final digest = sha256.process(uint8List);
    final pass = digest.toString();
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass);

    Map<String, dynamic> userInfoMap = {
      'email': email,
      'password': pass,
      'username': username,
      'imgUrl': imageUrl,
      'role': 'student',

    };

    if(userCredential != null){
      DatabaseMethods().addUserInfoToDB(auth.currentUser!.uid, userInfoMap);
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth is FirebaseAuthWeb){
      firebaseAuth.setPersistence(Persistence.SESSION);
    }
    final bytes = utf8.encode(password);
    final uint8List = Uint8List.fromList(bytes);
    final sha256 = SHA256Digest();
    final digest = sha256.process(uint8List);
    final pass = digest.toString();
    UserCredential userCredential =
    await auth.signInWithEmailAndPassword(email: email, password: pass);
  }

  Future<void> logout() async {
    await auth.signOut();

  }
}