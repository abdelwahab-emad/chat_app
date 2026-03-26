import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_app/models/user_data.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/main_layout_page.dart';
import 'package:chat_app/pages/name_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_snackbar.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/login_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formkey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            MainLayoutPage.id,
            (route) => false,
          );
        } else if (state is LoginFailure) {
          showCustomSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0C151A),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(200),
            child: LoginAppBar(),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 50),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  CustomTextField(
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                    labelText: 'Email Address',
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
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: isPasswordObscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    obscureText: isPasswordObscure,
                    onSuffixPressed: () {
                      setState(() {
                        isPasswordObscure = !isPasswordObscure;
                      });
                    },
                    labelText: 'Password',
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
                  const SizedBox(height: 25),
                  state is LoginLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0865FE),
                          ),
                        )
                      : CustomButton(
                          text: 'Log in',
                          boxColor: const Color(0xFF0865FE),
                          textColor: Colors.white,
                          onTap: () {
                            if (formkey.currentState!.validate()) {
                              BlocProvider.of<AuthCubit>(context).loginUser(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            }
                          },
                        ),
                  const SizedBox(height: 230),
                  CustomButton(
                    onTap: () {
                      UserData newUser = UserData();
                      Navigator.pushNamed(
                        context,
                        NamePage.id,
                        arguments: newUser,
                      );
                    },
                    text: 'Create an account',
                    boxColor: const Color(kprimaryColor),
                    textColor: const Color(0xFF0865FE),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
