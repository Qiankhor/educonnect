import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String? documentId; // Unique identifier for the booking
  final String bookingId;
  final String tutorName; // Name of the tutor
  final String subject; // Subject being tutored
  final String level; // Education level of the student
  final String date; // Date of the booking
  final String time; // Time of the booking
  final double price; // Price of the booking
  final bool isPending; // Status of the booking
  final bool isAccepted;
  final bool isCompleted;
  final bool isCanceled;

  Booking({
    this.documentId,
    required this.bookingId,
    required this.tutorName,
    required this.subject,
    required this.level,
    required this.date,
    required this.time,
    required this.price,
    required this.isPending,
    required this.isAccepted,
    required this.isCompleted,
    required this.isCanceled,
  });

  // Factory constructor to create a Booking object from Firestore data
  factory Booking.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Booking(
      documentId: doc.id,
      bookingId: data['bookingId'] ?? '',
      tutorName: data['tutorName'] ?? '',
      subject: data['subject'] ?? '',
      level: data['level'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      price: (data['price'] is num) // Ensure price is a number
          ? (data['price'] as num).toDouble()
          : double.tryParse(data['price'].toString()) ??
              0.0, // Handle conversion
      isPending: data['isPending'] ?? false,
      isAccepted: data['isAccepted'] ?? false,
      isCompleted: data['isCompleted'] ?? false,
      isCanceled: data['isCanceled'] ?? false,
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'boookingId': bookingId,
      'tutorName': tutorName,
      'subject': subject,
      'level': level,
      'date': date,
      'time': time,
      'price': price,
      'isPending': isPending,
      'isAccepted': isAccepted,
      'isCompleted': isCompleted,
      'isCanceled': isCanceled,
    };
  }
}
