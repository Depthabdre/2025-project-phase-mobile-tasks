// lib/main.dart
import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import './features/product/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Important when awaiting in main()
  await di.init(); // Wait for DI setup
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
