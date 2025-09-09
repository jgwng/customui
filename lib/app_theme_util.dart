import 'package:flutter/material.dart';

class AppThemeUtil {
  // 🔒 private static instance
  static final AppThemeUtil _instance = AppThemeUtil._internal();

  // ✅ public getter로 인스턴스 접근
  static AppThemeUtil get instance => _instance;

  // 🔐 private 생성자
  AppThemeUtil._internal();

  // 📦 상태 변수들
  Color? _fontColor;
  Color? _backgroundColor;
  Color? _pointColor;
  Color? _iconColor;
  GlobalKey<NavigatorState>? _navigatorKey;

  // 📌 외부에서 읽기 전용으로 접근
  Color get fontColor => _fontColor ?? Colors.black;
  Color get backgroundColor => _backgroundColor ?? Colors.white;
  Color get pointColor => _pointColor ?? Colors.white;
  Color get iconColor => _iconColor ?? Colors.white;
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  // 📌 초기 설정 함수
  void init({
    Color? fontColor,
    Color? backgroundColor,
    Color? pointColor,
    Color? iconColor,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    _fontColor = fontColor;
    _backgroundColor = backgroundColor;
    _pointColor = pointColor;
    _iconColor = iconColor;
    _navigatorKey = navigatorKey;
  }

  // 📌 초기화 여부를 확인할 수 있는 헬퍼
  bool get isInitialized => _navigatorKey != null;
}
