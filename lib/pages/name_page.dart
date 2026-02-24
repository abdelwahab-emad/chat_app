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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  String? errMessage;

  @override
  void dispose() {
    // Important: release memory for controllers
    firstNameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  void validateAndProceed() {
    if (firstNameController.text.isEmpty && surnameController.text.isEmpty) {
      setState(() {
        errMessage = 'Please enter your first name and surname';
      });
      return;
    } else if (firstNameController.text.isEmpty) {
      setState(() {
        errMessage = 'Please enter your first name';
      });
      return;
    } else if (surnameController.text.isEmpty) {
      setState(() {
        errMessage = 'Please enter your surname';
      });
      return;
    }
 
    //to store name and surname in userdata
    UserData userData = UserData(
      firstName: firstNameController.text,
      surName: surnameController.text,
    );

    
    setState(() {
      errMessage = null;
    });

    Navigator.pushNamed(
      context,
      AgePage.id,
      arguments: userData,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "What's your name?",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Enter the name you use in real life.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'First name',
            controller: firstNameController,
            hasError: errMessage != null && firstNameController.text.isEmpty,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hintText: 'Surname',
            controller: surnameController,
            hasError: errMessage != null && surnameController.text.isEmpty,
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
            onTap: validateAndProceed,
          ),

          const Spacer(),
          CustomButton(
            text: 'already have account',
            boxColor: Color(kprimaryColor),
            textColor: Color(0xFF0865FE),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }
}
