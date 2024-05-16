// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Display_Detail_Card_Selected extends StatefulWidget {
  const Display_Detail_Card_Selected({super.key});
  @override
  State<Display_Detail_Card_Selected> createState() => _Display_deatailState();
}

class _Display_deatailState extends State<Display_Detail_Card_Selected> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.network(
              arguments['pImage'],
              width: double.infinity,
              height: 390,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow),
                          Text(
                            "${arguments["pRate"]}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        arguments['pTitle'],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily:
                                GoogleFonts.notoSansArabic().fontFamily),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(children: [
                                Icon(Icons.location_on),
                                Text("الباحة"),
                              ]),
                              Row(
                                children: [
                                  Text(
                                    arguments["pPrice"] != null &&
                                            arguments["pPrice"] == 0
                                        ? "مجانا"
                                        : "${arguments["pPrice"]} SAR",
                                    style: TextStyle(
                                      color: arguments["pPrice"] != null &&
                                              arguments["pPrice"] == 0
                                          ? Colors.black
                                          : Colors.black,
                                      fontFamily: GoogleFonts.notoSansArabic()
                                          .fontFamily,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'الوصف',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.notoSansArabic().fontFamily),
                  ),
                  const SizedBox(height: 8),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      arguments['pDescription'],
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.notoSansArabic().fontFamily),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () async {
                          final Uri _url = Uri.parse(arguments['pLink']);
                          if (!await launchUrl(_url)) {
                            throw Exception('حدث خطاء $_url');
                          }
                        },
                        child: Text(
                          'عرض الموقع',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily:
                                  GoogleFonts.notoSansArabic().fontFamily),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
