import 'package:flutter/material.dart';
import 'package:mobile_client/widget/bottom_bar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // for each type of crop:
            // open/close
            // When open:
            // Nom du crop emoji
            // Date de debut - Date de fin
            // visualisation cool du taux de faisabilité du crop
            // description
            // recommandation assisté
            // consulter le calendrier de la semaine

            // Semaine
            //
          ],
        ),
      ),
      bottomNavigationBar:
          BottomBar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
