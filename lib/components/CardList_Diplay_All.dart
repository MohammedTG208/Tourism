// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:tourism_albaha/components/Card_Display_All.dart';

class CardList_Diplay_All extends StatefulWidget {
  CardList_Diplay_All({required this.cat, super.key});
  final String cat;
  @override
  State<CardList_Diplay_All> createState() => _CardList_Diplay_AllState();
}

class _CardList_Diplay_AllState extends State<CardList_Diplay_All> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Card_Diplay_Cat_Selected(widget.cat),
    );
  }
}
