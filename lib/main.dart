import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Removido listener global de conectividade; a verificação será feita por tela específica

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingSeen = prefs.getBool('onboardingSeen') ?? false;
  runApp(MyApp(onboardingSeen: onboardingSeen));
}

class MyApp extends StatelessWidget {
  final bool onboardingSeen;
  const MyApp({super.key, required this.onboardingSeen});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Algoritmos de Ordenação',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: onboardingSeen
          ? (user != null ? AppRoutes.home : AppRoutes.login)
          : AppRoutes.onboarding,
      routes: AppRoutes.getRoutes(),
    );
  }
}
