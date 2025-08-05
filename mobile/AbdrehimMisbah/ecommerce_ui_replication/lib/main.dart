// lib/main.dart
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/pages/sign_in_screen.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/product/injection_container.dart' as di;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await di.init(); // Setup Dependency Injection
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       onGenerateRoute: AppRouter.onGenerateRoute,
//     );
//   }
// }

void main() {
  runApp(
    const MaterialApp(home: SignInScreen(), debugShowCheckedModeBanner: false),
  );
}
