import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_app/models/user_data.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_snackbar.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});
  static const String id = 'password_page';

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordObscure = true;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as UserData;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is RegisterSuccess) {
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set({
                    'firstName': userData.firstName ?? '',
                    'surName': userData.surName ?? '',
                    'age': userData.age ?? 0,
                    'email': userData.email ?? '',
                    'friends': [],
                    'sentRequests': [],
                    'receivedRequests': [],
                  });
            }
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomePage.id,
              (route) => false,
            );
          } catch (e) {
            if (!context.mounted) return;
            showCustomSnackBar(
              context,
              "User created but failed to save profile.",
            );
          }
        } else if (state is RegisterFailure) {
          showCustomSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
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
                    "What's your password?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: isPasswordObscure,
                  suffixIcon: isPasswordObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onSuffixPressed: () {
                    setState(() {
                      isPasswordObscure = !isPasswordObscure;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                state is RegisterLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0865FE),
                        ),
                      )
                    : CustomButton(
                        text: 'Create Account',
                        boxColor: const Color(0xFF0865FE),
                        textColor: Colors.white,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context).registerUser(
                              email: userData.email!.trim(),
                              password: passwordController.text.trim(),
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
