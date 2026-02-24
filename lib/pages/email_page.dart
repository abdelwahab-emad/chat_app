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
  final TextEditingController emailController = TextEditingController();
  String? errMessage;

  void validateAndProceed(UserData userData) {
    if (emailController.text.isEmpty) {
      setState(() {
        errMessage = 'Please enter your email';
      });
      return;
    }

    setState(() {
      errMessage = null;
    });

    userData.email = emailController.text;

    Navigator.pushNamed(context, PasswordPage.id, arguments: userData);
  }

  @override
  void dispose() {
    // Important: release memory for controllers
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final userData = ModalRoute.of(context)!.settings.arguments as UserData;
    
    return Scaffold(
      backgroundColor: Color(kprimaryColor),
      appBar: AppBar(
        backgroundColor: Color(kprimaryColor),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "What's your email address?",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          SizedBox(height: 20),
          CustomTextField(
            hintText: 'email address',
            controller: emailController,
            hasError: errMessage != null,
          ),
          SizedBox(height: 10),
          if (errMessage != null) ...[
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
          SizedBox(height: 10),
          CustomButton(
            text: 'Next',
            boxColor: Color(0xFF0865FE),
            textColor: Colors.white,
            onTap: () => validateAndProceed(userData),
          ),
          Spacer(),
          CustomButton(
            text: 'already have account',
            boxColor: Color(kprimaryColor),
            textColor: Color(0xFF0865FE),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginPage.id,
                (route) => false,
              );
            },
          ),
          SizedBox(height: 35),
        ],
      ),
    );
  }
}
