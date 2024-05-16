// Update the HomePage widget

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_albaha/search_user.dart';
import 'package:tourism_albaha/components/CardForHomePage.dart';

class Upper_HomePage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(
              height: 70,
              width: double.infinity,
              child: Container(
                margin: const EdgeInsets.fromLTRB(35, 8, 35, 15),
                child: TextField(
                  controller: searchController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    hintText: "بحث",
                    hintStyle: TextStyle(
                        fontFamily: GoogleFonts.notoNaskhArabic().fontFamily),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchUser(value),
                      ),
                    ).then((_) => searchController.clear());
                  },
                ),
              ),
            ),
            const Lower_HomePage(),
          ],
        ),
      ],
    );
  }
}
