import 'package:educonnect/tutor_details.dart';
import 'package:educonnect/tutor.dart';
import 'package:flutter/material.dart';

class SecondaryTutorCard extends StatelessWidget {
  final Tutor tutor;

  const SecondaryTutorCard({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 248, 225),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(tutor.profileImage),
                ),
                Text(
                  tutor.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (tutor.review)
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < tutor.rating ? Icons.star : Icons.star_border,
                        color: Colors.black,
                      );
                    }),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          tutor.subject,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'RM${tutor.rate.toStringAsFixed(2)}/hour',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.school, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Tooltip(
                          message: tutor.education,
                          child: Text(
                            tutor.education,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.work, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Tooltip(
                          message: '${tutor.experience} years of experience',
                          child: Text(
                            '${tutor.experience} years of experience',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Tooltip(
                          message: tutor.location,
                          child: Text(
                            tutor.location,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TutorDetails(tutor: tutor),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 244, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
