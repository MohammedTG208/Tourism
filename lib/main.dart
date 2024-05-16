import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tourism_albaha/HomePage.dart';
import 'package:tourism_albaha/Screen/Admin/add_place.dart';
import 'package:tourism_albaha/Screen/Admin/adminUDR.dart';
import 'package:tourism_albaha/Screen/Display_Detail_Card_Selected.dart';
import 'package:tourism_albaha/Screen/Display.dart';
import 'package:tourism_albaha/Screen/logIn.dart';
import 'package:tourism_albaha/search_user.dart';
import 'package:tourism_albaha/weather.dart';
import 'package:tourism_albaha/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AlBaha());
}

class AlBaha extends StatelessWidget {
  const AlBaha({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomePageFinal(),
        '/login': (context) => const Log_In(),
        '/weather': (context) => const Weather(),
        '/Display_All': (context) =>
            Display_All(ModalRoute.of(context)!.settings.arguments as String),
        '/search_user': (context) =>
            SearchUser(ModalRoute.of(context)!.settings.arguments as String),
        '/display_det': (context) => const Display_Detail_Card_Selected(),
        '/adminAdd': (context) => const AddPlace(),
        '/AdminEdite': (context) => const AdminEdite(),
      },
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const HomePageFinal(),
    );
  }
}
