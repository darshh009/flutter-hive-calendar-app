import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter_calender/func.dart';
import 'package:hive_flutter_calender/hive_objects/categories.dart';
import 'package:hive_flutter_calender/main.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  static const routeName = 'event';

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> with Func {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController eventController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Categories? dropDownValue;
  Uint8List? imageBytes;



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EventArguments;

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
                onPressed: () {},
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
                    padding: const EdgeInsets.only(top: 20),
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
                                fontSize: 20,
                                fontFamily: GoogleFonts.rowdies().fontFamily,
                                color: Color.fromARGB(226, 29, 41, 81)),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 25),
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
                    padding: const EdgeInsets.only(top: 25),
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
                    padding: const EdgeInsets.only(top: 25),
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
                      onTap: () async{
                        FilePickerResult? result=await FilePicker.platform.pickFiles();
                        if(result!=null){
                          //pick path of image and import it to file type
                          File file=File(result.files.single.path!);
                           imageBytes=await file.readAsBytes();
                          setState(() {
                          });
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar( behavior: SnackBarBehavior.floating,
                            content: Text(
                              "Image not found or Error to upload",
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),



                          )




                          );
                        }
                      },
                    ),
                  ),
                  (imageBytes!=null)?Image.memory(imageBytes!,width: 100):
                  const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ));
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

  EventArguments({required this.daySelected});
}
