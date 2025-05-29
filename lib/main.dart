import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masraf_app/shared/constants/app_theme.dart';
import 'package:masraf_app/shared/router/app_router.dart';
import 'package:masraf_app/shared/providers/settings_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MasrafApp()));
}

class MasrafApp extends ConsumerWidget {
  const MasrafApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'MasrafApp',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(settingsProvider).themeMode,
      locale: ref.watch(settingsProvider).locale,
      builder: (context, child) {
        final fontSize = ref.watch(settingsProvider).fontSize;
        final scale = fontSize == AppFontSize.small
            ? 0.8
            : fontSize == AppFontSize.large
                ? 1.2
                : 1.0;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
          child: child!,
        );
      },
      routerConfig: router,
    );
  }
}
