import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_albaha/components/card_category_home_page.dart';

class Lower_HomePage extends StatelessWidget {
  const Lower_HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      "assets/hotale.jfif",
      "assets/mountain.jfif",
      "assets/museum.jfif",
      "assets/event.jfif",
      "assets/coffeAndRestorant.jfif",
      "assets/TouristAreas.jfif",
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "الدليل السياحي",
                  style: TextStyle(
                      fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
                const TextSpan(
                  text: '\n',
                ),
                const TextSpan(
                  text: '\t\t\t\t\t\t\t\t',
                ),
                TextSpan(
                    text: "    لـ منطقة الباحة",
                    style: TextStyle(
                        fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 228, 205, 4)))
              ]),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: CardWidget_In_Home(
                        imagePaths[0].toString(),
                        "الفنادق",
                      ),
                    ),
                    Flexible(
                      child: CardWidget_In_Home(
                        imagePaths[1].toString(),
                        "المواقع الأثرية",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: CardWidget_In_Home(
                        imagePaths[2].toString(),
                        "المتاحف",
                      ),
                    ),
                    Flexible(
                      child: CardWidget_In_Home(
                        imagePaths[3].toString(),
                        "الفعاليات",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // spacing between rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: CardWidget_In_Home(
                        imagePaths[4].toString(),
                        "المقاهي والمطاعم",
                      ),
                    ),
                    Flexible(
                      child: CardWidget_In_Home(
                        imagePaths[5].toString(),
                        "المناطق السياحية",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// display category

