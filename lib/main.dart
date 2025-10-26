import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/app/shell/bottom_nav_shell.dart';
import 'package:fitpill/core/system/services/notification_service.dart';
import 'package:fitpill/core/system/config/locale/locale_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:fitpill/core/system/config/theme/theme_providers.dart';
import 'package:fitpill/features/auth/auth_notifier.dart';
import 'firebase_options.dart';
import 'package:fitpill/features/auth/pages/onboarding_page.dart';
import 'package:fitpill/app/route_observer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  await NotificationService.initialize();
  await NotificationService.handleRemoteMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // KRİTİK: DotEnv dosyasını Firebase'den önce yükle

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.initialize();

  // DEBUG/SIMULATOR için:
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug, // iOS simülatör
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. YÜKLEME DURUMUNU İZLE
    final themeInitStatus = ref.watch(themeInitializationProvider);
    final localeInitStatus = ref.watch(localeInitializationProvider);

    final strings = S.of(context);

    // Kayıt işlemini bir mikro göreve sarıyoruz. Bu, builder fazında state'i
    // değiştirmemizi engellerken, o frame'de provider'ı doldurur.
    Future.microtask(() {
      // ✅ DÜZELTME 1: strings'i kullanmadan önce null kontrolü yapın.
      if (strings != null) {
        ref.read(currentStringsProvider.notifier).setStrings(strings);
      }
    });



    // 2. YÜKLEME BİTENE KADAR BEKLE (İki Provider'ı da kontrol et)
    // FutureProvider'larımızın .when metotlarını kullanalım, daha temiz.
    final bool isAppReady = themeInitStatus.isLoading || localeInitStatus.isLoading;

    if (isAppReady) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: AppPageShimmer()),
        ),
      );
    }

    // 3. HATA DURUMUNU YÖNET
    if (themeInitStatus.hasError || localeInitStatus.hasError) {
      // Hata durumunda sabit bir hata ekranı döndür.
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Uygulama başlatma hatası.')),
        ),
      );
    }

    // 4. VERİLER YÜKLENDİ: Gerekli state'leri izle
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localizationProvider);
    final userAsync = ref.watch(authProvider);

    // 4. YÖNLENDİRME MANTIĞI (Auth State'e göre)
    final Widget homeScreen = userAsync.when(
      loading: () => const Center(child: AppPageShimmer()),
      error: (_, __) => const OnboardingPage(),
      data: (user) {
        if (user == null) {
          return const OnboardingPage();
        }

        // 🚨 KRİTİK: Kullanıcı profil kurulumu kontrolü
        // Profile Notifier'ı (SetupPage mantığını) buraya bağlamamız gerekecek.
        // Şimdilik varsayalım profil tamamlanmış:
        return const MainMenu();
      },
    );



    // 6. MATERİAL APP'İ DÖNDÜR
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: S.supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: false,
      title: 'FitPill',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: ThemeHelper.getBackgroundColor(context),
        appBarTheme: AppBarTheme(
          backgroundColor: ThemeHelper.getBackgroundColor(context),
          foregroundColor: ThemeHelper.getTextColor(context),
          elevation: 0,
          centerTitle: true,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        textTheme: GoogleFonts.tomorrowTextTheme(),
      ),
      darkTheme: ThemeData.dark().copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        textTheme: GoogleFonts.tomorrowTextTheme(),
      ),
      themeMode: themeMode,
      home: homeScreen,
      navigatorObservers: [routeObserver],
      builder: (context, child) {
        final textColor = ThemeHelper.getTextColor(context);

        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.tomorrowTextTheme().apply(
              bodyColor: textColor,
              displayColor: textColor,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
