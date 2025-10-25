import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'utils/theme_provider.dart';
import 'utils/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  // 환경 변수 로드 (Web에서 실패해도 무시)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // Web에서는 .env 파일을 로드할 수 없으므로 무시
    debugPrint('Warning: .env 파일을 로드할 수 없습니다. 기본값을 사용합니다.');
  }

  // ThemeProvider 초기화
  final themeProvider = ThemeProvider();
  await themeProvider.init();

  // LocationProvider 초기화
  final locationProvider = LocationProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: locationProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: '맑음지기',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode == AppThemeMode.system
          ? ThemeMode.system
          : themeProvider.themeMode == AppThemeMode.dark
              ? ThemeMode.dark
              : ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
