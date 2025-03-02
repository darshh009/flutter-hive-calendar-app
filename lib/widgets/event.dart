import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter_calender/func.dart';
import 'package:hive_flutter_calender/hive_objects/categories.dart';
import 'package:hive_flutter_calender/hive_objects/event.dart';
import 'package:hive_flutter_calender/main.dart';
import 'package:hive_flutter_calender/widgets/calender.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  static const routeName = 'event';

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> with Func {
  DateTime daySelected = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);



  bool viewed=false;
  bool _isSnackbarShown = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController eventController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Categories? dropDownValue;
  Uint8List? imageBytes;
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EventArguments;

    if(args.view && !viewed){
      setState(() {
        dropDownValue=args.event!.category[0];
        eventController.text=args.event!.eventName;
        descriptionController.text=args.event!.eventDescription;
        imageBytes=args.event!.file;
        completed=args.event!.completed;
        viewed=true;
      });

    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Event",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 26,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(150, 145, 234, 228), // Light Cyan
              Color.fromARGB(150, 134, 168, 231), // Soft Blue
              Color.fromARGB(100, 127, 127, 213),
            ])),
          ),
          actions: [
            IconButton(
                onPressed: (args.view)? () {
                  updateExistingEvent(args, context);
                }:null,
                icon: Icon(
                  Icons.save,
                  color: Colors.indigo.shade800,
                  size: 26,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: Colors.red.shade900,
                  size: 26,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Category",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.indigo.shade900,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ValueListenableBuilder<Box<Categories>>(
                              valueListenable: categoryBox.listenable(),
                              builder: (context, box, widget) {
                                return DropdownButton(
                                    focusColor: Colors.black,
                                    dropdownColor:
                                        Color.fromARGB(225, 230, 230, 250),
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: Colors.purple.shade900,
                                    ),
                                    value: dropDownValue,
                                    items: box.values
                                        .toList()
                                        .map<DropdownMenuItem<Categories>>(
                                            (Categories value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            value.name,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ));
                                    }).toList(),
                                    onChanged: (Categories? newValue) {
                                      setState(() {
                                        dropDownValue = newValue!;
                                      });
                                    });
                              }),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.purple.shade600),
                            onPressed: () {
                              addNewCategory(context);
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 25,
                            ))
                      ],
                    ),
                  ),

                  // date got runtime
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.purple.shade700,
                          size: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            DateFormat("EEEE, d MMMM").format(args.daySelected),
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: GoogleFonts.rowdies().fontFamily,
                                color: Color.fromARGB(226, 29, 41, 81)),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: TextField(
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff002147)),
                      controller: eventController,
                      decoration: InputDecoration(
                        labelText: "Enter Event Name",
                        labelStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.purple.shade400,
                            fontWeight: FontWeight.w500),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                BorderSide(width: 1, color: Color(0xFF00416a))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF682860))),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.event_available_rounded,
                            color: Colors.indigo.shade700,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: TextField(
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff002147)),
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Enter Event Description",
                        labelStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.purple.shade400,
                            fontWeight: FontWeight.w500),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                BorderSide(width: 1, color: Color(0xFF00416a))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF682860))),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.event_note,
                            color: Colors.indigo.shade700,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      tileColor: Colors.purple.shade700,
                      title: Text(
                        "Upload File",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                      trailing: Icon(
                        Icons.file_upload,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          //pick path of image and import it to file type
                          File file = File(result.files.single.path!);
                          imageBytes = await file.readAsBytes();
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              "Image not found or Error to upload",
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                    ),
                  ),
                  if (imageBytes != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.memory(imageBytes!, width: 100),
                    ),
                    Builder(
                      builder: (context) {
                        if (!_isSnackbarShown) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Image Uploaded Successfully",
                                  style: TextStyle(fontSize: 16),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(width: 1, color: Colors.green),
                                ),
                                duration: Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green.shade600,
                              ),
                            );
                            _isSnackbarShown = true; // Set flag to true after showing snackbar
                          });
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ] else
                    const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: SwitchListTile(
                        tileColor: Color(0x80D3D3D3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          "Event Completed ?",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                        value: completed,
                        onChanged: (bool? value) {
                          setState(() {
                            completed = value!;
                          });
                        }),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 70),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 140, 166, 219), // Light Blue
                            Color.fromARGB(255, 185, 147, 214),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 7,
                              spreadRadius: 1,
                              color: Colors.grey.shade900.withAlpha(127),
                              offset: Offset(0, 3))
                        ]),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            backgroundColor: Colors.transparent,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.9, 50),
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent),
                        onPressed:(args.view)? null :() async {
                          if (_formKey.currentState!.validate() &&
                              dropDownValue != null &&
                              eventController.text.trim().isNotEmpty &&
                              descriptionController.text.trim().isNotEmpty) {
                            await addEvent(
                              Event(
                                HiveList(categoryBox),
                                args.daySelected,
                                eventController.text.trim(),
                                descriptionController.text.trim(),
                                imageBytes,
                                completed,
                              ),
                              dropDownValue!,
                            );

                            if (context.mounted) {
                              // Ensure widget is still mounted
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.topSlide,
                                title: "Success",
                                desc: "Event added successfully!",
                                btnOkOnPress: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      CalenderScreen.routeName,
                                      (route) => false);
                                },
                              ).show();
                            }
                          } else {
                            if (context.mounted) {
                              // Ensure widget is still mounted
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.topSlide,
                                  title: "Error",
                                  desc: "Please fill all event details.",
                                  btnOkOnPress: () {
                                    Navigator.pushNamed(
                                        context, EventDetails.routeName,
                                        arguments: EventArguments(
                                            daySelected: DateTime.utc(
                                                daySelected.year,
                                                daySelected.month,
                                                daySelected.day),
                                            view: false,
                                            event: null));
                                  },
                                  btnOkColor: Colors.red,
                                  titleTextStyle: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  )).show();
                            }
                          }
                        },
                        child: Text(
                          "Add Event",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
  /// function for updating existing event
  updateExistingEvent(EventArguments args,BuildContext context){
    args.event?.category=HiveList(categoryBox);
    args.event?.eventName=eventController.text.trim();
    args.event?.eventDescription=descriptionController.text.trim();
    args.event?.file=imageBytes;
    args.event?.completed=completed;
    updateEvent(args.event!,dropDownValue!);
    if(context.mounted){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        dialogBackgroundColor: Colors.green.shade100,
        title: "Event Updated Successfully",
        btnOkOnPress: (){
          Navigator.pop(context);
        }
      ).show();
    }





  }






  /// function to show alert dialog for adding new category
  addNewCategory(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Add New Category",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blueAccent.shade700),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                    labelText: "Add Category",
                    labelStyle: TextStyle(fontSize: 16, color: Colors.indigo),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Colors.indigo.shade400)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.purple.shade900),
                    )),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.cyan.shade500,
                              foregroundColor: Colors.black,
                              shadowColor: Colors.grey.shade400),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.indigo.shade300,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.grey.shade400),
                      onPressed: () {
                        if (categoryController.text.isNotEmpty) {
                          addCategory(Categories(categoryController.text));
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                "*Category name cannot be empty!",
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ],
          );
        });
  }
}

class EventArguments {
  final DateTime daySelected;
  final Event? event;
  final bool view;

  EventArguments(
      {required this.daySelected, required this.view, required this.event});
}
