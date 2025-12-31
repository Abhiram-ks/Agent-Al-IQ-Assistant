import 'package:agent_ai/core/common/custom_needhelp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../src/riverpod/toggle_riverpod.dart';
import '../app_manage/app_color.dart';

class CostumeToggle extends ConsumerWidget {
  const CostumeToggle({super.key});

  final animationDuration = const Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return Row(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(themeProvider.notifier).toggle();
          },
          child: AnimatedContainer(
            duration: animationDuration,
            height: 30,
            width: 65,
            decoration: BoxDecoration(
              color: isDark
                  ? AppPalette.black2.withValues(alpha: 0.6)
                  : AppPalette.hint,
                  borderRadius: .circular(40),
            ),
            child: Stack(
                  alignment: .center,
              children: [
                Row(
                      mainAxisAlignment: .center,
                  children: [
                    Padding(
                          padding: .only(left: 10),
                          child: Icon(Icons.dark_mode, size: 20, color: isDark ? AppPalette.white:AppPalette.hint),
                    ),
                    Padding(
                          padding: const .only(right: 9),
                          child: Icon(Icons.light_mode, size: 20, color: isDark ? AppPalette.black2.withValues(alpha: 0.6): AppPalette.black2),
                    ),
                  ],
                ),
                AnimatedAlign(
                  alignment: isDark
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  duration: animationDuration,
                  child: Padding(
                        padding: .symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: animationDuration,
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                            shape: .circle,
                            color: isDark
                                ? AppPalette.black2
                                : AppPalette.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        const CustomNeedhelp(),
      ],
    );
  }
}
