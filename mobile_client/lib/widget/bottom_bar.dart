import 'package:flutter/material.dart';
import 'package:mobile_client/pages/home.dart';
import 'package:mobile_client/pages/plant_page.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex) return; // Prevent redundant navigation

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = HomePage();
        break;
      case 1:
        nextScreen = const PlantPage();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );

    onItemTapped(index); // Update state if needed
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Plantuaire',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.calendar_today),
        //   label: 'Calendrier',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grass),
          label: 'Mes cultures',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,
      onTap: (index) => _navigate(context, index),
    );
  }
}
