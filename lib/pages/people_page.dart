import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});
  static const String id = 'people_page';

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> friends = [];
  List<String> sentRequests = [];

  @override
  void initState() {
    super.initState();
    loadMyData();
  }

  Future<void> loadMyData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        friends = List<String>.from(data['friends'] ?? []);
        sentRequests = List<String>.from(data['sentRequests'] ?? []);
      });
    }
  }

  Future<void> sendRequest(String userId) async {
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final myRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);
      final otherRef = FirebaseFirestore.instance.collection('users').doc(userId);

      tx.update(myRef, {
        'sentRequests': FieldValue.arrayUnion([userId]),
      });

      tx.update(otherRef, {
        'receivedRequests': FieldValue.arrayUnion([currentUserId]),
      });
    });
    loadMyData();
  }

  Future<void> removeFriend(String userId) async {
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final myRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);
      final otherRef = FirebaseFirestore.instance.collection('users').doc(userId);

      tx.update(myRef, {
        'friends': FieldValue.arrayRemove([userId]),
      });

      tx.update(otherRef, {
        'friends': FieldValue.arrayRemove([currentUserId]),
      });
    });
    loadMyData();
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
          'People',
          style: TextStyle(
            color: Color(0xFF0865FE),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final user = users[index];

              if (user.id == currentUserId) {
                return const SizedBox.shrink();
              }

              final data = user.data() as Map<String, dynamic>;
              final name = '${data['firstName'] ?? ''} ${data['surName'] ?? ''}'.trim();
              final isFriend = friends.contains(user.id);
              final isPending = sentRequests.contains(user.id);

              String buttonText;
              Color buttonColor;
              VoidCallback? onTap;

              if (isFriend) {
                buttonText = 'Remove';
                buttonColor = Colors.grey.shade300;
                onTap = () => removeFriend(user.id);
              } else if (isPending) {
                buttonText = 'Pending';
                buttonColor = Colors.grey.shade200;
                onTap = null;
              } else {
                buttonText = 'Add Friend';
                buttonColor = const Color(0xFF0865FE);
                onTap = () => sendRequest(user.id);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0865FE),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        name.isEmpty ? 'Unknown User' : name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            color: isFriend || isPending ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}