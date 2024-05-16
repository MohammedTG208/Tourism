// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bottom_Nav_Bar extends StatefulWidget {
  const Bottom_Nav_Bar({super.key});

  @override
  State<Bottom_Nav_Bar> createState() => _Bottom_Nav_BarState();
}

class _Bottom_Nav_BarState extends State<Bottom_Nav_Bar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/weather');
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 2:
        Navigator.pushNamed(context, '/login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500), // Adjust animation duration
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            blurRadius: 10, // Blur radius
            spreadRadius: 2, // Spread radius
            offset: const Offset(0, -3), // Offset
          ),
        ],
      ),
      child: Material(
        elevation: 15,
        child: BottomNavigationBar(
          unselectedLabelStyle: TextStyle(
            fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
          ),
          selectedLabelStyle: TextStyle(
            fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sunny_snowing),
              label: "الطقس",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "الصفحة الرئسية"),
            BottomNavigationBarItem(icon: Icon(Icons.login), label: "تسجيل"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
