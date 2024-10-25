import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/booking_history/booking_card.dart';
import 'package:educonnect/booking_history/booking_model.dart';
import 'package:flutter/material.dart';

class UpcomingBookings extends StatefulWidget {
  const UpcomingBookings({Key? key}) : super(key: key);

  @override
  _UpcomingBookingsState createState() => _UpcomingBookingsState();
}

class _UpcomingBookingsState extends State<UpcomingBookings> {
  bool showPending = true; // Show pending bookings by default
  bool showAccepted = false; // Show accepted bookings by default

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Toggle Buttons for Upcoming Bookings
        ToggleButtons(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text('Pending'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text('Accepted'),
            ),
          ],
          isSelected: [showPending, showAccepted],
          onPressed: (int index) {
            setState(() {
              showPending = index == 0;
              showAccepted = index == 1;
            });
          },
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FirebaseFirestore.instance.collection('bookings').snapshots(),
            builder: (context, snapshot) {
              // Check for loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle errors and empty data
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading bookings.'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No upcoming bookings.'));
              }

              // Filter based on toggle selection
              final bookings = snapshot.data!.docs
                  .map((doc) =>
                      Booking.fromFirestore(doc)) // Convert to Booking objects
                  .where((booking) {
                // Ensure the booking is either pending or accepted based on the toggle selection
                if (showPending && booking.isPending) {
                  return true; // Include pending bookings
                } else if (showAccepted && booking.isAccepted) {
                  return true; // Include accepted bookings
                }
                return false; // Exclude other bookings
              }).toList();

              if (bookings.isEmpty) {
                return const Center(
                    child: Text('No bookings found.')); // Handle no bookings
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        booking.isPending,
                        booking.isAccepted,
                        false, // No reschedule/cancel buttons for upcoming bookings
                        false, // Not a past booking
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
