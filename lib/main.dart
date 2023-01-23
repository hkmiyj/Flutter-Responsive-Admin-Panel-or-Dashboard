import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/models/shelter.dart';
import 'package:admin/models/victim.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyD_qIKV1tgjT8NOoGjcdvzWC-m9nTSeqqk",
          projectId: "spotme-0001",
          storageBucket: "spotme-0001.appspot.com",
          messagingSenderId: "232282360593",
          appId: "1:232282360593:web:41bd4cad025f6bfb5f1ab0",
          measurementId: "G-HDRX0FZZ4B"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _victim = FirebaseFirestore.instance
        .collection("victims")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Victim.fromMap(doc.data());
      }).toList();
    });

    final _shelterCollection =
        FirebaseFirestore.instance.collection('shelters');
    final _shelter = _shelterCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Shelter.fromDocument(doc);
      }).toList();
    });
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
          StreamProvider<List<Victim>>(
            create: (context) => _victim,
            initialData: [],
          ),
          StreamProvider<List<Shelter>>(
            create: (context) => _shelter,
            initialData: [],
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SpotMe Dashboard',
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: bgColor,
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                      .apply(bodyColor: Colors.white),
              canvasColor: secondaryColor,
            ),
            home: MainScreen()));
  }
}
