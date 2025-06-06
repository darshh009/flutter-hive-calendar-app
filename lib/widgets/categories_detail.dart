import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter_calender/func.dart';
import 'package:intl/intl.dart';

import '../hive_objects/event.dart';
import '../main.dart';
import 'event.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({super.key});

  static const routeName='category';

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> with Func{
  @override
  Widget build(BuildContext context) {
    final args=ModalRoute.of(context)!.settings.arguments as CategoryArguments;
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
        title: Text("Category: ${args.category}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),


        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Event>>(
          valueListenable: eventBox.listenable(),
          builder: (context, box, widget){
            // this list will hold all the events in event box
            List<Event> events=getByCategory(args.category);
              return Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:events.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, EventDetails.routeName,arguments: EventArguments(daySelected: events[index].date, view:true,event: events[index]));

                          },
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
                                            DateFormat.E().format(events[index].date),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          DateFormat.d().format(
                                            events[index].date,
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
                                          Text(events[index].eventName),
                                          ActionChip.elevated(
                                            elevation: 4,
                                            shadowColor: Colors.grey.shade500,
                                            label: Text(
                                              events[index].category[0].name,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(context, CategoryDetails.routeName,
                                                  arguments: CategoryArguments(category: events[index].category[0].name)

                                              );

                                            },
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
                        ),
                      );
                    }),
              );
          },
      )
    );
  }
}

class CategoryArguments{
  final String category;
  CategoryArguments({required this.category});


}
