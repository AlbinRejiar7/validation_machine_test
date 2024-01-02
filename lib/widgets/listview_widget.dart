// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:validation_machine_test/db/database.dart';

class DetailsWidget extends StatelessWidget {
  int index;
  String name;
  String email;
  String number;
  String designation;
  void Function() onPressedOnDelete;
  void Function() onPressedOnEdit;
  void Function() printPDf;
  DetailsWidget(
      {super.key,
      required this.printPDf,
      required this.onPressedOnDelete,
      required this.onPressedOnEdit,
      required this.index,
      required this.name,
      required this.email,
      required this.number,
      required this.designation});

  @override
  Widget build(BuildContext context) {
    Database db = Database();
    db.loadfromdatabase();

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.pink[200]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("interviewee ${index + 1}"),
              Text(
                "Name: $name",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Email: $email",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Number: $number",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Designation: $designation",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(onPressed: onPressedOnEdit, icon: Icon(Icons.edit)),
              IconButton(onPressed: onPressedOnDelete, icon: Icon(Icons.delete)),
               IconButton(onPressed: printPDf, icon: Icon(Icons.print)),
            ],
          ),
        ],
      ),
    );
  }
}
