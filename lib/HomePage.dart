// ignore_for_file: file_names

import 'package:tourism_albaha/Screen/HomePageCard.dart';
import 'package:flutter/material.dart';
import 'package:tourism_albaha/components/Bottom_Nav_Bar.dart';

class HomePageFinal extends StatelessWidget {
  const HomePageFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Bottom_Nav_Bar(),
      body: Container(
        color: Colors.white.withOpacity(0.10),
        child: Upper_HomePage(),
      ),
    );
  }
}
