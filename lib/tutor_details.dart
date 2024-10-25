import 'package:educonnect/booking_bottom_sheet.dart';
import 'package:educonnect/review_card.dart';
import 'package:educonnect/tutor_personal_info.dart';
import 'package:flutter/material.dart';
import 'package:educonnect/tutor.dart';

class TutorDetails extends StatelessWidget {
  final Tutor tutor;

  const TutorDetails({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor Details'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFDDDFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(tutor.profileImage),
            ),
            const SizedBox(height: 10),
            Text(
              tutor.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (tutor.review)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) {
                    return Icon(
                      index < tutor.rating ? Icons.star : Icons.star_border,
                      color: Colors.black,
                      size: 24,
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '${tutor.level} level',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    tutor.subject,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  PersonalInfo(tutor: tutor),
                  const SizedBox(height: 20),
                  if (tutor.aboutme != '')
                    const Text(
                      'About me',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (tutor.aboutme != '')
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: 500,
                      padding: const EdgeInsets.all(15),
                      child: Text(tutor.aboutme),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (tutor.review)
                        const Text(
                          'Reviews (1)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (tutor.review)
                        Row(
                          children: List.generate(
                            5,
                            (index) {
                              return Icon(
                                index < tutor.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.black,
                                size: 24,
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (tutor.review)
                    ReviewCard(
                      tutor: tutor,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.chat)),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showBookingSheet(context, tutor.level, tutor.name,
                      tutor.subject, tutor.rate);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Book a schedule (RM${tutor.rate}/hour)',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingSheet(BuildContext context, String tutorLevel,
      String tutorName, String tutorSubject, double price) {
    showModalBottomSheet(
      context: context, // Parent Scaffold context
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext parentContext) {
        return BookingBottomSheet(
          parentContext: parentContext, // Pass the parent context here
          tutorLevel: tutorLevel,
          tutorName: tutorName,
          tutorSubject: tutorSubject,
          price: price,
          onConfirm: (level, date, timeSlot) {},
        );
      },
    );
  }
}
