import 'package:educonnect/tutor.dart';
import 'package:flutter/material.dart';
import 'primary_level/primary_tutor_card.dart';
import 'secondary_level/secondary_tutor_card.dart';

class SearchPage extends StatefulWidget {
  final List<Tutor> allTutors;
  final Function(List<Tutor>) onSearchResults;

  const SearchPage({
    super.key,
    required this.allTutors,
    required this.onSearchResults,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Tutor> _searchResultsTutor = [];

  void _onSearchTextChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResultsTutor = [];
      } else {
        final int? rateQuery = int.tryParse(query);
        _searchResultsTutor = widget.allTutors
            .where((tutor) =>
                tutor.name.toLowerCase().contains(query.toLowerCase()) ||
                tutor.subject.toLowerCase().contains(query.toLowerCase()) ||
                tutor.location.toLowerCase().contains(query.toLowerCase()) ||
                (rateQuery != null &&
                    tutor.rate.toString().contains(rateQuery.toString())))
            .toList();
      }
    });

    widget.onSearchResults(_searchResultsTutor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the default back button
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
            ),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: _onSearchTextChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search tutors, subjects, rates, and more...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color:
            const Color(0xFFDDDFFF), // Background color similar to your image
        child: _searchResultsTutor.isEmpty
            ? const Center(child: Text('No search results'))
            : ListView.separated(
                itemCount: _searchResultsTutor.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final tutor = _searchResultsTutor[index];
                  if (tutor.level == 'Primary') {
                    return PrimaryTutorCard(tutor: tutor);
                  } else {
                    return SecondaryTutorCard(tutor: tutor);
                  }
                },
              ),
      ),
    );
  }
}
