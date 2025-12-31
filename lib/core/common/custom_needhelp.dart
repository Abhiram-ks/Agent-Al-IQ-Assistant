import 'package:agent_ai/src/riverpod/toggle_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_manage/app_color.dart';

class CustomNeedhelp extends ConsumerWidget {
  const CustomNeedhelp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: isDark
            ? AppPalette.black2.withValues(alpha: 0.6)
            : AppPalette.hint,
        borderRadius: .circular(40),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(40),
          child: Center(
            child: Icon(
              Icons.document_scanner,
              size: 19,
              color: isDark ? AppPalette.white : AppPalette.black2,
            ),
          ),
        ),
      ),
    );
  }
}
