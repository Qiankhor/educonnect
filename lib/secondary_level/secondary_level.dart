import 'package:educonnect/current_user.dart';
import 'package:educonnect/secondary_level/secondary_filter_bar.dart';
import 'package:educonnect/secondary_level/secondary_tutor_card.dart';
import 'package:educonnect/tutor.dart';
import 'package:educonnect/tutor_service.dart';
import 'package:flutter/material.dart';

class SecondaryScreen extends StatefulWidget {
  final List<Tutor> tutors;
  final CurrentUser currentUser;

  const SecondaryScreen(
      {super.key, required this.tutors, required this.currentUser});

  @override
  SecondaryScreenState createState() => SecondaryScreenState();
}

class SecondaryScreenState extends State<SecondaryScreen> {
  String selectedFilter = 'All';
  List<Tutor> displayedTutors = [];

  @override
  void initState() {
    super.initState();
    fetchSecondaryTutors();
  }

  // Fetch primary level tutors
  Future<void> fetchSecondaryTutors() async {
    TutorService tutorService = TutorService();
    List<Tutor> tutors = await tutorService.fetchTutors();
    setState(() {
      // Filter tutors by primary level
      displayedTutors =
          tutors.where((tutor) => tutor.level == 'Secondary').toList();
    });
  }

  // Filter tutors based on selected filter
  void onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'All') {
        fetchSecondaryTutors(); // Fetch again to reset the filter
      } else {
        displayedTutors =
            displayedTutors.where((tutor) => tutor.subject == filter).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          SecondaryFilterBar(
            selectedFilter: selectedFilter,
            onFilterSelected: onFilterSelected,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedTutors.length,
              itemBuilder: (context, index) {
                final tutor = displayedTutors[index];
                return SecondaryTutorCard(
                  tutor: tutor,
                  currentUser: widget.currentUser,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
