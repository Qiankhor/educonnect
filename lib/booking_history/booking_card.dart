import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/booking_confirmation.dart';
import 'package:flutter/material.dart';

// Widget to create the booking card
Widget bookingCard(
  BuildContext context,
  String documentId,
  String bookingId,
  String tutorName,
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
          // Tutor Name with Message Icon in the Same Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    tutorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 79, 101, 241),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigate to chat
                    },
                    icon: const Icon(
                      Icons.message,
                      color: Color.fromARGB(255, 79, 101, 241),
                      size: 20,
                    ),
                  ),
                ],
              ),
              // Display the rate on the right side
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
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                level,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Conditional buttons based on booking type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isCanceled)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingConfirmationPage(
                              level: level,
                              date: date,
                              timeSlot: time,
                              bookingId: bookingId,
                              tutorName: tutorName,
                              tutorSubject: subject,
                              price: rate,
                              isPast: true,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 80, 79, 79),
                      ),
                      child: const Text(
                        "View details",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              else if (isPending)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        onPressed: () async {
                          _showCancellationConfirmation(documentId, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        onPressed: () {
                          // Reschedule booking logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Reschedule"),
                      ),
                    ),
                  ],
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

// Show confirmation dialog for cancellation
void _showCancellationConfirmation(String documentId, BuildContext context) {
  final rootContext = context; // Save the root context

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Cancellation'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await _cancelBooking(
                  documentId, rootContext); // Use rootContext here
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

Future<void> _cancelBooking(String documentId, BuildContext context) async {
  print('Attempting to cancel booking with Document ID: $documentId');

  try {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('bookings').doc(documentId);
    DocumentSnapshot doc = await docRef.get();

    if (!doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking not found. Cannot cancel.'),
        ),
      );
      return;
    }

    // Update the booking document instead of deleting it
    await docRef.update({
      'isCanceled': true,
      'isPending': false,
      'isAccepted': false,
      'isCompleted': false,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking cancelled successfully.'),
      ),
    );
  } catch (e) {
    print('Error cancelling booking: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to cancel booking. Please try again.'),
      ),
    );
  }
}
