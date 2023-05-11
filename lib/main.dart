import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uchiru/presentation/SignUpScreen.dart';
import 'package:uchiru/presentation/create_crossword_page.dart';
import 'package:uchiru/presentation/crosswordPage.dart';
import 'package:uchiru/presentation/group_detail_page.dart';
import 'package:uchiru/presentation/home_page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uchiru/presentation/materials.dart';
import 'package:uchiru/presentation/requests_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyD5Wv3Sc76M7CEOcV1MOA-b6skVvn1QzjI',
      appId: '1:13901897122:web:970f27c78ff67b9b5d26fb',
      messagingSenderId: '13901897122',
      projectId: 'crosswordgen-6517e',
      authDomain: 'crosswordgen-6517e.firebaseapp.com',
      storageBucket: 'crosswordgen-6517e.appspot.com',
    )
  );
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  if (firebaseAuth is FirebaseAuthWeb){
    firebaseAuth.setPersistence(Persistence.SESSION);
  }
  runApp(MyApp());
}

final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          name: '/',
          path: '/',
          builder: (BuildContext context, GoRouterState state){
            return const MyHomePage();
          },
      ),
      GoRoute(
          name: '/platform',
          path: '/platform',
          builder: (context, builder){
            return const Groups();
          },
          routes: [
            GoRoute(
                name: 'groups_detail',
                path: ':groupId',
                builder: (context, state) => GroupsDetail(
                    id: state.pathParameters['groupId']!
                ),
                routes: [
                  GoRoute(
                      path: 'lesson_:lessonId',
                      name: 'lesson_detail',
                      builder: (context, state) => CreateCrossword(
                        id: state.pathParameters['groupId']!,
                        lessonID: state.pathParameters['lessonId']!,
                      )
                  ),
                  GoRoute(
                      path: ':lessonReadyId',
                      name: 'task_detail',
                      builder: (context, state) => CrosswordPage(
                        groupId: state.pathParameters['groupId']!,
                        taskID: state.pathParameters['lessonReadyId']!,
                      )
                  )
                ]
            ),
          ]
      ),
      GoRoute(
        name: '/signup',
        path: '/signup',
        builder: (context, builder){
          return SignUp();
        },
      ),
      GoRoute(
        name: '/dashboard',
        path: '/dashboard',
        builder: (context, builder){
          return RequestsScreen();
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, builder){
          return RequestsScreen();
        },
      ),


    ]
);


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return MaterialApp.router(
      title: 'Учимся.ру',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      // routerDelegate: appRouter.delegate(),
      // routeInformationParser: appRouter.defaultRouteParser(),
      routerConfig: _router,


    );
  }
}


