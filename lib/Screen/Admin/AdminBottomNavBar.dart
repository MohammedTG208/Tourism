// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_albaha/Screen/Admin/add_place.dart';
import 'package:tourism_albaha/Screen/Admin/adminUDR.dart';

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminEdite()),
              );
            },
            icon: const Icon(
              Icons.table_chart_outlined,
              color: Colors.blue,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddPlace()));
            },
            icon: const Icon(
              Icons.add_chart_rounded,
              size: 30,
              color: Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
