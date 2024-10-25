import 'package:educonnect/tutor.dart';
import 'package:flutter/material.dart';
import 'secondary_tutor_card.dart';
import 'secondary_filter_bar.dart';

class SecondaryScreen extends StatefulWidget {
  const SecondaryScreen({super.key});

  @override
  SecondaryScreenState createState() => SecondaryScreenState();
}

class SecondaryScreenState extends State<SecondaryScreen> {
  String selectedFilter = 'All';
  List<Tutor> displayedTutors = [];

  @override
  void initState() {
    super.initState();
    displayedTutors =
        allTutors.where((tutor) => tutor.level == 'Secondary').toList();
  }

  void onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'All') {
        displayedTutors =
            allTutors.where((tutor) => tutor.level == 'Secondary').toList();
      } else {
        displayedTutors = allTutors
            .where((tutor) =>
                tutor.subject == filter && tutor.level == 'Secondary')
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
          SecondaryFilterBar(
            selectedFilter: selectedFilter,
            onFilterSelected: onFilterSelected,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedTutors.length,
              itemBuilder: (context, index) {
                final tutor = displayedTutors[index];
                return SecondaryTutorCard(tutor: tutor);
              },
            ),
          ),
        ],
      ),
    );
  }
}
