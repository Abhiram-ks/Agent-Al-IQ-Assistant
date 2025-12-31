import 'package:agent_ai/core/app_manage/app_color.dart';
import 'package:agent_ai/core/common/custom_appbar.dart';
import 'package:agent_ai/core/screen_size/media_quary.dart';
import 'package:agent_ai/src/riverpod/toggle_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/custom_toggle_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return Scaffold(
      appBar: CustomAppBar(title: 'Text Recognition', isTitle: true),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [const CostumeToggle()],
                  ),
                  Constant.hight(context: context, hight: .05),

                  TextFormField(
                    cursorColor: isDark ? AppPalette.hint : AppPalette.grey,
                    cursorOpacityAnimates: true,
                    cursorErrorColor: AppPalette.red,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (val) {

                    },
                    decoration: InputDecoration(
                      labelText: 'Enter recognition Text.',
                      labelStyle: TextStyle(
                        color: isDark ? AppPalette.hint : AppPalette.grey,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDark ? AppPalette.black2 : AppPalette.hint,
                          width: 1,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDark ? AppPalette.black2 : AppPalette.hint,
                          width: 1,
                        ),
                      ),

                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDark ? AppPalette.black2 : AppPalette.hint,
                          width: 1,
                        ),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppPalette.red, width: 1),
                      ),

                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppPalette.red,
                          width: 1.5,
                        ),
                      ),

                      suffixIcon: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppPalette.black2
                                  : AppPalette.hint,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.manage_search, size: 22),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
