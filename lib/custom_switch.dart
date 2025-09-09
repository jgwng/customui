import 'package:flutter/material.dart';
import 'package:gwui/app_theme_util.dart';
import 'package:gwui/resources/size.dart';
import 'package:gwui/resources/theme_extension.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double? width;
  final double? height;
  final Future<bool> Function()? onTapSwitch;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width,
    this.height,
    this.onTapSwitch,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _circleAnimation;
  late Animation<Color?> _colorAnimation;

  late Color activeColor;
  late Color inactiveColor;
  late Color switchColor;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _initAnimations();
  }

  void _initAnimations() {
    final navigatorKey = AppThemeUtil.instance.navigatorKey;
    if(navigatorKey == null) return;

    _circleAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    final switchTheme = Theme.of(navigatorKey.currentContext!).extension<CustomSwitchTheme>();
    activeColor = switchTheme?.activeColor ?? AppThemeUtil.instance.pointColor;
    inactiveColor = switchTheme?.inactiveColor ?? AppThemeUtil.instance.pointColor;
    switchColor = switchTheme?.thumbColor ?? AppThemeUtil.instance.pointColor;

    _colorAnimation = ColorTween(
      begin: inactiveColor,
      end: activeColor,
    ).animate(_animationController);

    // initial position
    _animationController.value = widget.value ? 1.0 : 0.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initAnimations(); // 여기서 다시 색상 재설정
  }

  @override
  void didUpdateWidget(covariant CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () async {
            if (widget.onTapSwitch != null) {
              final result = await widget.onTapSwitch!();
              if (result) {
                // Toggle visual state only if external callback allows
                if (_animationController.isCompleted) {
                  _animationController.reverse();
                  widget.onChanged(false);
                } else {
                  _animationController.forward();
                  widget.onChanged(true);
                }
              }
            } else {
              // fallback if no async validation is provided
              if (_animationController.isCompleted) {
                _animationController.reverse();
                widget.onChanged(false);
              } else {
                _animationController.forward();
                widget.onChanged(true);
              }
            }
          },
          child: Container(
            width: widget.width ?? 40.s,
            height: widget.height ?? 24.s,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: _colorAnimation.value
            ),
            child: Padding(
              padding:
              EdgeInsetsDirectional.symmetric(horizontal: 1, vertical: 2.s),
              child: Align(
                alignment: _circleAnimation.value,
                child: Container(
                  width: widget.height ?? 24.s,
                  height: widget.height ?? 24.s,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: switchColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
