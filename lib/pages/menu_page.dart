import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/requests_page.dart';
import 'package:chat_app/widgets/bottom_nav_bar.dart';
import 'package:chat_app/widgets/menu_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  static String id = 'menu_page';
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPage.id,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Color(0xFF0865FE),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = '${data['firstName']} ${data['surName']}';
          final email = data['email'];
          final requests = List.from(data['receivedRequests'] ?? []);
          final requestsCount = requests.length;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(skprimaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              MenuItem(
                title: 'Profile',
                icon: Icons.person_outline,
                onTap: () {
                  Navigator.pushNamed(context, ProfilePage.id);
                },
              ),

              MenuItem(
                title: 'Friend Requests',
                icon: Icons.group_add_outlined,
                badgeCount: requestsCount,
                onTap: () {
                  Navigator.pushNamed(context, RequestsPage.id);
                },
              ),
              const Divider(thickness: 1, indent: 20, endIndent: 20),

              MenuItem(
                icon: Icons.logout,
                title: 'Sign Out',
                isDestructive: true,
                onTap: () => signOut(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
     );
  }
}
