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
  final TextEditingController ageController = TextEditingController();
  String? errMessage;
  
  
  void validateAndProceed(UserData userData) {

    if(ageController.text.isEmpty){
      setState(() {
        errMessage = 'Please enter a valid number';
      });
      return;
    }
    setState(() {
      errMessage = null;
    });

    userData.age = int.tryParse(ageController.text);
    Navigator.pushNamed(context, EmailPage.id, arguments: userData);
  }

  @override
  void dispose() {
    // Important: release memory for controllers
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //recive datauser from Namepage
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
              "How old are you?",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Age',
            controller: ageController,
            hasError: errMessage != null,
          ),
          const SizedBox(height: 10),
          if (errMessage != null) ...[
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
          const SizedBox(height: 10),
          CustomButton(
            text: 'Next',
            boxColor: Color(0xFF0865FE),
            textColor: Colors.white,
            onTap:  () => validateAndProceed(userData),
          ),
          const Spacer(),
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
          const SizedBox(height: 35),
        ],
      ),
    );
  }
}
