// lib/main.dart
import 'package:flutter/material.dart';

import './features/auth/injection_container.dart' as di_auth;
import './features/chat/injection_container.dart' as chat_di;
import 'core/router/app_router.dart';
import 'features/product/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init(); // Initialize product dependencies
  await di_auth.initAuth(); // Initialize auth dependencies
  await chat_di.initChat(); // Chat feature dependencies

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

// void main() {
//   runApp(
//     const MaterialApp(
//       home: ChatListScreen(),
//       debugShowCheckedModeBanner: false,
//     ),
//   );
// }
