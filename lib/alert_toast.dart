import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gwui/app_theme_util.dart';
import 'package:gwui/resources/size.dart';
import 'package:gwui/resources/styles.dart';

class AlertToast {
  /// Single tone 을 유한 객체
  static final AlertToast _instance = AlertToast._();

  /// Single tone 을 받어오는 factory 생성자
  factory AlertToast.instance() => _instance;

  AlertToast._();

  /// ### 실제로 표시할 오버레이 엔티티
  static OverlayEntry? _overlayEntry;

  /// ### 토스트가 현제 표시되고 있는지 확인하는 변수
  static bool _isVisible = false;

  /// ### 현재 표시되고 있는 토스트의 타이머
  static Timer? _timer;

  static void show({// ✅ Add context
    String? msg,
    int duration = 1,
    Alignment align = Alignment.center,
    bool preserveCurrent = false,
  }) {
    if (preserveCurrent && _isVisible) {
      return;
    }
    dismiss();

    if (msg == null) return;
    if (AppThemeUtil.instance.navigatorKey == null) return;

    // 위젯을 가지고 있다면 위젯을 띄워줌
    _overlayEntry = _msgBuilder(msg, align);

    // final overlayState = navigatorKey.currentState!.overlay!; //
    final overlayState = Navigator.of(AppThemeUtil.instance.navigatorKey!.currentContext!, rootNavigator: true).overlay;

    if(overlayState == null) return;

    _isVisible = true;
    overlayState.insert(_overlayEntry!);

    _timer = Timer(Duration(seconds: duration), () {
      dismiss();
    });
  }


  /// ## 토스트 메세지 제거
  static void dismiss() {
    if (!_isVisible) return;

    _isVisible = false;
    _timer?.cancel();
    _timer = null;
    _overlayEntry?.remove();
  }

  /// ## 한줄 짜리 메세지 위젯 빌더
  static OverlayEntry _msgBuilder(String msg, Alignment align) {
    return OverlayEntry(
      builder: (context) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          // 키보드/세이프패딩 영향 제거 → 진짜 화면 중앙에 고정
          data: mq.copyWith(
            viewInsets: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
          child: Align(
            alignment: align,
            child: IgnorePointer(
              child: Material(
                borderRadius: BorderRadius.circular(8.s),
                color: AppThemeUtil.instance.pointColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.s, vertical: 12.s),
                  child: Text(
                    msg,
                    style: AppStyles.w700.copyWith(
                      fontSize: 16.fs,
                      letterSpacing: -0.47.fs,
                      height: 20 / 14,
                      color: AppThemeUtil.instance.fontColor,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
