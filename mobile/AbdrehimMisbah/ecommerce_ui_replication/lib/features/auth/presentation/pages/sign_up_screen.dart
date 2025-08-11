import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isChecked = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _onRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!isChecked) return;
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return;
    }
    if (password != confirmPassword) return;

    context.read<AuthBloc>().add(
      RegisterEvent(name: name, email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF3F51F3);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: {
              'userName': state.user.name,
              'userEmail': state.user.email,
              'userId': state.user.id,
            },
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 31.0,
                  right: 31.0,
                  top: 64,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                '/login',
                              ),
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.chevron_left,
                                  size: 30,
                                  color: blueColor,
                                ),
                              ),
                            ),
                            Container(
                              width: 78,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.41),
                                border: Border.all(
                                  width: 0.93,
                                  color: blueColor,
                                ),
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
                        CustomInputField(
                          label: 'Name',
                          placeholder: 'ex: jon smith',
                          controller: _nameController,
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          label: 'Email',
                          placeholder: 'ex: jon.smith@email.com',
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          label: 'Password',
                          placeholder: '*********',
                          obscure: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          label: 'Confirm Password',
                          placeholder: '*********',
                          obscure: true,
                          controller: _confirmPasswordController,
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
                                    color: blueColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(1),
                                  color: isChecked
                                      ? blueColor
                                      : Colors.transparent,
                                ),
                                child: isChecked
                                    ? const Icon(
                                        Icons.check,
                                        size: 10,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text.rich(
                              TextSpan(
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
                            onPressed: state is AuthLoading
                                ? null
                                : _onRegister,
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Have an account? ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                '/login',
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: blueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final bool obscure;
  final String placeholder;
  final TextEditingController controller;

  const CustomInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.obscure = false,
    required this.controller,
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
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                height: 49.85 / 15,
                letterSpacing: 0.02,
                color: Color(0xFF888888),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
