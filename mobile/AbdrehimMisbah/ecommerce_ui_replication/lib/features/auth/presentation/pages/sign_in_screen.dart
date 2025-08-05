import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),

            // The Card with "ecom"
            Container(
              width: 144,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'ECOM',
                style: TextStyle(
                  fontFamily: 'CaveatBrush',
                  fontWeight: FontWeight.w400,
                  fontSize: 48,
                  height: 24.26 / 48,
                  letterSpacing: 0.02,
                  textBaseline: TextBaseline.alphabetic,
                  color: Color(0xFF3F51F3),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Sign into your account
            const Text(
              'Sign into your account',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 26.72,
                height: 111.58 / 26.72,
                letterSpacing: 0.02,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Email label
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 49.85 / 16,
                  letterSpacing: 0.02,
                  color: Colors.black,
                ),
              ),
            ),

            // Email input
            Container(
              width: 288,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'ex: jon.smith@email.com',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 49.85 / 15,
                    letterSpacing: 0.02,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Password label
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 49.85 / 16,
                  letterSpacing: 0.02,
                  color: Colors.black,
                ),
              ),
            ),

            // Password input
            Container(
              width: 288,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '********',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 49.85 / 15,
                    letterSpacing: 0.02,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Sign In Button
            SizedBox(
              width: 288,
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    height: 49.85 / 15,
                    letterSpacing: 0.02,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Bottom sign up prompt
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account? ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 49.85 / 16,
                      letterSpacing: 0.02,
                    ),
                  ),
                  Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 49.85 / 16,
                      letterSpacing: 0.02,
                      decoration: TextDecoration.underline,
                      color: Color(0xFF3F51F3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
