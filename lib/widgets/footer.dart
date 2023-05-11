



import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../styles/styles.dart';
import 'onHoverWidget.dart';

class Footer extends StatefulWidget {

  const Footer({Key? key}) : super(key: key);

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        width: double.infinity,
        height: 433,
        decoration: BoxDecoration(
          color: dark,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          )
        ),
        child: Center(
          child: Container(
            width: 1200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 85,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText('Контакты', style: navTxt(color: Colors.white, fontSize: 20, weight: FontWeight.w700),),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              SvgPicture.asset('assets/email.svg', width: 16, height: 12, color: Colors.white,),
                              SizedBox(width: 16,),
                              SelectableText('uchimsyaru@gmail.com', style: navTxt(color: Colors.white, fontSize: 16, weight: FontWeight.w400),)
                            ],
                          ),
                          SizedBox(height: 16,),
                          Row(
                            children: [
                              SvgPicture.asset('assets/phone.svg', width: 16, height: 16, color: Colors.white,),
                              SizedBox(width: 16,),
                              SelectableText('+7(815) 221-4512', style: navTxt(color: Colors.white, fontSize: 16, weight: FontWeight.w400),)
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText('Образование', style: navTxt(color: Colors.white, fontSize: 20, weight: FontWeight.w700),),
                          SizedBox(height: 20,),
                          InkWell(
                            onTap: (){

                            },
                            child: OnHoverWidget(
                              builder: (bool isHovered) {
                                return Text('Материалы для занятий', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 16, weight: FontWeight.w400),);
                              },
                            ),
                          ),
                          SizedBox(height: 16,),
                          InkWell(
                            onTap: (){},
                            child: OnHoverWidget(
                              builder: (bool isHovered) {
                                return Text('Оплата', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 16, weight: FontWeight.w400),);
                              },
                            ),
                          ),
                          SizedBox(height: 16,),
                          InkWell(
                            onTap: (){},
                            child: OnHoverWidget(
                              builder: (bool isHovered) {
                                return Text('Возможности', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 16, weight: FontWeight.w400),);
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText('О нас', style: navTxt(color: Colors.white, fontSize: 20, weight: FontWeight.w700),),
                        SizedBox(height: 20,),
                        InkWell(
                          onTap: (){},
                          child: OnHoverWidget(
                            builder: (bool isHovered) {
                              return Text('О платформе', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 16, weight: FontWeight.w400),);
                            },
                          ),
                        ),
                        SizedBox(height: 16,),
                        InkWell(
                          onTap: (){},
                          child: OnHoverWidget(
                            builder: (bool isHovered) {
                              return Text('Блог', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 16, weight: FontWeight.w400),);
                            },
                          ),
                        ),
                        SizedBox(height: 16,),
                        InkWell(
                          onTap: (){},
                          child: OnHoverWidget(
                            builder: (bool isHovered) {
                              return Text('Контакты', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 16, weight: FontWeight.w400),);
                            },
                          ),
                        ),
                      ],
                    ),
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText('Социальные сети', style: navTxt(color: Colors.white, fontSize: 20, weight: FontWeight.w700),),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Image.asset('assets/insta.png', width: 45, height: 45,),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: (){},
                              child: Image.asset('assets/vk.png', width: 45, height: 45,),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: (){},
                              child: Image.asset('assets/tg.png', width: 45, height: 45,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 100),
                SelectableText('Copyright © 2023  Учимся.ру. Все права защищены.', style: navTxt(color: Color(0xff80838C), fontSize: 16, weight: FontWeight.w400),),
              ],
            ),
          ),
        )
    );
  }
}



class FooterTablet extends StatefulWidget {

  const FooterTablet({Key? key}) : super(key: key);

  @override
  _FooterTabletState createState() => _FooterTabletState();
}

class _FooterTabletState extends State<FooterTablet> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        width: double.infinity,
        height: 433,
        color: const Color(0xFF1A120B),
        child: Center(
          child: Container(
            width: 727,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 85,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText('Контакты', style: navTxt(color: Colors.white, fontSize: 16, weight: FontWeight.w700),),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            SvgPicture.asset('assets/location.svg', width: 13, height: 16,),
                            SizedBox(width: 8,),
                            SelectableText('ул. Герцена, д. 56', style: navTxt(color: Colors.white, fontSize: 14, weight: FontWeight.w400),)
                          ],
                        ),
                        SizedBox(height: 16,),
                        Row(
                          children: [
                            SvgPicture.asset('assets/mail.svg', width: 13, height: 10,),
                            SizedBox(width: 8,),
                            SelectableText('linguasphere@gmail.com', style: navTxt(color: Colors.white, fontSize: 14, weight: FontWeight.w400),)
                          ],
                        ),
                        SizedBox(height: 16,),
                        Row(
                          children: [
                            SvgPicture.asset('assets/phone.svg', width: 16, height: 16,),
                            SizedBox(width: 8,),
                            SelectableText('+7(815) 221-4512', style: navTxt(color: Colors.white, fontSize: 14, weight: FontWeight.w400),)
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText('Образование', style: navTxt(color: Colors.white, fontSize: 16, weight: FontWeight.w700),),
                        SizedBox(height: 20,),
                        InkWell(
                          onTap: (){

                          },
                          child: OnHoverWidget(
                            builder: (bool isHovered) {
                              return Text('Курсы', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 14, weight: FontWeight.w400),);
                            },
                          ),
                        ),
                        SizedBox(height: 16,),
                        InkWell(
                          onTap: (){},
                          child: OnHoverWidget(
                            builder: (bool isHovered) {
                              return Text('Расписание', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 14, weight: FontWeight.w400),);
                            },
                          ),
                        ),
                        SizedBox(height: 16,),
                        InkWell(
                          onTap: (){},
                          child: OnHoverWidget(
                            builder: (bool isHovered) {
                              return Text('Учебники', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 14, weight: FontWeight.w400),);
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText('О нас', style: navTxt(color: Colors.white, fontSize: 16, weight: FontWeight.w700),),
                        SizedBox(height: 20,),
                        InkWell(
                          onTap: (){},
                          child: OnHoverWidget(
                            builder: (bool isHovered) {
                              return Text('О центре', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 14, weight: FontWeight.w400),);
                            },
                          ),
                        ),
                        SizedBox(height: 16,),
                        InkWell(
                          onTap: (){},
                          child: OnHoverWidget(
                            builder: (bool isHovered) {
                              return Text('Блог', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 14, weight: FontWeight.w400),);
                            },
                          ),
                        ),
                        SizedBox(height: 16,),
                        InkWell(
                          onTap: (){},
                          child: OnHoverWidget(
                            builder: (bool isHovered) {
                              return Text('Контакты', style: navTxt(color: isHovered? Color(0xFF828282) : Colors.white, fontSize: 14, weight: FontWeight.w400),);
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText('Социальные сети', style: navTxt(color: Colors.white, fontSize: 16, weight: FontWeight.w700),),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Image.asset('assets/insta.png', width: 35, height: 35,),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: (){},
                              child: Image.asset('assets/vk.png', width: 35, height: 35,),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: (){},
                              child: Image.asset('assets/tg.png', width: 35, height: 35,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 100),
                SelectableText('Copyright © 2023 LinguaSphere. Все права защищены.', style: navTxt(color: Colors.white, fontSize: 14, weight: FontWeight.w400),),
              ],
            ),
          ),
        )
    );
  }
}