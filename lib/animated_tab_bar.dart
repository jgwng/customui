import 'package:flutter/material.dart';
import 'package:gwui/app_theme_util.dart';
import 'package:gwui/resources/size.dart';
import 'package:gwui/resources/styles.dart';
class AnimatedTabBar extends StatefulWidget {
  final List<String> tabs;
  final int? initIndex;
  final ValueChanged<int>? onTabSelected;
  final Color? selectedColor;
  const AnimatedTabBar({
    super.key,
    required this.tabs,
    this.onTabSelected,
    this.initIndex,
    this.selectedColor
  });

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  // 내부 선택 인덱스 (두 탭 기준 0 or 1)
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = (widget.initIndex ?? 0).clamp(0, (widget.tabs.length - 1));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0,
      upperBound: 1,
      value: _currentIndex.toDouble(), // 초기값 동기화
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부에서 initIndex가 바뀌면 내부 상태와 컨트롤러를 즉시 동기화
    if (widget.initIndex != null && widget.initIndex != _currentIndex) {
      _currentIndex =
          widget.initIndex!.clamp(0, (widget.tabs.length - 1));
      _controller.animateTo(
        _currentIndex.toDouble(),
        duration: Duration.zero, // 깜빡임 없이 즉시 반영
      );
      setState(() {}); // 인디케이터 위치도 갱신
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _tabTextColor(BuildContext context, int index) {
    final selected = Colors.white;
    final unselected = Theme.of(context).colorScheme.secondary;

    if (widget.tabs.length == 2) {
      // 컨트롤러 값 0 => 왼쪽 선택, 1 => 오른쪽 선택
      if (index == 0) {
        return Color.lerp(selected, unselected, _controller.value)!;
      } else {
        return Color.lerp(unselected, selected, _controller.value)!;
      }
    }
    // 2개 초과일 경우엔 단순 선택/비선택 처리
    return index == _currentIndex ? selected : unselected;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final totalWidth = c.maxWidth;
      final tabWidth = totalWidth / widget.tabs.length;

      return Container(
        height: 44.s,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Stack(
          children: [
            // 슬라이딩 인디케이터
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: tabWidth * _currentIndex,
              top: 0,
              bottom: 0,
              width: tabWidth,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4.s, horizontal: 4.s),
                decoration: BoxDecoration(
                  color: AppThemeUtil.instance.pointColor,
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),

            // 탭 텍스트
            Row(
              children: List.generate(widget.tabs.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (_currentIndex == index) return;
                      _currentIndex = index;
                      // 두 탭 기준 0 또는 1로 애니메이션
                      final targetValue = widget.tabs.length == 2
                          ? index.toDouble()
                          : _controller.value; // 2개 초과면 위치 애니메만
                      _controller.animateTo(targetValue);
                      setState(() {}); // 인디케이터 이동

                      widget.onTabSelected?.call(index);
                    },
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) => Center(
                        child: Text(
                          widget.tabs[index],
                          style: AppStyles.w700.copyWith(
                            fontSize: 16.fs,
                            color: _tabTextColor(context, index),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}

