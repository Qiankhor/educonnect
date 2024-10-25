import 'package:educonnect/booking_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class BookingBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  final Function(String level, String date, String timeSlot) onConfirm;
  final String tutorLevel;
  final String tutorName;
  final String tutorSubject;
  final double price;

  const BookingBottomSheet({
    super.key,
    required this.parentContext,
    required this.onConfirm,
    required this.tutorLevel,
    required this.tutorName,
    required this.tutorSubject,
    required this.price,
  });

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  String selectedLevel = '';
  String selectedDate = '';
  String selectedTimeSlot = '';

  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Book a Session',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Choose your level'),
              items: _getDropdownItems(),
              onChanged: (value) {
                setState(() {
                  selectedLevel = value!;
                });
              },
            ),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    dateController.text = selectedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Time Slot',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10.0,
              children: [
                _timeSlotButton(context, '9:00am - 10:00am'),
                _timeSlotButton(context, '10:00am - 11:00am'),
                _timeSlotButton(context, '2:00pm - 3:00pm'),
                _timeSlotButton(context, '3:00pm - 4:00pm'),
                _timeSlotButton(context, '4:00pm - 5:00pm'),
                _timeSlotButton(context, '5:00pm - 6:00pm'),
                _timeSlotButton(context, '8:00pm - 9:00pm'),
                _timeSlotButton(context, '9:00pm - 10:00pm'),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (selectedLevel.isEmpty ||
                      selectedDate.isEmpty ||
                      selectedTimeSlot.isEmpty) {
                    // Show Snackbar above the Bottom Sheet
                    _showOverlaySnackBar(
                      'Please select all fields to confirm your booking.',
                    );
                  } else {
                    String bookingId = generateConfirmationNumber();
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingConfirmationPage(
                          level: selectedLevel,
                          date: selectedDate,
                          timeSlot: selectedTimeSlot,
                          bookingId: bookingId,
                          tutorName: widget.tutorName,
                          tutorSubject: widget.tutorSubject,
                          price: widget.price,
                          isPast: false,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOverlaySnackBar(String message) {
    final overlay = Overlay.of(widget.parentContext);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewInsets.top + 50,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  List<DropdownMenuItem<String>> _getDropdownItems() {
    List<String> levels = widget.tutorLevel == 'Primary'
        ? [
            'Standard 1',
            'Standard 2',
            'Standard 3',
            'Standard 4',
            'Standard 5',
            'Standard 6'
          ]
        : ['Form 1', 'Form 2', 'Form 3', 'Form 4', 'Form 5'];

    return levels
        .map((level) => DropdownMenuItem(
              value: level,
              child: Text(level),
            ))
        .toList();
  }

  Widget _timeSlotButton(BuildContext context, String time) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.4;

    bool isSelected = selectedTimeSlot == time;

    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color.fromARGB(255, 59, 208, 89)
              : const Color.fromARGB(255, 186, 240, 202),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontSize: 16),
        ),
        onPressed: () {
          setState(() {
            selectedTimeSlot = time;
          });
        },
        child: Text(
          time,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String generateConfirmationNumber() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
