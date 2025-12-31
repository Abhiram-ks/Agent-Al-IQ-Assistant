import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/local_storages/shared_preferences.dart';

final themeProvider = NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return LocalStorage.instance.getBool("isDark") ?? false;
  }

  void toggle() {
    state = !state;
    LocalStorage.instance.setBool("isDark", state);
  }

  void setTheme(bool isDark) {
    state = isDark;
    LocalStorage.instance.setBool("isDark", state);
  }
}
