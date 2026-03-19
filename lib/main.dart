import 'package:chat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/age_page.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/email_page.dart';
import 'package:chat_app/pages/menu_page.dart';
import 'package:chat_app/pages/people_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/name_page.dart';
import 'package:chat_app/pages/password_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/requests_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          // Define the routes for the application
          LoginPage.id: (context) => LoginPage(),
          NamePage.id: (context) => NamePage(),
          AgePage.id: (context) => AgePage(),
          EmailPage.id: (context) => EmailPage(),
          PasswordPage.id: (context) => PasswordPage(),
          HomePage.id : (context) => HomePage(),
          PeoplePage.id : (context) => PeoplePage(),
          MenuPage.id : (context) => MenuPage(),
          ChatPage.id : (context) => ChatPage(),
          ProfilePage.id : (context) => ProfilePage(),
          RequestsPage.id : (context) => RequestsPage(),
        },
        initialRoute: LoginPage.id,
      ),
    );
  }
}


