import 'package:flutter/material.dart';

@immutable
class CustomSwitchTheme extends ThemeExtension<CustomSwitchTheme> {
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  const CustomSwitchTheme({
    required this.activeColor,
    required this.inactiveColor,
    required this.thumbColor,
  });

  @override
  CustomSwitchTheme copyWith({
    Color? activeColor,
    Color? inactiveColor,
    Color? thumbColor,
  }) {
    return CustomSwitchTheme(
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      thumbColor: thumbColor ?? this.thumbColor,
    );
  }

  @override
  CustomSwitchTheme lerp(ThemeExtension<CustomSwitchTheme>? other, double t) {
    if (other is! CustomSwitchTheme) return this;
    return CustomSwitchTheme(
      activeColor: Color.lerp(activeColor, other.activeColor, t)!,
      inactiveColor: Color.lerp(inactiveColor, other.inactiveColor, t)!,
      thumbColor: Color.lerp(thumbColor, other.thumbColor, t)!,
    );
  }
}