// ignore_for_file: file_names, unnecessary_import, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_albaha/components/login_action.dart';

class Log_In extends StatefulWidget {
  const Log_In({super.key});

  @override
  State<Log_In> createState() => _Log_InState();
}

class _Log_InState extends State<Log_In> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
          ),
          title: Center(
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
              textDirection:
                  TextDirection.rtl, // Set text direction to right-to-left
            ),
          ),
        ),
        body: const Login_action());
  }
}
