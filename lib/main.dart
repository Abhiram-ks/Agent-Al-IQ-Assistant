import 'package:agent_ai/core/app_manage/app_themes.dart';
import 'package:agent_ai/core/local_storages/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'core/routes/routes.dart';
import 'src/riverpod/toggle_riverpod.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await LocalStorage.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agent Al : IQ Assistant',
      initialRoute: Routes.home,
      theme:  isDark ? AppThemes.darkTheme: AppThemes.lightTheme,
      darkTheme:AppThemes.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
