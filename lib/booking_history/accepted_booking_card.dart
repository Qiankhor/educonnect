import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedBookingCard extends StatefulWidget {
  final String bookingId;

  AcceptedBookingCard({required this.bookingId});

  @override
  _AcceptedBookingCardState createState() => _AcceptedBookingCardState();
}

class _AcceptedBookingCardState extends State<AcceptedBookingCard> {
  Color _buttonColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _checkMeetingLink();
  }

  Future<void> _checkMeetingLink() async {
    String? meetingLink = await _getMeetingLink(widget.bookingId);
    if (meetingLink != null) {
      setState(() {
        _buttonColor = Colors.green;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: () => _handleMeetingLink(widget.bookingId),
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonColor,
          ),
          child: const Text(
            "Join the meeting",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _handleMeetingLink(String bookingId) async {
    String? meetingLink = await _getMeetingLink(bookingId);
    if (meetingLink != null) {
      _launchURL(meetingLink);
    } else {
      Fluttertoast.showToast(
        msg: "Meeting link is unavailable or outside the scheduled time.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<String?> _getMeetingLink(String bookingId) async {
    try {
      QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('bookingId', isEqualTo: bookingId)
          .get();

      if (bookingSnapshot.docs.isNotEmpty) {
        DocumentSnapshot bookingDoc = bookingSnapshot.docs.first;

        String? meetingLink = bookingDoc['meetingLink'];
        String dateStr = bookingDoc['date'];
        String timeStr = bookingDoc['time'];
        DateTime bookingDate = DateTime.parse(dateStr);

        List<String> timeParts = timeStr.split(' - ');
        if (timeParts.length == 2) {
          DateTime bookingStartTime =
              _parseBookingTime(dateStr, timeParts[0].trim());
          DateTime bookingEndTime =
              _parseBookingTime(dateStr, timeParts[1].trim());
          print(bookingEndTime);
          DateTime currentTimeInMYT = _getCurrentTimeInMYT();
          if (currentTimeInMYT.day > bookingDate.day) {
            await _updateBookingStatus(bookingDoc.id);
          }
          // If the current date is the same as the booking date, check the time
          else if (currentTimeInMYT.year == bookingDate.year &&
              currentTimeInMYT.month == bookingDate.month &&
              currentTimeInMYT.day == bookingDate.day) {
            // Update status if current time is past the booking end time
            if (currentTimeInMYT.isAfter(bookingEndTime)) {
              await _updateBookingStatus(bookingDoc.id);
            }
          }

          if (currentTimeInMYT.isAfter(bookingStartTime) &&
              currentTimeInMYT.isBefore(bookingEndTime)) {
            return meetingLink;
          }
        }
      }
    } catch (e) {
      print('Error retrieving meeting link: $e');
    }
    return null;
  }

  DateTime _getCurrentTimeInMYT() {
    DateTime utcTime = DateTime.now().toUtc();
    Duration mytOffset = Duration(hours: 8);
    return utcTime.add(mytOffset);
  }

  DateTime _parseBookingTime(String dateStr, String timeStr) {
    try {
      String combinedDateTimeStr = "$dateStr $timeStr".trim();
      DateFormat dateFormat = DateFormat("yyyy-MM-dd h:mma");
      return dateFormat.parse(combinedDateTimeStr);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }

  Future<void> _updateBookingStatus(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(documentId)
          .update({
        'isAccepted': false,
        'isCompleted': true,
      });
    } catch (e) {
      print('Error updating booking status: $e');
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
