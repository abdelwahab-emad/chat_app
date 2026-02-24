import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static String id = 'Profile_page';
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;
  bool isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> updateProfile() async {
    if (firstNameController.text.isEmpty || surnameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'firstName': firstNameController.text.trim(),
            'surName': surnameController.text.trim(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated Successfully! ✅'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Color(skprimaryColor)),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && firstNameController.text.isEmpty) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            firstNameController.text = data['firstName'];
            surnameController.text = data['surName'];
            emailController.text = data['email'];
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade200,
                            child: Text(
                              firstNameController.text[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: firstNameController,
                        hintText: 'First Name',
                        prefixIcon: Icons.person,
                        textColor: Colors.black,
                      ),

                      SizedBox(height: 20),

                      CustomTextField(
                        controller: surnameController,
                        hintText: 'SurName',
                        prefixIcon: Icons.person,
                        textColor: Colors.black,
                      ),

                      SizedBox(height: 20),

                      CustomTextField(
                        controller: emailController,
                        hintText: 'Email Address',
                        prefixIcon: Icons.email,
                        readOnly: true,
                        textColor: Colors.black,
                      ),

                      SizedBox(height: 200),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(skprimaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
