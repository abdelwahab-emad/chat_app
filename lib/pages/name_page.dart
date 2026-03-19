import 'package:chat_app/constants.dart';
import 'package:chat_app/models/user_data.dart';
import 'package:chat_app/pages/age_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  static const String id = 'name_page';

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                "What's your name?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Enter the name you use in real life.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'First name',
              controller: firstNameController,
              prefixIcon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: 'Surname',
              controller: surnameController,
              prefixIcon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your surname';
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
                  UserData userData = UserData(
                    firstName: firstNameController.text.trim(),
                    surName: surnameController.text.trim(),
                  );
                  Navigator.pushNamed(
                    context,
                    AgePage.id,
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
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}