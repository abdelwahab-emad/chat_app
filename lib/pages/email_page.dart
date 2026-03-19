import 'package:chat_app/constants.dart';
import 'package:chat_app/models/user_data.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/password_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  static const String id = 'email_page';

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as UserData;

    return Scaffold(
      backgroundColor: const Color(0xFF0C151A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C151A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "What's your email address?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Email address',
              controller: emailController,
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Next',
              boxColor: const Color(0xFF0865FE),
              textColor: Colors.white,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  userData.email = emailController.text.trim();
                  Navigator.pushNamed(
                    context,
                    PasswordPage.id,
                    arguments: userData,
                  );
                }
              },
            ),
            const Spacer(),
            CustomButton(
              text: 'Already have an account',
              boxColor: const Color(kprimaryColor),
              textColor: const Color(0xFF0865FE),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginPage.id,
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}