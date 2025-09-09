import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gwui/app_theme_util.dart';
import 'package:gwui/resources/colors.dart';
import 'package:gwui/resources/size.dart';
import 'package:gwui/resources/styles.dart';

class CustomAppBar extends StatefulWidget  implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.leading,
      this.hideLeading,
      this.action,
      this.isBack,
      this.title,
      this.titleWidget,
      this.onTapLeadButton});

  final bool? isBack;
  final bool? hideLeading;
  final String? title;
  final List<Widget>? action;
  final Widget? leading;
  final Widget? titleWidget;
  final VoidCallback? onTapLeadButton;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56.s);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.s,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      margin: EdgeInsetsDirectional.only(
        top: MediaQuery.of(context).viewPadding.top
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.s),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.outline))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leadingButton(),
          Expanded(
            child: SizedBox(
              height: 32.s,
              child: titleButton(),
            ),
          ),
          actionButton()
        ],
      ),
    );
  }

  Widget leadingButton() {
    if (widget.leading != null) {
      return widget.leading!;
    }

    bool hideLeading = widget.hideLeading ?? false;
    if (hideLeading) {
      return SizedBox(
        width: 32.s,
        height: 32.s,
      );
    } else {
      return InkWell(
        onTap: () {
          if (widget.onTapLeadButton != null) {
            widget.onTapLeadButton!();
          } else {
            if (hideLeading == false) {
              Navigator.pop(context);
            }
          }
        },
        child: Container(
          width: 32.s,
          height: 32.s,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            (widget.isBack ?? true)
                ? 'packages/gwui/assets/images/back.svg'
                : 'packages/gwui/assets/images/close.svg',
            width: 28.s,
            height: 28.s,
            colorFilter: svgFilter(AppThemeUtil.instance.iconColor),
          ),
        ),
      );
    }
  }

  Widget actionButton() {
    if (widget.action != null) {
      return SizedBox(
        height: 32.s,
        child: Row(
          children: [
            ...widget.action!
          ],
        ),
      );
    }
    return SizedBox(
      width: 32.s,
      height: 32.s,
    );
  }

  Widget titleButton() {
    if (widget.titleWidget != null) {
      return widget.titleWidget ?? const SizedBox();
    }
    return Container(
      alignment: Alignment.center,
      height: 32.s,
      child: Text(
        widget.title ?? '',
        style: AppStyles.w700.copyWith(
            fontSize: 20.fs, color: Theme.of(context).colorScheme.surfaceDim),
        textAlign: TextAlign.center,
      ),
    );
  }
}
