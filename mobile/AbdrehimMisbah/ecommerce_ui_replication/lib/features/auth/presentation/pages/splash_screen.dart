import 'package:flutter/material.dart';

class EcomScreen extends StatelessWidget {
  const EcomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/SplashBG.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF3F51F3),
                    Color(
                      0x903F51F3,
                    ), // Light transparent blue at the top (25% opacity)
                  ],
                  stops: [0.0, 1.0], // Adjust fade transition
                ),
              ),
            ),
          ),

          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // White Card with ECOM text
                Container(
                  width: 264,
                  height: 121,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(31),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'ECOM',
                    style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: 112.89,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.02 * 112.89, // 2%
                      height: 117.41 / 112.89, // line-height / font-size
                      textBaseline: TextBaseline.alphabetic,
                      color: Color(0xFF3F51F3),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Centered Poppins text
                const Text(
                  'Ecommerce APP', // Replace with actual text if you want
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 35.98,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.02 * 35.98, // 2%
                    height: 37.42 / 35.98, // line-height / font-size
                    color: Colors.white,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
