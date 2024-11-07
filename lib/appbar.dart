import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final VoidCallback onSearchPressed;

  const CustomAppBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.onSearchPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 60, // Adjust the height as necessary
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () => onTabTapped(0),
            child: Text(
              'Primary level',
              style: TextStyle(
                fontSize: 12,
                color:
                    currentIndex == 0 ? const Color(0xFF1F42FF) : Colors.black,
                decoration: currentIndex == 0
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () => onTabTapped(1),
            child: Text(
              'Secondary level',
              style: TextStyle(
                fontSize: 12,
                color:
                    currentIndex == 1 ? const Color(0xFF1F42FF) : Colors.black,
                decoration: currentIndex == 1
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            onSearchPressed();
          },
        ),
      ],
    );
  }
}
