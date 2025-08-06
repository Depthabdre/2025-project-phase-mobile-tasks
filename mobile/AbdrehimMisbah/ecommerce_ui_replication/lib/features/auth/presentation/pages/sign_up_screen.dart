import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF3F51F3);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 31.0, right: 31.0, top: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chevron_left,
                    size: 30,
                    color: blueColor,
                  ),
                ),
                Container(
                  width: 78,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.41),
                    border: Border.all(width: 0.93, color: blueColor),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'ECOM',
                    style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                      letterSpacing: 0.02,
                      color: blueColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            // Title
            const Text(
              'Create your account',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 26.72,
                letterSpacing: 0.02,
              ),
            ),

            const SizedBox(height: 40),

            // Form Fields
            const CustomInputField(label: 'Name', placeholder: 'ex: jon smith'),
            const SizedBox(height: 20),
            const CustomInputField(
              label: 'Email',
              placeholder: 'ex: jon.smith@email.com',
            ),
            const SizedBox(height: 20),
            const CustomInputField(
              label: 'Password',
              placeholder: '*********',
              obscure: true,
            ),
            const SizedBox(height: 20),
            const CustomInputField(
              label: 'Confirm Password',
              placeholder: '*********',
              obscure: true,
            ),
            const SizedBox(height: 30),

            // Checkbox & Terms
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() => isChecked = !isChecked);
                  },
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF3F51F3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(1),
                      color: isChecked
                          ? const Color(0xFF3F51F3)
                          : Colors.transparent,
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, size: 10, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: 'I understood the '),
                      TextSpan(
                        text: 'terms',
                        style: TextStyle(color: blueColor),
                      ),
                      TextSpan(text: ' & '),
                      TextSpan(
                        text: 'policy.',
                        style: TextStyle(color: blueColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: 288,
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.02,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Footer
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Have an account? ',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                ),
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: blueColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final bool obscure;
  final String placeholder;

  const CustomInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            letterSpacing: 0.02,
            color: Color(0xFF6F6F6F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 288,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA), // Background color
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: TextField(
            obscureText: obscure,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: placeholder, // You can replace this dynamically
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                height: 49.85 / 15, // Line height approximation
                letterSpacing: 0.02,
                color: Color(0xFF888888), // Placeholder text color
              ),
              border: InputBorder.none, // No border
            ),
          ),
        ),
      ],
    );
  }
}
