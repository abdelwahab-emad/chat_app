import 'package:chat_app/constants.dart';
import 'package:chat_app/models/user_data.dart';
import 'package:chat_app/pages/email_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class AgePage extends StatefulWidget {
  const AgePage({super.key});

  static const String id = 'age_page';

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
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
                "How old are you?",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 24, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Age',
              controller: ageController,
              prefixIcon: Icons.calendar_month_outlined,
              keyboardType: TextInputType.number, 
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
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
                  userData.age = int.tryParse(ageController.text);
                  Navigator.pushNamed(context, EmailPage.id, arguments: userData);
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