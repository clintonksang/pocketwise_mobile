import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static const double _fontSizeSmall = 10;
  static const double _fontSizeMedium = 14;
  static const double _fontSizeNormal = 18;
  static const double _fontSizeLarge = 20;
  static const double _fontSizeExtraLarge = 32;

  static TextStyle _baseStyle(double fontSize, FontWeight fontWeight, [Color color = Colors.black]) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle get normal => _baseStyle(_fontSizeNormal, FontWeight.normal);
  static TextStyle get bold => _baseStyle(_fontSizeNormal, FontWeight.bold);
  static TextStyle get light => _baseStyle(_fontSizeNormal, FontWeight.w300);
  static TextStyle get large => _baseStyle(_fontSizeLarge, FontWeight.normal);
  static TextStyle get medium => _baseStyle(_fontSizeMedium, FontWeight.normal);
  static TextStyle get largeBold => _baseStyle(_fontSizeLarge, FontWeight.bold);
  static TextStyle get extralarge => _baseStyle(_fontSizeExtraLarge, FontWeight.normal);
  static TextStyle get smallLight => _baseStyle(_fontSizeSmall, FontWeight.bold);
}

extension AppText on Text {
  Text normal({Color color = Colors.black}) => Text(data!, style: style?.merge(AppTextStyles._baseStyle(AppTextStyles._fontSizeNormal, FontWeight.normal, color)) ?? AppTextStyles._baseStyle(AppTextStyles._fontSizeNormal, FontWeight.normal, color));
  Text bold({Color color = Colors.black}) => Text(data!, style: style?.merge(AppTextStyles._baseStyle(AppTextStyles._fontSizeNormal, FontWeight.bold, color)) ?? AppTextStyles._baseStyle(AppTextStyles._fontSizeNormal, FontWeight.bold, color));
  Text light({Color color = Colors.black}) => Text(data!, style: style?.merge(AppTextStyles._baseStyle(AppTextStyles._fontSizeNormal, FontWeight.w300, color)) ?? AppTextStyles._baseStyle(AppTextStyles._fontSizeNormal, FontWeight.w300, color));
  Text large({Color color = Colors.black}) => Text(data!, style: style?.merge(AppTextStyles._baseStyle(AppTextStyles._fontSizeLarge, FontWeight.normal, color)) ?? AppTextStyles._baseStyle(AppTextStyles._fontSizeLarge, FontWeight.normal, color));
  Text medium({Color color = Colors.black}) => Text(data!, style: style?.merge(AppTextStyles._baseStyle(AppTextStyles._fontSizeMedium, FontWeight.normal, color)) ?? AppTextStyles._baseStyle(AppTextStyles._fontSizeMedium, FontWeight.normal, color));
  Text largeBold({Color color = Colors.black}) => Text(data!, style: style?.merge(AppTextStyles._baseStyle(AppTextStyles._fontSizeLarge, FontWeight.bold, color)) ?? AppTextStyles._baseStyle(AppTextStyles._fontSizeLarge, FontWeight.bold, color));
  Text extralargeBold({Color color = Colors.black}) => Text(data!, style: style?.merge(AppTextStyles._baseStyle(AppTextStyles._fontSizeExtraLarge, FontWeight.normal, color)) ?? AppTextStyles._baseStyle(AppTextStyles._fontSizeExtraLarge, FontWeight.normal, color));
  Text smallLight({Color color = Colors.black}) => Text(data!, style: style?.merge(AppTextStyles._baseStyle(AppTextStyles._fontSizeSmall, FontWeight.bold, color)) ?? AppTextStyles._baseStyle(AppTextStyles._fontSizeSmall, FontWeight.bold, color));
}
