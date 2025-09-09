import 'dart:ui';

ColorFilter svgFilter(Color color, {BlendMode mode = BlendMode.srcIn}) =>
    ColorFilter.mode(color, mode);
