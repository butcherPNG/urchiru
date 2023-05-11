

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:uchiru/styles/styles.dart';
import 'package:uchiru/widgets/panel.dart';

import '../../widgets/appBar.dart';
import '../../widgets/footer.dart';
import '../../widgets/process.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});





  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var phoneController = MaskedTextController(mask: '+7(000) 000-0000');
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int _counter = 0;
  final List<String> items = [
    'O платформе',
    'O регистрации и доступе',
    'Вопросы о оплате',
    'Вопросы о безопасности',
    'Другое',
  ];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: myAppBar(),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 548,
            color: nightBlue,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 80),
                child: Container(
                  width: 1200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 488,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [blue, lightBlue], // цвета градиента
                                ).createShader(bounds);
                              },
                              child: SelectableText(
                                'Обретай новые знания вместе с Учимся.ру', // текст
                                style: TextStyle(
                                  fontSize: 48.0,  // размер шрифта
                                  fontWeight: FontWeight.bold,  // насыщенность шрифта
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.manrope().fontFamily,// начальный цвет текста
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: 488,
                              child: SelectableText('Лучшая платформа для проведения занятий онлайн.', style: blockTxt(color: Colors.white, size: 24),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 36),
                            child: SizedBox(
                              width: 386,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  button(onClick: (){context.goNamed('/signup');}, text: 'Начать', color: lightBlue, width: 183, height: 45, txtStyle: navTxt(fontSize: 20, weight: FontWeight.w600, color: dark)),
                                  button(onClick: (){}, text: 'Подробнее', color: nightBlue, width: 183, height: 45, txtStyle: navTxt(fontSize: 20, weight: FontWeight.w600, color: lightBlue), border: true, borderColor: lightBlue),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Image.asset('assets/banner.png', width: 590, height: 376, fit: BoxFit.cover,),
                      )
                    ],
                  ),
                ),
              ),
            )
          ),
          SizedBox(height: 110,),
          Center(
            child: Container(
              width: 1200,
              child: StickyHeader(
                  overlapHeaders: true,
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              children: [
                                WidgetSpan(child: SelectableText('Что предлагает ', style: headerTxt(size: 40, color: dark),)),
                                WidgetSpan(
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 40),
                                          child: Container(
                                            width: 208,
                                            height: 15,
                                            child: SvgPicture.asset('assets/line.svg', fit: BoxFit.cover,),
                                          ),
                                        ),
                                        SelectableText('Учимся.ру', style: headerTxt(size: 40, color: blue),),
                                      ],
                                    )
                                )
                              ]
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: SelectableText('Начните работу прямо сейчас!', style: blockTxt(size: 24, color: dark),),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 36),
                          child: button(onClick: (){context.goNamed('/signup');}, text: 'Начать', color: nightBlue, width: 183, height: 45, txtStyle: navTxt(fontSize: 20, weight: FontWeight.w600, color: Colors.white)),
                      )
                    ],
                  ),
                  content: Padding(
                    padding: const EdgeInsets.only(left: 610),
                    child: Container(
                        width: 590,
                        child: Column(
                          children: [
                            MyPanel(
                                header: 'Создание учебных материалов для школьных предметов',
                                content: 'Пользователи могут создавать и редактировать учебные материалы в разных форматах (текст, графика, видео и др.), добавлять вопросы и тесты для проверки знаний.'
                            ),
                            MyPanel(
                                header: 'Проведение онлайн-уроков для учеников',
                                content: 'Платформа позволяет организовывать онлайн-уроки с помощью видео-конференций и интерактивных инструментов для участников.'
                            ),
                            MyPanel(
                                header: 'Создание и выдача домашних заданий',
                                content: 'Пользователи могут создавать домашние задания и выдавать их ученикам на выполнение.'
                            ),
                            MyPanel(
                                header: 'Автоматизированная проверка домашних заданий',
                                content: 'Система автоматически проверяет ответы учеников на домашние задания и генерирует результаты.'
                            ),
                            MyPanel(
                                header: 'Доступ к обучающим видеоурокам и тестам',
                                content: 'Пользователи могут получить доступ к большому количеству обучающих видеоуроков и тестов по различным школьным предметам.'
                            ),
                            MyPanel(
                                header: 'Система мониторинга успеваемости учеников и генерация отчетов для родителей и учителей',
                                content: 'Платформа предоставляет учителям и родителям возможность отслеживать успеваемость учеников, а также генерировать отчеты по их прогрессу и результатам.'
                            ),
                          ],
                        )
                    ),
                  )
              ),
            ),
          ),
          SizedBox(height: 110,),
          Center(
            child: Container(
              width: 1200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText('Для кого', style:  headerTxt(size: 40, color: dark),),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cards(
                          backgr: nightBlue,
                          header: 'Школы',
                          content: 'Повышение качества образования, автоматизация учета успеваемости.',
                          img: SvgPicture.asset('assets/school.svg', width: 45, height: 44,),
                          tap: (){context.goNamed('/signup');}
                      ),
                      cards(
                          backgr: nightBlue,
                          header: 'Репетиторы',
                          content: 'Расширение клиентской базы, удобство планирования занятий.',
                          img: SvgPicture.asset('assets/teacher.svg', width: 30, height: 44,),
                          tap: (){context.goNamed('/signup');}
                      ),
                      cards(
                          backgr: nightBlue,
                          header: 'Ученики',
                          content: 'Доступность образования, персонализированное обучение.',
                          img: SvgPicture.asset('assets/student.svg', width: 28, height: 44,),
                          tap: (){context.goNamed('/signup');}
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 110,),
          Center(
            child: Container(
              width: 1200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText('Как это работает', style:  headerTxt(size: 40, color: dark),),
                  SizedBox(height: 40,),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 1315,
            color: lightBlue,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40,),
                  SelectableText('Процесс проведения уроков', style: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        fontSize: 24.0,
                        height: 1.6, // line-height in Flutter
                        color: Color(0xFF414E61),
                      )
                  ),),
                  SizedBox(height: 32,),
                  SizedBox(
                    width: 1200,
                    child: ProcessScreen(header: 'Создание группы', content: 'Для создания группы на платформе Учимся.ру необходимо зайти в свой личный кабинет и выбрать пункт "Создать группу".',
                      width: 57, height: 43, img: 'assets/group.svg', first: true,

                    ),
                  ),
                  SizedBox(
                    width: 1200,
                    child: ProcessScreen(header: 'Добавление в группу учеников', content: 'Добавление учеников в группу происходит путем создания специальной ссылки, которую можно передать ученикам для подключения к группе.',
                      width: 29, height: 45, img: 'assets/student.svg',

                    ),
                  ),
                  SizedBox(
                    width: 1200,
                    child: ProcessScreen(header: 'Создание материалов для занятия', content: 'Создание материалов для занятия осуществляется через функцию "Создать урок" в группе, где преподаватель может добавить необходимые файлы и ссылки на веб-ресурсы.',
                      width: 41, height: 45, img: 'assets/materials.svg',

                    ),
                  ),
                  SizedBox(
                    width: 1200,
                    child: ProcessScreen(header: 'Создание домашнего задания', content: 'После создания домашнего задания, его можно назначить для конкретных групп студентов. Также можно выставлять оценки и комментировать работу студентов.',
                      width: 46, height: 46, img: 'assets/hw.svg',

                    ),
                  ),
                  SizedBox(
                    width: 1200,
                    child: ProcessScreen(header: 'Проверка отправленных домашних работ', content: 'Для проверки домашних работ используется комбинация автоматических и ручных методов, чтобы обеспечить максимально точную и объективную проверку работ студентов.',
                      width: 33, height: 45, img: 'assets/list.svg', last: true,

                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 110,),
          Center(
            child: Container(
              width: 1200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText('Получите консультацию специалиста', style:  headerTxt(size: 40, color: dark),),
                  SizedBox(height: 40,),
                  Container(
                    width: 1200,
                    height: 751,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 96,
                          horizontal: 102
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 386,
                              height: 456,
                              child: Column(
                                children: [
                                  Container(
                                    width: 184,
                                    height: 184,
                                    child: Image.asset('assets/manager.png', fit: BoxFit.cover,),
                                  ),
                                  SizedBox(height: 16,),
                                  SelectableText('Александра Кузнецова', style: navTxt(fontSize: 24, weight: FontWeight.w500, color: dark),),
                                  SizedBox(height: 8,),
                                  SelectableText('Менеджер', style: navTxt(fontSize: 16, weight: FontWeight.w600, color: Color(0xff808080),)),
                                  SizedBox(height: 32,),
                                  Container(
                                    width: 386,
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/email.svg', width: 20, height: 15,),
                                        SizedBox(width: 12,),
                                        SelectableText('uchimsyaru@gmail.com', style: navTxt(fontSize: 16, weight: FontWeight.w500, color: dark),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 32,),
                                  Container(
                                    width: 386,
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/phone.svg', width: 20, height: 15,),
                                        SizedBox(width: 12,),
                                        SelectableText('+7(982) 794-4025', style: navTxt(fontSize: 16, weight: FontWeight.w500, color: dark),),
                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ),
                            Container(
                              width: 487,
                              height: 565,
                              child: Form(

                                key: formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 487,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 8),
                                                child: SelectableText('Имя', style: navTxt(fontSize: 16, weight: FontWeight.w500, color: dark),),
                                              ),
                                              SizedBox(height: 12,),
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
                                                    controller: nameController,
                                                    decoration: InputDecoration(
                                                      hintText: 'Михаил',
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
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 8),
                                                child: SelectableText('Телефон', style: navTxt(fontSize: 16, weight: FontWeight.w500, color: dark),),
                                              ),
                                              SizedBox(height: 12,),
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
                                                    controller: phoneController,
                                                    decoration: InputDecoration(
                                                      hintText: '+7(ХХХ) ХХХ-ХХХХ',
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
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 32,),
                                    Container(
                                      width: 487,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 8),
                                                child: SelectableText('Почта', style: navTxt(fontSize: 16, weight: FontWeight.w500, color: dark),),
                                              ),
                                              SizedBox(height: 12,),
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
                                                        return 'Введите правильный E-mail';
                                                      }
                                                      if (v.trim().isEmpty){
                                                        return 'Это поле не может быть пустым';
                                                      }
                                                    },
                                                    controller: emailController,
                                                    decoration: InputDecoration(
                                                      hintText: 'example@yandex.ru',
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
                                              )
                                            ],
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              isExpanded: true,
                                              selectedItemBuilder: (c) => items.map((e) =>
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          e,
                                                          style: navTxt(fontSize: 16, weight: FontWeight.w500, color: dark),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ).toList(),
                                              hint: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Категория',
                                                      style: navTxt(fontSize: 16, weight: FontWeight.w500, color: dark),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              items: items
                                                  .map((item) => DropdownMenuItem<String>(
                                                value: item,
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 8,),
                                                    Text(
                                                      item,
                                                      style: navTxt(fontSize: 16, weight: FontWeight.w500, color: dark),
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                  ],
                                                ),
                                              ))
                                                  .toList(),
                                              value: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value as String;
                                                });
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                width: 220,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(color: dark, width: 1),
                                                    borderRadius: BorderRadius.circular(8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.04),
                                                        offset: Offset(0, 4),
                                                        blurRadius: 16,
                                                      )
                                                    ]),
                                              ),
                                              iconStyleData: IconStyleData(
                                                icon: Icon(
                                                  Icons.arrow_drop_down,
                                                ),
                                                iconSize: 24,
                                                iconEnabledColor: dark,
                                                iconDisabledColor: Colors.grey,
                                              ),
                                              dropdownStyleData: DropdownStyleData(
                                                  maxHeight: 400,
                                                  width: 220,
                                                  isOverButton: true,
                                                  padding: EdgeInsets.zero,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(color: dark, width: 1),
                                                      borderRadius: BorderRadius.circular(8),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.04),
                                                          offset: Offset(0, 4),
                                                          blurRadius: 16,
                                                        )
                                                      ]),
                                              ),
                                              menuItemStyleData: const MenuItemStyleData(
                                                height: 40,
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),


                                          )

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 32,),
                                    Container(
                                      width: 487,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: SelectableText('Какой у Вас вопрос?', style: navTxt(fontSize: 16, weight: FontWeight.w500, color: dark),),
                                          ),
                                          SizedBox(height: 12,),
                                          Container(
                                            width: 487,
                                            height: 147,
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
                                                onChanged: (text){
                                                  setState(() {
                                                    _counter = text.length;
                                                  });
                                                },
                                                controller: messageController,
                                                decoration: InputDecoration(
                                                  counter: SizedBox.shrink(),
                                                  hintText: 'Как зарегистрироваться на платформе Учимся.ру?',
                                                  hintStyle: navTxt(fontSize: 16, weight: FontWeight.w500, color: Color(0xffC6C6C6)),
                                                  contentPadding: EdgeInsets.only(left: 8, right: 8),
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
                                                maxLength: 1000,
                                                maxLines: 10,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12,),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text('${_counter}/1000', style: navTxt(fontSize: 16, weight: FontWeight.w500, color: Color(0xffB5B5B5)),),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16,),
                                    button(
                                        onClick: (){
                                          if (formKey.currentState!.validate() == true){
                                            if(selectedValue == null){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    icon: Icon(Icons.warning, size: 32,),
                                                    iconColor: Colors.red,
                                                    title: Text('Вы не указали категорию вопроса', style: headerTxt(color: dark, size: 32),),
                                                    content: Text('Заявки без категории могут рассматриваться дольше.', style: blockTxt(color: dark),),
                                                    actions: [
                                                      TextButton(onPressed: (){
                                                        FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'admin').get()
                                                            .then((value){
                                                          value.docs.forEach((element) async {
                                                            await FirebaseFirestore.instance.collection('users').doc(element.id).collection('new_requests').doc().set(
                                                                {
                                                                  'name': nameController.text,
                                                                  'phone': phoneController.text,
                                                                  'email': emailController.text,
                                                                  'category': selectedValue ?? '',
                                                                  'message': messageController.text,
                                                                  'date': DateTime.now(),
                                                                  'status': 'new'
                                                                }
                                                            );
                                                          });
                                                          nameController.clear();
                                                          phoneController.clear();
                                                          emailController.clear();
                                                          messageController.clear();
                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(const SnackBar(
                                                              backgroundColor: Colors.green,
                                                              content: Text('Заявка успешно отправлена!', style: TextStyle(color: Colors.white),)));

                                                        });


                                                        Navigator.of(context).pop();
                                                      }, child: Text('Отправить')),
                                                      TextButton(onPressed: (){
                                                        Navigator.of(context).pop();
                                                      }, child: Text('Назад'))
                                                    ],
                                                  );
                                                },
                                              );

                                            }else{
                                              FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'admin').get()
                                              .then((value) {
                                                 value.docs.forEach((element) async {
                                                  await FirebaseFirestore.instance.collection('users').doc(element.id).collection('new_requests').doc().set(
                                                      {
                                                        'name': nameController.text,
                                                        'phone': phoneController.text,
                                                        'email': emailController.text,
                                                        'category': selectedValue ?? '',
                                                        'message': messageController.text,
                                                        'date': DateTime.now(),
                                                        'status': 'new'
                                                      }
                                                  );
                                                  nameController.clear();
                                                  phoneController.clear();
                                                  emailController.clear();
                                                  messageController.clear();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                      backgroundColor: Colors.green,
                                                      content: Text('Заявка успешно отправлена!', style: TextStyle(color: Colors.white),)));
                                                });
                                              });


                                            }
                                          }
                                        },
                                        text: 'Отправить',
                                        width: 220,
                                        height: 60,
                                        color: Colors.white,
                                        border: true,
                                        borderColor: dark,
                                    )

                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                    )
                  )

                ],
              ),
            ),
          ),
          SizedBox(height: 110,),
          Footer(),
        ],
      ),

    );
  }
}