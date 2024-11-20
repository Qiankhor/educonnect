import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/booking_confirmation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CompletedBookingCard extends StatefulWidget {
  final String level;
  final String date;
  final String time;
  final String bookingId;
  final String tutorId;
  final String tutorName;
  final String userId;
  final String userName;
  final String subject;
  final double rate;

  const CompletedBookingCard({
    super.key,
    required this.level,
    required this.date,
    required this.time,
    required this.bookingId,
    required this.tutorId,
    required this.tutorName,
    required this.userId,
    required this.userName,
    required this.subject,
    required this.rate,
  });

  @override
  _CompletedBookingCardState createState() => _CompletedBookingCardState();
}

class _CompletedBookingCardState extends State<CompletedBookingCard> {
  String? role;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          role = userDoc['role'];
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Unable to fetch user role.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _showRatingDialog() async {
    double currentRate = 0.0;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Rate ${widget.tutorName}',
            style: const TextStyle(fontSize: 20),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure the dialog is not too large
            children: [
              PannableRatingBar(
                rate: currentRate,
                items: List.generate(
                  5, // Number of rating items (e.g., 5 stars)
                  (index) => const RatingWidget(
                    selectedColor: Colors.amber,
                    unSelectedColor: Colors.grey,
                    child: Icon(Icons.star),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (role == 'Student')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showRatingDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                child: const Text(
                  "Confirm session",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingConfirmationPage(
                    level: widget.level,
                    date: widget.date,
                    timeSlot: widget.time,
                    bookingId: widget.bookingId,
                    tutorId: widget.tutorId,
                    tutorName: widget.tutorName,
                    userId: widget.userId,
                    userName: widget.userName,
                    tutorSubject: widget.subject,
                    price: widget.rate,
                    isPast: true,
                  ),
                ),
              );
            },
            child: const Text(
              "View Details",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
