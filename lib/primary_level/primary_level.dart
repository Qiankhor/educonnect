import 'package:educonnect/tutor.dart';
import 'package:flutter/material.dart';
import 'primary_tutor_card.dart';
import 'primary_filter_bar.dart';

class PrimaryScreen extends StatefulWidget {
  const PrimaryScreen({super.key});

  @override
  PrimaryScreenState createState() => PrimaryScreenState();
}

class PrimaryScreenState extends State<PrimaryScreen> {
  String selectedFilter = 'All';
  List<Tutor> displayedTutors = [];

  @override
  void initState() {
    super.initState();
    displayedTutors =
        allTutors.where((tutor) => tutor.level == 'Primary').toList();
  }

  void onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'All') {
        displayedTutors =
            allTutors.where((tutor) => tutor.level == 'Primary').toList();
      } else {
        displayedTutors = allTutors
            .where(
                (tutor) => tutor.subject == filter && tutor.level == 'Primary')
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          PrimaryFilterBar(
            selectedFilter: selectedFilter,
            onFilterSelected: onFilterSelected,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedTutors.length,
              itemBuilder: (context, index) {
                final tutor = displayedTutors[index];
                return PrimaryTutorCard(tutor: tutor);
              },
            ),
          ),
        ],
      ),
    );
  }
}
