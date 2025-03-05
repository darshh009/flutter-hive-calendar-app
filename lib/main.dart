import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter_calender/hive_objects/categories.dart';
import 'package:hive_flutter_calender/hive_objects/event.dart';
import 'package:hive_flutter_calender/widgets/calender.dart';
import 'package:hive_flutter_calender/widgets/categories_detail.dart';
import 'package:hive_flutter_calender/widgets/event.dart';

// late initialize the boxes which are like tables stored and managed in database like in hive we call it boxes
late Box<Categories> categoryBox;
late Box<Event> eventBox;

// name of the boxes
const String categoryName = "categories";
const String eventName = "events";
const customKey="calender";

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter binding is initialized

  const secureStorage = FlutterSecureStorage();
  final encryptionKeyString = await secureStorage.read(key: customKey);

  if (encryptionKeyString == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(key: customKey, value: base64UrlEncode(key));
  }

  final key = await secureStorage.read(key: customKey);
  final encryptionKeyUIntList = base64Url.decode(key!);

  await Hive.initFlutter();
  Hive.registerAdapter<Categories>(CategoryAdapter());
  Hive.registerAdapter<Event>(EventAdapter());

  // Open the boxes with encryption
  categoryBox = await Hive.openBox<Categories>(
    categoryName,
    encryptionCipher: HiveAesCipher(encryptionKeyUIntList),
  );
  eventBox = await Hive.openBox<Event>(
    eventName,
    encryptionCipher: HiveAesCipher(encryptionKeyUIntList),
  );

  categoryBox.compact();
  eventBox.compact();

  runApp(const MyApp()); // ✅ Run app after everything is initialized
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calender App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontFamily: GoogleFonts.poppins().fontFamily),
      ),
      initialRoute: "/",
      routes: {"/": (context) => const CalenderScreen(),
        EventDetails.routeName: (context) => const EventDetails(),
        CalenderScreen.routeName: (context) => const CalenderScreen(),
        CategoryDetails.routeName:(context) => const CategoryDetails()

      },
    );
  }
}
