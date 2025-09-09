import 'package:flutter/material.dart';
import 'package:gwui/app_theme_util.dart';
import 'package:gwui/resources/size.dart';
import 'package:gwui/resources/styles.dart';

class CustomSnackbar {
  static OverlayEntry? _overlayEntry;
  static _SnackbarWidgetState? _snackbarState;


  /// 스낵바 표시
  static void show({required String message}) async{
    if (_overlayEntry != null) return;
    if(AppThemeUtil.instance.navigatorKey == null) return;

    final navigatorKey = AppThemeUtil.instance.navigatorKey!;
    final snackbar = _SnackbarWidget(
      initialMessage: message,
      onInit: (state) => _snackbarState = state,
    );

    final overlayState = navigatorKey.currentState!.overlay!; //
    _overlayEntry = OverlayEntry(builder: (_) => snackbar);
    overlayState.insert(_overlayEntry!);
    await Future.delayed(Duration(milliseconds: 500));
  }

  /// 메시지 실시간 변경
  static Future<void> update({required String newMessage}) async{
    _snackbarState?.updateMessage(newMessage);
    await Future.delayed(Duration(milliseconds: 500));
  }

  /// 스낵바 닫기 (애니메이션 포함)
  static Future<void> dismiss() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (_snackbarState != null) {
      await _snackbarState!.hide();
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
    _snackbarState = null;
  }
}

class _SnackbarWidget extends StatefulWidget {
  final String initialMessage;
  final void Function(_SnackbarWidgetState) onInit;

  const _SnackbarWidget({
    required this.initialMessage,
    required this.onInit,
  });

  @override
  State<_SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;
  String _currentMessage = "";

  @override
  void initState() {
    super.initState();
    _currentMessage = widget.initialMessage;
    widget.onInit(this);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _offset = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _show(); // 등장 애니메이션 실행
  }

  void updateMessage(String newMessage) {
    setState(() {
      _currentMessage = newMessage;
    });
  }

  Future<void> _show() async {
    await _controller.forward();
  }

  Future<void> hide() async {
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {}, // 아무 동작도 하지 않음 → 터치 차단 효과
            child: Container(
              color: Colors.black.withAlpha(3), // 살짝 어두운 배경
            ),
          ),
        ),
        Positioned(
          bottom: 40.s + MediaQuery.of(context).viewPadding.bottom,
          left: 24.s,
          right: 24.s,
          child: SlideTransition(
            position: _offset,
            child: Material(
              color: AppThemeUtil.instance.pointColor,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 12.s),
                child: Text(
                  _currentMessage,
                  style: AppStyles.w500.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
