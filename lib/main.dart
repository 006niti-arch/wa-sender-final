// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wa_sender_pro/firebase_options.dart';
import 'package:wa_sender_pro/l10n/app_localizations_manual.dart';
import 'package:wa_sender_pro/providers/campaign_provider.dart';
import 'package:wa_sender_pro/providers/locale_provider.dart';
import 'package:wa_sender_pro/screens/auth_gate.dart';
import 'package:wa_sender_pro/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CampaignProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: const AppContent(),
    );
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'WA Sender Pro',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizationsManual.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      home: const AuthGate(),
    );
  }
}
