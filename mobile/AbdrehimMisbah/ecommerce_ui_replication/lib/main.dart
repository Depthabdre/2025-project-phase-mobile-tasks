import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget userIntro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Container(
          width: 30, // Container width
          height: 30, // Container height
          decoration: BoxDecoration(
            color: Colors.grey[400], // Fill color
            borderRadius: BorderRadius.circular(6), // Rounded corners
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'July 17, 2025',
              style: TextStyle(color: Colors.grey[600], fontSize: 8),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: 'Hello, ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ), // Default style

                children: [
                  TextSpan(
                    text: 'Yohannes',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: userIntro(),
      ),
      body: const Center(child: Text('Welcome!')),
    );
  }
}
