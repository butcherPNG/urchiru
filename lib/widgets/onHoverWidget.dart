


import 'package:flutter/material.dart';

class OnHoverWidget extends StatefulWidget{
  final Widget Function(bool isHovered) builder;

  const OnHoverWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  _OnHoverWidgetState createState() => _OnHoverWidgetState();
}

class _OnHoverWidgetState extends State<OnHoverWidget>{
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
   return MouseRegion(
     onEnter: (event) => onEntered(true),
     onExit: (event) => onEntered(false),
     child: widget.builder(isHovered),
   );
  }

  void onEntered(bool isHovered) => setState((){
    this.isHovered = isHovered;
  });
}