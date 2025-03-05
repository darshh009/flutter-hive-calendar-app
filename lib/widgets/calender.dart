import 'package:flutter/material.dart';
import 'package:hive_flutter_calender/widgets/event.dart';
import 'package:hive_flutter_calender/widgets/eventlist.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  static const routeName="/calender";
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  bool search=false;
  bool viewAll=false;
  bool filter=false;
  TextEditingController searchController=TextEditingController();
  DateTime daySelected = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(150, 145, 234, 228), // Light Cyan
              Color.fromARGB(150, 134, 168, 231), // Soft Blue
              Color.fromARGB(100, 127, 127, 213), // Deep Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
        title: (search)? Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextField(
            onChanged: (value){
              setState(() {
                viewAll=false;
                filter=true;


              });



            },
            controller: searchController,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black

            ),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: "Search Here",
              hintStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600


              ),
              )
          ),
        ):Text(
          "Calender App",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          (search)?IconButton(
            onPressed: () {
              setState(() {
                search=false;
              });


            },
            icon: Padding(
              padding: const EdgeInsets.only(top: 4, right: 10),
              child: Icon(
                Icons.cancel,
                color: Colors.black54,
                size: 25,
              ),
            ),
          ):
          IconButton(
            onPressed: () {
              setState(() {
                search=true;
                viewAll=true;
              });


            },
            icon: Padding(
              padding: const EdgeInsets.only(top: 4, right: 10),
              child: Icon(
                Icons.search_rounded,
                color: Colors.black54,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: !search,
              child: Column(
                children: [
                  TableCalendar(
                    focusedDay: daySelected,
                    firstDay: DateTime.utc(2025, 1, 1),
                    lastDay: DateTime.utc(2035, 1, 1),
                    currentDay: daySelected,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        daySelected = selectedDay;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 5),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.purple.shade100,
                          backgroundColor: Color.fromARGB(150, 127, 127, 213)
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, EventDetails.routeName,arguments: EventArguments(daySelected:DateTime.utc(
                              daySelected.year
                              ,daySelected.month,
                              daySelected.day
                          ), view: false,
                            event: null
                          ));


                        },
                        label: Text(
                          "Add Event",
                          style: TextStyle(
                              fontSize: 15, color: Colors.white,
                          fontWeight: FontWeight.bold),
                        ),
                        icon: Icon(Icons.add,
                            size: 22, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Eventlist(
              all: viewAll,
                filter: filter,
                searchTerm: searchController.text,
                date: DateTime.utc(daySelected.year,daySelected.month,daySelected.day))


          ],
        ),
      ),
    );
  }
}
