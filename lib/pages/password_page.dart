import 'package:chat_app/constants.dart';
import 'package:chat_app/models/user_data.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});
  static const String id = 'password_page';

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  String? errMessage;
  bool isLoading = false;

  Future<void> validateAndProceed(UserData userData) async {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      setState(() => errMessage = 'Please enter your password');
      return;
    }

    setState(() {
      errMessage = null;
      isLoading = true;
    });

    try {
      // Create Auth user
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userData.email!.trim(),
        password: password,
      );

      // Save user in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': userData.firstName ?? '',
        'surName': userData.surName ?? '',
        'age': userData.age ?? 0,
        'email': userData.email ?? '',
        'friends': [],
        'sentRequests': [],
        'receivedRequests': [],
      });

      Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() => errMessage = e.message);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData =
        ModalRoute.of(context)!.settings.arguments as UserData;

    return Scaffold(
      backgroundColor: Color(kprimaryColor),
      appBar: AppBar(
        backgroundColor: Color(kprimaryColor),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "What's your password?",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'password',
            controller: passwordController,
            hasError: errMessage != null,
          ),
          if (errMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 20),
          CustomButton(
            text: isLoading ? 'Creating...' : 'Create Account',
            boxColor: const Color(0xFF0865FE),
            textColor: Colors.white,
            onTap: isLoading ? null : () => validateAndProceed(userData),
          ),
          const Spacer(),
          CustomButton(
            text: 'Already have an account',
            boxColor: Color(kprimaryColor),
            textColor: const Color(0xFF0865FE),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.id, (route) => false);
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
