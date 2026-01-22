import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/paywall_screen.dart';
import 'services/purchase_service.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await PurchaseService().init();
    runApp(const MyApp());
  }, (error, stack) {
    debugPrint('Global Error: $error');
    debugPrint('Stack Trace: $stack');
  });
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/category/:id',
      builder: (context, state) {
        final categoryId = state.pathParameters['id']!;
        return CategoryScreen(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/learn/:phraseId',
      builder: (context, state) {
        final phraseId = state.pathParameters['phraseId']!;
        return LearningScreen(phraseId: phraseId);
      },
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => const EmergencyScreen(),
    ),
    GoRoute(
      path: '/paywall',
      builder: (context, state) => const PaywallScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '100 Chinese Travel Phrases',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE60012), // China Red
          secondary: const Color(0xFFFFD700), // Gold
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansTextTheme(),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
