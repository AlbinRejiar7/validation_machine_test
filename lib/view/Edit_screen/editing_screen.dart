// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:validation_machine_test/constants/constants.dart';
import 'package:validation_machine_test/constants/designation.dart';
import 'package:validation_machine_test/db/database.dart';
import 'package:validation_machine_test/view/home/home_page.dart';
import 'package:validation_machine_test/widgets/textfield.dart';

class EditingScreen extends StatelessWidget {
  final int index;
  EditingScreen({super.key, required this.index});

  Database db = Database();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    db.loadfromdatabase();
    TextEditingController nameController =
        TextEditingController(text: db.personList[index][0]);

    TextEditingController emailController =
        TextEditingController(text: db.personList[index][1]);

    TextEditingController numberController =
        TextEditingController(text: db.personList[index][2]);

    TextEditingController designationController =
        TextEditingController(text: db.personList[index][3]);
    return Scaffold(
        appBar: AppBar(
          title: Text("EDITING SCREEN"),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //username
                    AppTextFormField(
                        onChanged: (value) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please, Enter Full Name '
                              : value.length < 4
                                  ? 'Invalid Name'
                                  : null;
                        },
                        textInputAction: TextInputAction.next,
                        labelText: "Name",
                        keyboardType: TextInputType.name,
                        controller: nameController),
                    //email
                    AppTextFormField(
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _formKey.currentState?.validate(),
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Please, Enter Email Address'
                            : AppConstants.emailRegex.hasMatch(value)
                                ? null
                                : 'Invalid Email Address';
                      },
                      controller: emailController,
                    ),
                    AppTextFormField(
                        onChanged: (value) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please, Enter Your Number '
                              : value.length < 4
                                  ? 'Invalid Name'
                                  : null;
                        },
                        textInputAction: TextInputAction.done,
                        labelText: "Number",
                        keyboardType: TextInputType.number,
                        controller: numberController),
                    AppTextFormField(
                        onChanged: (value) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please, Enter Your Designation'
                              : DesignationConstants.designations
                                      .contains(value)
                                  ? null
                                  : "Invalid designation";
                        },
                        textInputAction: TextInputAction.next,
                        labelText: "designation",
                        keyboardType: TextInputType.name,
                        controller: designationController),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            db.personList.removeAt(index);
                            db.personList.insert(index, [
                              nameController.text,
                              emailController.text,
                              numberController.text,
                              designationController.text,
                            ]);
                            db.updatedatabase();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Successfully Edited!")));
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => MyHomepage() ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Enter all fields")));
                          }

                        },
                        child: Text("SAVE EDITED DATA!")),
                  ],
                ),
              ),
            )));
  }
}
