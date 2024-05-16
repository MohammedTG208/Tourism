// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:tourism_albaha/components/Bottom_Nav_Bar.dart';
import 'package:tourism_albaha/components/CardList_Diplay_All.dart';
import 'package:tourism_albaha/components/appbar.dart';

class Display_All extends StatefulWidget {
  final String cat;
  const Display_All(this.cat, {super.key});

  @override
  State<Display_All> createState() => _Display_AllState();
}

class _Display_AllState extends State<Display_All> {
  late String cat;

  @override
  void initState() {
    super.initState();
    cat = widget.cat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(cat),
      body: CardList_Diplay_All(
        cat: widget.cat,
      ),
      bottomNavigationBar: const Bottom_Nav_Bar(),
    );
  }
}
