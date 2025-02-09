import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/plant_page');
        break;
    }

    onItemTapped(index); // Update state if needed
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Plantuary',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grass),
          label: 'My crops',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,
      onTap: (index) => _navigate(context, index),
    );
  }
}
