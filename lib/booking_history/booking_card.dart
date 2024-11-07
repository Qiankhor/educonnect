import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/booking_history/canceled_booking_card.dart';
import 'package:educonnect/booking_history/pending_booking_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget bookingCard(
  BuildContext context,
  String documentId,
  String bookingId,
  String tutorId,
  String tutorName,
  String userId,
  String userName,
  String subject,
  String level,
  String date,
  String time,
  double rate,
  bool isPending,
  bool isAccepted,
  bool isCompleted,
  bool isCanceled,
) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tutor Name or Student Name with Message Icon in the Same Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Fetch current user ID and determine their role
                  FutureBuilder<String>(
                    future: _getUserRole(userId, tutorId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        String role = snapshot.data ?? "Unknown";
                        // Choose the appropriate name based on the role
                        String displayName =
                            (role == "Student") ? tutorName : userName;
                        return Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 79, 101, 241),
                          ),
                        );
                      } else {
                        return const Text("Unknown Role");
                      }
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigate to chat (Add your chat navigation logic here)
                    },
                    icon: const Icon(
                      Icons.message,
                      color: Color.fromARGB(255, 79, 101, 241),
                      size: 20,
                    ),
                  ),
                ],
              ),
              Text(
                'RM${rate.toStringAsFixed(0)}/hour',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                level,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isCanceled)
                CanceledBookingCard(
                  level: level,
                  date: date,
                  time: time,
                  bookingId: bookingId,
                  tutorId: tutorId,
                  tutorName: tutorName,
                  userId: userId,
                  userName: userName,
                  subject: subject,
                  rate: rate,
                )
              else if (isPending)
                PendingBookingCard(
                  documentId: documentId,
                  level: level,
                  date: date,
                  time: time,
                  tutorName: tutorName,
                  userName: userName,
                  subject: subject,
                  rate: rate,
                  bookingId: bookingId,
                  tutorId: tutorId,
                )
              else
                ElevatedButton(
                  onPressed: () {
                    // Join the meeting logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text("Join the meeting"),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Function to get current user's role by comparing their ID
Future<String> _getUserRole(String userId, String tutorId) async {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == userId) {
    return "Student"; // Current user is the student
  } else if (currentUserId == tutorId) {
    return "Tutor"; // Current user is the tutor
  } else {
    return "Unknown"; // If for some reason the current user is neither
  }
}

Future<String?> _fetchTutorNameFromBookingId(String bookingId) async {
  try {
    QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('bookingId', isEqualTo: bookingId)
        .get();

    return bookingSnapshot.docs.isNotEmpty
        ? bookingSnapshot.docs.first['tutorName']
        : null;
  } catch (e) {
    print("Error fetching tutor name: $e");
    return null;
  }
}

Future<String?> _fetchStudentNameFromBookingId(String bookingId) async {
  try {
    QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('bookingId', isEqualTo: bookingId)
        .get();

    return bookingSnapshot.docs.isNotEmpty
        ? bookingSnapshot.docs.first['userName']
        : null;
  } catch (e) {
    print("Error fetching student name: $e");
    return null;
  }
}
