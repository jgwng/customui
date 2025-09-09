import 'package:flutter/material.dart';

class AppStyles {
  static const String _fontFamily = 'Pretendard';

  // Singleton instance
  static final AppStyles instance = AppStyles._internal();

  factory AppStyles() {
    return instance;
  }

  AppStyles._internal();

  // Predefined TextStyles for wght (100 - 900)
  static const TextStyle w100 = TextStyle(
    fontFamily: _fontFamily,
    color: Color(0xFF131214),
    fontVariations: [FontVariation('wght', 100)],
  );

  static const TextStyle w200 = TextStyle(
    fontFamily: _fontFamily,
    color: Color(0xFF131214),
    fontVariations: [FontVariation('wght', 200)],
  );

  static const TextStyle w300 = TextStyle(
    fontFamily: _fontFamily,
    color: Color(0xFF131214),
    fontVariations: [FontVariation('wght', 300)],
  );

  static const TextStyle w400 = TextStyle(
    fontFamily: _fontFamily,
    color: Color(0xFF131214),
    fontVariations: [FontVariation('wght', 400)],
  );

  static const TextStyle w500 = TextStyle(
    fontFamily: _fontFamily,
    color: Color(0xFF131214),
    height: 16/12,
    letterSpacing: -0.47,
    fontVariations: [FontVariation('wght', 500)],
  );

  static const TextStyle w600 = TextStyle(
    fontFamily: _fontFamily,
    color: Color(0xFF131214),
    height: 16/12,
    letterSpacing: -0.47,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle w700 = TextStyle(
    fontFamily: _fontFamily,
    color: Color(0xFF131214),
    height: 16/12,
    letterSpacing: -0.47,
    fontVariations: [FontVariation('wght', 700)],
  );

  static const TextStyle w800 = TextStyle(
    fontFamily: _fontFamily,
    color: Color(0xFF131214),
    fontVariations: [FontVariation('wght', 800)],
  );

  static const TextStyle w900 = TextStyle(
    fontFamily: _fontFamily,
    color: Color(0xFF131214),
    fontVariations: [FontVariation('wght', 900)],
  );
}
