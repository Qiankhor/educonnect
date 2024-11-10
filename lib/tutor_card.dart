import 'package:educonnect/current_user.dart';
import 'package:educonnect/tutor_details.dart';
import 'package:educonnect/tutor.dart';
import 'package:flutter/material.dart';

class TutorCard extends StatelessWidget {
  final Tutor tutor;
  final CurrentUser currentUser;
  final bool
      isPrimary; // A flag to customize the card for primary or secondary tutors

  const TutorCard({
    super.key,
    required this.tutor,
    required this.currentUser,
    this.isPrimary = true, // Default to primary, can set to false for secondary
  });

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
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: tutor.profileImageUrl != null &&
                              tutor.profileImageUrl!.isNotEmpty
                          ? NetworkImage(tutor.profileImageUrl!)
                              as ImageProvider
                          : const AssetImage('assets/blank_profile.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  tutor.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (tutor.reviews != null && tutor.reviews!.isNotEmpty)
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < (tutor.rating ?? 0)
                            ? Icons.star
                            : Icons.star_border,
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
                      _buildInfoTag(tutor.subject),
                      const SizedBox(width: 5),
                      _buildInfoTag(tutor.level),
                      const Spacer(),
                      Text(
                        'RM${tutor.ratePerHour.toStringAsFixed(0)}/hour',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  _buildInfoRow(Icons.school, tutor.education),
                  const SizedBox(height: 5),
                  _buildInfoRow(
                    Icons.work,
                    '${tutor.experience} years of experience',
                  ),
                  const SizedBox(height: 5),
                  _buildInfoRow(Icons.location_on, tutor.location),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TutorDetails(
                              tutor: tutor,
                              currentUser: currentUser,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPrimary
                            ? const Color.fromARGB(255, 232, 223, 245)
                            : const Color.fromARGB(255, 200, 200, 250),
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

  // Helper widget to build information tags like subject and level
  Widget _buildInfoTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper widget to build icon + text rows like education and location
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 5),
        Expanded(
          child: Tooltip(
            message: text,
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
