import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/booking_history/booking_card.dart';
import 'package:educonnect/booking_history/booking_model.dart';
import 'package:flutter/material.dart';

class PastBookings extends StatefulWidget {
  const PastBookings({super.key});

  @override
  _PastBookingsState createState() => _PastBookingsState();
}

class _PastBookingsState extends State<PastBookings> {
  bool showCompleted = true;
  bool showCanceled = false;

  // Stream query based on selected filter
  Stream<QuerySnapshot<Map<String, dynamic>>> _getBookingsStream() {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('isCompleted', isEqualTo: showCompleted)
        .where('isCanceled', isEqualTo: showCanceled)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ToggleButtons(
          isSelected: [showCompleted, showCanceled],
          onPressed: (int index) {
            setState(() {
              if (index == 0) {
                showCompleted = true;
                showCanceled = false;
              } else {
                showCompleted = false;
                showCanceled = true;
              }
            });
          },
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text('Completed'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text('Canceled'),
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _getBookingsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No past bookings.'));
              }

              final bookings = snapshot.data!.docs
                  .map((doc) {
                    try {
                      return Booking.fromFirestore(doc);
                    } catch (e) {
                      print('Error parsing booking: $e');
                      return null;
                    }
                  })
                  .whereType<Booking>()
                  .toList();

              if (bookings.isEmpty) {
                return const Center(
                    child: Text('No completed or canceled bookings.'));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: bookings.map((booking) {
                      return bookingCard(
                        context,
                        booking.documentId ?? '',
                        booking.bookingId,
                        booking.tutorName,
                        booking.subject,
                        booking.level,
                        booking.date,
                        booking.time,
                        booking.price,
                        false, // No reschedule/cancel buttons for past bookings
                        false,
                        booking.isCompleted,
                        booking.isCanceled,
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
