// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: use_build_context_synchronously, camel_case_types

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_albaha/Screen/Admin/add_place.dart';
import 'package:progress_dialog2/progress_dialog2.dart';

class Login_action extends StatefulWidget {
  const Login_action({super.key});

  @override
  State<Login_action> createState() => _Login_actionState();
}

class _Login_actionState extends State<Login_action> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    _progressDialog = ProgressDialog(context);
  }

  void _showLoading() {
    _progressDialog.show();
  }

  void _hideLoading() {
    _progressDialog.hide();
  }

  Future<void> login(String email, String password) async {
    _showLoading();
    try {
      CollectionReference adminCollection =
          FirebaseFirestore.instance.collection('Admin');

      QuerySnapshot querySnapshot = await adminCollection
          .where('Email', isEqualTo: email.toLowerCase())
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _hideLoading();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPlace()),
        );
      } else {
        _hideLoading();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          desc: 'الرجاء التاكد من كلمه السر والبريد الالكترروني',
        ).show();
      }
    } catch (e) {
      _hideLoading();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        desc: 'الرجاء المحاولة في وقت لاحق',
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 450,
        width: 385,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                        fontFamily: GoogleFonts.notoSansArabic().fontFamily,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 25),
                  buildTextField(_emailController, 'البريد الالكتروني'),
                  const SizedBox(height: 10),
                  buildTextField(_passwordController, 'كلمة السر',
                      obscureText: true),
                  const SizedBox(height: 20),
                  loginButton(),
                  const SizedBox(height: 15),
                  buildDivider(),
                  const SizedBox(height: 20),
                  newAccountButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return SizedBox(
      height: 55,
      child: TextFormField(
        controller: controller,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.end,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
        ),
      ),
    );
  }

  Widget loginButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 50)),
        onPressed: () async {
          login(_emailController.text, _passwordController.text);
        },
        child: Text(
          'تسجيل',
          style: TextStyle(
              fontFamily: GoogleFonts.notoSansArabic().fontFamily,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      );

  Widget buildDivider() => Row(
        children: <Widget>[
          const Expanded(
            child: Divider(
              color: Colors.blue,
              thickness: 3.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "أو",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontFamily: GoogleFonts.notoSansArabic().fontFamily,
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Colors.blue,
              thickness: 3.0,
            ),
          ),
        ],
      );

  Widget newAccountButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text('سوف يتوفر انشاء الحساب قريبا'),
              ),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Text(
          "انشاء حساب جديد",
          style: TextStyle(
            fontFamily: GoogleFonts.notoSansArabic().fontFamily,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}
