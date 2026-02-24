import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  static String id = 'Requests_page';
  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> acceptRequest(String senderId) async {
    final batch = FirebaseFirestore.instance.batch();
    final myRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId);
    final senderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(senderId);

    batch.update(myRef, {
      'friends': FieldValue.arrayUnion([senderId]),
      'receivedRequests': FieldValue.arrayRemove([senderId]),
    });

    batch.update(senderRef, {
      'friends': FieldValue.arrayUnion([currentUserId]),
      'sentRequests': FieldValue.arrayRemove([currentUserId]),
    });

    await batch.commit();
  }

  Future<void> rejectRequest(String senderId) async {
    final batch = FirebaseFirestore.instance.batch();

    final myRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId);
    final senderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(senderId);

    batch.update(myRef, {
      'receivedRequests': FieldValue.arrayRemove([senderId]),
    });

    batch.update(senderRef, {
      'sentRequests': FieldValue.arrayRemove([currentUserId]),
    });

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Chatapp Friend requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Friend requests',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final myData = snapshot.data!.data() as Map<String, dynamic>;
                  final requests = List<String>.from(
                    myData['receivedRequests'] ?? [],
                  );

                  if (requests.isEmpty) {
                    return Center(
                      child: Text(
                        'No requests yet.',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final senderId = requests[index];

                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(senderId)
                            .get(),
                        builder: (context, senderSnapshot) {
                          if (!senderSnapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          final senderData =
                              senderSnapshot.data!.data()
                                  as Map<String, dynamic>;
                          final name =
                              '${senderData['firstName']} ${senderData['surName']}';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey.shade200,
                                  child: Text(
                                    name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  acceptRequest(senderId),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  skprimaryColor,
                                                ),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                              ),
                                              child: const Text(
                                                'Confirm',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  rejectRequest(senderId),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                              ),
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
