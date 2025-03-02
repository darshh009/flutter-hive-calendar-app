import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter_calender/hive_objects/categories.dart';
import 'package:hive_flutter_calender/hive_objects/event.dart';
import 'package:hive_flutter_calender/widgets/calender.dart';
import 'package:hive_flutter_calender/widgets/event.dart';

// late initialize the boxes which are like tables stored and managed in database like in hive we call it boxes
late Box<Categories> categoryBox;
late Box<Event> eventBox;

// name of the boxes
const String categoryName = "categories";
const String eventName = "events";

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter<Categories>(CategoryAdapter());
  Hive.registerAdapter<Event>(EventAdapter());

  // initialize the boxes
  categoryBox = await Hive.openBox<Categories>(categoryName);
  eventBox = await Hive.openBox<Event>(eventName);

  runApp(const MyApp());
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


      },
    );
  }
}
