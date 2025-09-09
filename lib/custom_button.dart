import 'package:flutter/material.dart';
import 'package:gwui/resources/size.dart';
import 'package:gwui/resources/styles.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {super.key,
        this.onTap,
        this.buttonText,
        this.buttonColor,
        this.height,
        this.borderRadius,
        this.horizontalPadding,
        this.buttonTextColor,
        this.buttonTextStyle});

  final VoidCallback? onTap;
  final String? buttonText;
  final Color? buttonColor;
  final double? height;
  final double? horizontalPadding;
  final double? borderRadius;
  final Color? buttonTextColor;
  final TextStyle? buttonTextStyle;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin{
  late Animation<double> _scale;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _controller.forward();
      },
      onPointerUp: (_) {
        _controller.reverse().then((value){
          if (widget.onTap != null) {
            widget.onTap!();
          }
        });
      },
      onPointerCancel: (_) {
        _controller.reverse();
      },
      child: ScaleTransition(
          scale: _scale,
          child: Container(
            height: widget.height ?? 48.s,
            margin: EdgeInsetsDirectional.symmetric(horizontal: widget.horizontalPadding ?? 16.s),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.buttonColor ?? Colors.transparent,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
            ),
            child: Text(
              widget.buttonText ?? '',
              textAlign: TextAlign.center,
              style: widget.buttonTextStyle ??
                  AppStyles.w700.copyWith(
                    color: widget.buttonTextColor ?? Colors.black,
                    fontSize: 18.fs,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ),
    );
  }
}
