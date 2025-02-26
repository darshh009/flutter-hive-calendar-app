import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter_calender/hive_objects/event.dart';
import 'package:hive_flutter_calender/main.dart';

class Eventlist extends StatelessWidget {
  final DateTime date;
  const Eventlist({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Event>>(
        valueListenable: eventBox.listenable(),
        builder: (context, box, widget){
          // this list will hold all the events in event box
          List<Event> events=box.values.toList();
          if (events.isEmpty){
            return Padding(
              padding: const EdgeInsets.only(top: 20,left: 5),
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.7,
                child: EmptyWidget(
                  image:"assets/images/no_events.png",
                  title: 'Calender App',
                  subTitle: "No events",
                  titleTextStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent
                  ),
                  subtitleTextStyle:  const TextStyle(
                    fontSize: 18,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
            );
          }
          else{
            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 7,
                        shadowColor: Colors.purple.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(60, 248, 205, 218),
                                  // #F8CDDA (Soft Pink)
                                  Color.fromARGB(70, 29, 43, 100),
                                  // #1D2B64 (Dark Blue)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )),
                          padding: EdgeInsets.all(20),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        DateFormat.E().format(DateTime.now()),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      DateFormat.d().format(
                                        DateTime.now(),
                                      ),
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.deepPurpleAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: const VerticalDivider(
                                    color: Colors.deepPurpleAccent,
                                    thickness: 1,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      const Text("Event Name"),
                                      ActionChip.elevated(
                                        elevation: 4,
                                        shadowColor: Colors.grey.shade500,
                                        label: const Text(
                                          "Home",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () {},
                                        color: WidgetStateProperty.all<Color>(
                                            Colors.deepPurpleAccent.shade200),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 28,
                                  color: Colors.deepPurpleAccent,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
        });
  }
}
