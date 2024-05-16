import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoData extends StatelessWidget {
  final String searchValue;
  const NoData({required this.searchValue, super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
          child: Column(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset(
              "assets/no data add y.webp",
              width: 190,
              height: 190,
            ),
          ),
          Text(
            "نعتذر لا توجد بيانات متاحة لي ${searchValue}",
            style: TextStyle(
              fontFamily: GoogleFonts.notoKufiArabic().fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 40,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              child: Text(
                "اعد المحاولة",
                style: TextStyle(
                    fontFamily: GoogleFonts.notoKufiArabic().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          )
        ],
      )),
    );
  }
}
