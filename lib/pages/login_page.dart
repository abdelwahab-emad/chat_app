import 'package:chat_app/constants.dart';
import 'package:chat_app/models/user_data.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/name_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/login_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errMessage;
  bool isLoading = false;

  Future<void> login() async {
    if (emailAddressController.text.isEmpty &&
        passwordController.text.isEmpty) {
      setState(() {
        errMessage = 'please enter your email address and password';
      });
      return;
    } else if (emailAddressController.text.isEmpty) {
      setState(() {
        errMessage = 'please enter your email address';
      });
      return;
    } else if (passwordController.text.isEmpty) {
      setState(() {
        errMessage = 'please enter your password';
      });
      return;
    }
    setState(() {
      errMessage = null;
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddressController.text.trim(),
        password: passwordController.text.trim(),
      );

      //success
      Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errMessage = e.message ?? 'Login failed';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C151A),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(220),
        child: LoginAppBar(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            const SizedBox(height: 70),
            CustomTextField(
              hintText: 'email address',
              controller: emailAddressController,
              hasError:
                  errMessage != null && emailAddressController.text.isEmpty,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: 'password',
              controller: passwordController,
              hasError: errMessage != null && passwordController.text.isEmpty,
            ),
            const SizedBox(height: 10),
            if (errMessage != null) ...[
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            CustomButton(
              text: isLoading ? 'Loading..' : 'Log in',
              boxColor: Color(0xFF0865FE),
              textColor: Colors.white,
              onTap: isLoading ? null : login,
            ),
            const SizedBox(height: 230),
            CustomButton(
              onTap: () {
                UserData newUser = UserData();
                Navigator.pushNamed(context, NamePage.id, arguments: newUser);
              },
              text: 'Create an account',
              boxColor: Color(kprimaryColor),
              textColor: Color(0xFF0865FE),
            ),
          ],
        ),
      ),
    );
  }
}

