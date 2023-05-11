import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class MyPanel extends StatefulWidget {
  final String header;
  final String content;
  MyPanel({
    required this.header,
    required this.content
  });
  @override
  _MyPanelState createState() => _MyPanelState();
}

class _MyPanelState extends State<MyPanel> {
  bool _isExpanded = false;
  final myBoxKey = GlobalKey();
  double _childHeight = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraits){
          return AnimatedContainer(
            width: 590,
            height: _childHeight < 200 ? _isExpanded ? (_childHeight + 118 + 24) : 83 : _isExpanded ? (_childHeight + 118 + 24) : 118,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xFFE0E0E0)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFE0E0E0)),
              ),
            ),
            duration: Duration(milliseconds: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    InkResponse(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        print(_childHeight);
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Icon(_isExpanded ? Icons.remove : Icons.add, size: 30, color: const Color(0xffFECD81),),
                    ),

                    SizedBox(width: 25),
                    Container(
                      width: 535,
                      child: Text(widget.header, style: GoogleFonts.manrope(
                          textStyle: const TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            height: 1.6, // соответствует line-height: 160%
                            color: Color(0xFF060C1D), // соответствует цвету #060C1D в формате ARGB
                          )
                      )),
                    )
                  ],
                ),
                Padding(
                    padding: _isExpanded ? EdgeInsets.only(top: 24, bottom: 24) : EdgeInsets.only(top: 0, bottom: 0),
                    child: AnimatedContainer(
                      width: 590,
                      duration: Duration(milliseconds: 500),
                      height: _isExpanded ? _childHeight : 0,
                      child: MyChildWidget(
                        onLayout: (Size size) {
                          setState(() {
                            _childHeight = size.height;
                          });
                        },
                        content: widget.content,
                      ),
                    ),
                )

              ],
            ),
          );
        }
    );
  }
}


class MyChildWidget extends StatelessWidget {
  final Function(Size size) onLayout;
  final String content;
  MyChildWidget({required this.onLayout, required this.content});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textSpan = TextSpan(text: content, style: GoogleFonts.manrope(
          textStyle: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w300,
            fontSize: 18.0,
            height: 1.6,
            color: Color(0xFF6A6D77),
          ),
        ));
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: null,
        )..layout(maxWidth: constraints.maxWidth);

        final textSize = textPainter.size;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onLayout(textSize);
        });
        return SizedBox(
          width: 590,
          height: textSize.height,
          child: Text(content, style: GoogleFonts.manrope(
            textStyle: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
              fontSize: 18.0,
              height: 1.6,
              color: Color(0xFF6A6D77),
            ),

          ),
          ),
        );
      },

    );
  }
}