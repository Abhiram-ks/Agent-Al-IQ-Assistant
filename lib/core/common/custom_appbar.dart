import 'package:agent_ai/core/app_manage/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../src/riverpod/toggle_riverpod.dart';
import '../screen_size/media_quary.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final Color? backgroundColor;
  final bool? isTitle;
  final bool? isleading;
  final String? leading;
  final Color? iconColor;
  final List<Widget>? actions;
  const CustomAppBar({
    super.key,
    this.title,
    this.backgroundColor,
    this.iconColor,
    this.isTitle = false,
    this.isleading = false,
    this.leading,
    this.actions,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnable = ref.watch(themeProvider);

    return AppBar(
      centerTitle: true,
      leadingWidth: 120,
      leading: isleading == true ? GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Constant.width(context: context, width: 0.02),
            Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppPalette.blue,
              size: 20,
            ),
            Flexible(
              child: Text(
                leading ?? 'preview',
                style: TextStyle(
                  color: AppPalette.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ): null,
      title: isTitle == true
          ? Text(
              title!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center,
            )
          : null,
      actions: actions,

      backgroundColor: isEnable ? AppPalette.black : AppPalette.white,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: true,
      elevation: 4,
      shadowColor: isEnable
          ? const Color.fromARGB(255, 68, 68, 68)
          : AppPalette.black.withValues(alpha: 0.2),
      scrolledUnderElevation: 4,
      titleSpacing: 0,
      iconTheme: IconThemeData(
        color: isEnable ? AppPalette.white : AppPalette.black,
      ),
    );
  }
}
