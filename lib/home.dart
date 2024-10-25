import 'package:educonnect/chat_screen.dart';
import 'package:educonnect/primary_level/primary_level.dart';
import 'package:educonnect/profile_screen.dart';
import 'package:educonnect/booking_history/schedule_screen.dart';
import 'package:educonnect/search.dart';
import 'package:educonnect/secondary_level/secondary_level.dart';
import 'package:educonnect/tutor.dart';
import 'package:flutter/material.dart';
import 'appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const PrimaryScreen(),
    const SecondaryScreen(),
    const ScheduleScreen(),
    const ChatScreen(),
    const ProfileScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _handleSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          allTutors: allTutors,
          onSearchResults: (searchResults) {
            // Update the PrimaryScreen's tutor list with search results
            setState(() {
              // Pass search results to PrimaryScreen (if needed)
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
        onSearchPressed: () => _handleSearch(context),
      ),
      body: _children[_currentIndex],
    );
  }
}
