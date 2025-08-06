import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(
      this.text, {
        super.key,
        this.color,
        this.height = 0,
        this.size = 14,
        this.textAlign,
        this.maxLines,
        this.family,
        this.weight,
        this.style,
        this.overflow,
        this.width = 0,
      });

  final dynamic text;
  final String? family;
  final Color? color;
  final double height;
  final double width;
  final double? size;
  final FontWeight? weight;
  final TextAlign? textAlign; // This is the property for text alignment
  final int? maxLines;
  final TextStyle? style;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${text ?? ''}',
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        height: height == 0 ? null : height,
        fontSize: size,
        color: color,
        fontWeight: weight,
        fontFamily: family,
      ),
      textAlign: textAlign, // This correctly applies the text alignment
    );
  }
}