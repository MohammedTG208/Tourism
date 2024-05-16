// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardWidget_In_Home extends StatefulWidget {
  final String cat; //as category
  final String imagePaths;

  const CardWidget_In_Home(this.imagePaths, this.cat, {super.key});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget_In_Home> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/Display_All',
          arguments: widget.cat,
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                widget.imagePaths,
                fit: BoxFit.cover,
                height: 160,
                width: 180,
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.cat,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
