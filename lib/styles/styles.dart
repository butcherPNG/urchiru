import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../widgets/onHoverWidget.dart';


Color nightBlue = const Color(0xff002B5B);
Color yellow = const Color(0xffFECD81);
Color blue = const Color(0xff6B99C3);
Color lightBlue = const Color(0xffEFF8FF);
Color pink = const Color(0xffFFDDDD);
Color dark = const Color(0xff060C1D);

TextStyle offerTxt({double? size, Color? color}){
  return GoogleFonts.manrope(
      textStyle: TextStyle(
        fontSize: size ?? 72,
        fontWeight: FontWeight.bold,
        color: color ?? dark,
      )
  );
}

TextStyle blockTxt({Color? color, double? size}){
  return GoogleFonts.manrope(
    textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        fontSize: size?? 20,
        height: 1.6,
        color: color ?? dark,
    )
);
}

TextStyle blockTxtLight({Color? color, double? size}){
  return GoogleFonts.manrope(
      textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        fontSize: size?? 20,
        height: 1.6,
        color: color ?? dark,
      )
  );
}

TextStyle courseTxt({
    Color? color,
    double? size
  }){
  return GoogleFonts.manrope(
      textStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: size ?? 16.0,
          height: 1.2, //line height
          color: color ?? dark
      )
  );
}

TextStyle navTxt({
  Color? color,
  required double fontSize,
  required FontWeight weight,
  bool? underline
}){
  return GoogleFonts.manrope(
      textStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: weight,
          fontSize: fontSize,
          height: 1.6, //line height
          color: color ?? dark,
          decoration: underline == true ? TextDecoration.underline : TextDecoration.none
      )
  );
}

TextStyle headerTxt({Color? color, double? size}){
  return GoogleFonts.manrope(
      textStyle: TextStyle(
        fontSize: size ?? 64,
        fontWeight: FontWeight.bold,
        color: color ?? dark,
      )
  );
}

TextStyle subHeaderTxt({Color? color, double? size}){
  return GoogleFonts.manrope(
      textStyle: TextStyle(
        fontSize: size ?? 40,
        fontWeight: FontWeight.bold,
        color: color ?? const Color(0xFF1A120B),
      )
  );
}

TextStyle middleTxt({required double fontSize, Color? color}){
  return GoogleFonts.manrope(
      textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        height: 1.2,
        color: color ?? Color(0xFF1A120B),

      )
  );
}

Widget courseCard({
    required Color backgr,
    required String title,
    required String price,
    required String img,
    required Function() tap
  }){


    return Container(
      width: 387,
      height: 442,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(47, 47, 47, 0.06),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE1E1E1), width: 1),

      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 171, 0, 0),
            child: Container(
              width: 387,
              height: 271,
              child: ClipRRect(
                  borderRadius: BorderRadius. circular(8.0),
                  child: Image.network(img, fit: BoxFit.cover
                  )

              ),
            ),
          ),
          Container(
              width: 387,
              height: 181,
              decoration: BoxDecoration(
                color: backgr, // цвет фона в формате ARGB
                border: backgr == Color(0xff060C1D) ? null : Border.all(color: Color(0xFFE1E1E1), width: 1),
                borderRadius: BorderRadius.circular(8), // радиус границ
              ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 38, 24, 38),
                  child: Container(
                    width: 338,
                    height: 95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: middleTxt(fontSize: 24, color: backgr == Color(0xff060C1D) ? Colors.white : Colors.black),),
                        Spacer(),
                        Row(
                          children: [
                            Text(price, style: courseTxt(color: backgr == Color(0xff060C1D) ? Colors.white : Colors.black),),
                            Spacer(),


                            InkResponse(
                                onTap: tap,
                                child: OnHoverWidget(
                                  builder: (bool isHovered) {
                                    return Container(
                                      width: 39,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        color:  backgr == Color(0xff060C1D) ?
                                        isHovered ? Colors.white : Colors.transparent
                                            : isHovered ? Color(0xff060C1D) : Colors.transparent,
                                        border: Border.all(color: backgr == Color(0xff060C1D) ? Colors.white : Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset('assets/arrow.svg',
                                          width: 7,
                                          height: 14,
                                          color: backgr == Color(0xff060C1D) ?
                                          isHovered ? Colors.black : Colors.white
                                              : isHovered ? Colors.white  : Colors.black,
                                        ),
                                      ),
                                    );
                                  },)
                            )

                          ],
                        )

                      ],
                    ),
                  )
              )
          )
        ],
      ),
    );

}

Widget cards({
  required Color backgr,
  required String header,
  required String content,
  required SvgPicture img,
  required Function() tap
}){


  return Container(
    width: 387,
    height: 314,
    color: backgr,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 315,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                img,
                InkResponse(
                    onTap: tap,
                    child: OnHoverWidget(
                      builder: (bool isHovered) {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:  isHovered ? Colors.white : Colors.transparent,
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset('assets/arrow.svg',
                              width: 7,
                              height: 14,
                              color: isHovered ? dark : Colors.white,
                            ),
                          ),
                        );
                      },)
                )
              ],
            ),
          ),
          SizedBox(height: 16,),
          Container(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(header, style: middleTxt(fontSize: 32, color: Colors.white),),
                SizedBox(height: 8,),
                SelectableText(content, style: blockTxtLight(size: 20, color: Colors.white),)
              ],
            ),
          )
        ],
      ),
    ),
  );

}

Widget tabletCourseCard({
  required Color backgr,
  required String title,
  required String price,
  required String img
}){
  return Container(
    width: 235,
    height: 268,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(47, 47, 47, 0.06),
          blurRadius: 24,
          offset: Offset(0, 4),
        ),
      ],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Color(0xFFE1E1E1), width: 1),

    ),
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 103, 0, 0),
          child: Container(
            width: 235,
            height: 165,
            child: ClipRRect(
                borderRadius: BorderRadius. circular(8.0),
                child: Image.network(img, fit: BoxFit.cover
                )

            ),
          ),
        ),
        Container(
            width: 235,
            height: 110,
            decoration: BoxDecoration(
              color: backgr, // цвет фона в формате ARGB
              border: backgr == Color(0xff060C1D) ? null : Border.all(color: Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(8), // радиус границ
            ),
            child: Padding(
                padding: EdgeInsets.fromLTRB(14, 16, 14, 20),
                child: Container(
                  width: 207,
                  height: 75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: middleTxt(fontSize: 16, color: backgr == Color(0xff060C1D) ? Colors.white : Colors.black),),
                      Spacer(),
                      Row(
                        children: [
                          Text(price, style: courseTxt(size: 14, color: backgr == Color(0xff060C1D) ? Colors.white : Colors.black),),
                          Spacer(),

                          InkResponse(
                              onTap: (){},
                              child: OnHoverWidget(
                                builder: (bool isHovered) {
                                  return Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color:  backgr == Color(0xff060C1D) ?
                                      isHovered ? Colors.white : Colors.transparent
                                          : isHovered ? Color(0xff060C1D) : Colors.transparent,
                                      border: Border.all(color: backgr == Color(0xff060C1D) ? Colors.white : Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset('assets/arrow.svg',
                                        width: 5,
                                        height: 9,
                                        color: backgr == Color(0xff060C1D) ?
                                        isHovered ? Colors.black : Colors.white
                                            : isHovered ? Colors.white  : Colors.black,
                                      ),
                                    ),
                                  );
                                },)
                          )

                        ],
                      )

                    ],
                  ),
                )
            )
        )
      ],
    ),
  );
}

Widget mainCourseCard({
  required Color backgr,
  required String title,
  required String price,
  required String img
}){
  return Container(
    width: 387,
    height: 327,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(47, 47, 47, 0.06),
          blurRadius: 24,
          offset: Offset(0, 4),
        ),
      ],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Color(0xFFE1E1E1), width: 1),

    ),
    child: Stack(
      children: [
        Container(
            width: 387,
            height: 155,
            decoration: BoxDecoration(
              color: backgr, // цвет фона в формате ARGB
              border: Border.all(color: Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)), // радиус границ
            ),
            child: Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 38),
                child: Container(
                  width: 338,
                  height: 95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 269,
                            child: Text(title, style: middleTxt(fontSize: 24, color: Colors.black),),
                          ),
                          Spacer(),


                          InkResponse(
                              onTap: (){},
                              child: OnHoverWidget(
                                builder: (bool isHovered) {
                                  return Container(
                                    width: 39,
                                    height: 39,
                                    decoration: BoxDecoration(
                                      color: isHovered ? Color(0xff060C1D) : Colors.transparent,
                                      border: Border.all(color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset('assets/arrow.svg',
                                        width: 7,
                                        height: 14,
                                        color: isHovered ? Colors.white  : Colors.black,
                                      ),
                                    ),
                                  );
                                },)
                          )

                        ],
                      ),
                      Spacer(),
                      Text(price, style: courseTxt(color: backgr == Color(0xff060C1D) ? Colors.white : Colors.black),),


                    ],
                  ),
                )
            )
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 149, 0, 0),
          child: Container(
            width: 387,
            height: 187,
            child: ClipRRect(
                borderRadius: BorderRadius. circular(8.0),
                child: Image.asset(img, fit: BoxFit.cover
                )

            ),
          ),
        ),

      ],
    ),
  );
}

BoxDecoration boxDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(
    color: const Color(0xFFF8F8F8),
    width: 1,
  ),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF2F2F2F).withOpacity(0.06),
      offset: Offset(0, 4),
      blurRadius: 24,
    ),
  ],
  borderRadius: BorderRadius.circular(8),
);

ElevatedButton button({
  required Function() onClick,
  required String text,
  double? height,
  double? width,
  Color? color,
  double? radius,
  double? size,
  Key? key,
  TextStyle? txtStyle,
  Color? borderColor,
  bool? border
  }){
  return ElevatedButton(
      key: key,
      style: ElevatedButton.styleFrom(
      side: border == true ? BorderSide(
        width: 1.0,
        color: borderColor ?? dark
      ) : BorderSide.none,
      fixedSize: Size(width ?? 285, height ?? 48),
      backgroundColor: color ?? Color(0xffFECD81),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius ?? 8),
    ),
  ),
  onPressed: onClick,
  child: Text(text, style: txtStyle ?? GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: size ?? 16,
    height: 1.6,
    color: Color(0xff1A120B),
  ),));
}