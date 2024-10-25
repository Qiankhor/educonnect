import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/booking_history/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String level;
  final String date;
  final String timeSlot;
  final String tutorName;
  final String tutorSubject;
  final String bookingId;
  final double price;
  final bool isPast;

  const BookingConfirmationPage({
    super.key,
    required this.level,
    required this.date,
    required this.timeSlot,
    required this.tutorName,
    required this.tutorSubject,
    required this.bookingId,
    required this.price,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Session Details',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _detailRow('Booking Date:', date),
            const SizedBox(height: 5),
            _detailRow('Time:', timeSlot),
            const SizedBox(height: 5),
            _detailRow('Tutor:', tutorName),
            const SizedBox(height: 5),
            _detailRow('Subject:', tutorSubject),
            const SizedBox(height: 5),
            _detailRow('Education Level:', level),
            const Divider(height: 30, thickness: 1),
            const Text(
              'Booking Summary',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _detailRow('Confirmation Number:', bookingId),
            const SizedBox(height: 5),
            _detailRow('Price:', 'RM${price.toStringAsFixed(2)}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: isPast
                  ? const SizedBox() // Empty widget when it's a past booking
                  : ElevatedButton(
                      onPressed: () async {
                        // Create a Booking object to pass back
                        final newBooking = Booking(
                          bookingId: bookingId,
                          tutorName: tutorName,
                          subject: tutorSubject,
                          level: level,
                          date: date,
                          time: timeSlot,
                          price: price,
                          isPending: true,
                          isAccepted: false,
                          isCompleted: false,
                          isCanceled: false,
                        );

                        try {
                          await FirebaseFirestore.instance
                              .collection('bookings')
                              .add({
                            'bookingId': bookingId,
                            'tutorName': tutorName,
                            'subject': tutorSubject,
                            'level': level,
                            'date': date,
                            'time': timeSlot,
                            'price': price,
                            'isPending': true,
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          Fluttertoast.showToast(
                            msg: "Your booking is successful!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor:
                                const Color.fromARGB(255, 34, 145, 38),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          Navigator.pop(context, newBooking);
                        } catch (e) {
                          print('Error saving booking: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Failed to save booking. Please try again.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create detail rows for better readability
  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
