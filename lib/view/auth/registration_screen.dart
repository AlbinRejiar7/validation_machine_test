// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:validation_machine_test/constants/designation.dart';
import 'package:validation_machine_test/view/home/home_page.dart';
import 'package:validation_machine_test/widgets/textfield.dart';

import '../../constants/constants.dart';
import '../../db/database.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Database db = Database();

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController designationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    db.loadfromdatabase();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome to registration Page",
                      style: TextStyle(color: Colors.green, fontSize: 30)),
                  Text("Enter Your details",
                      style: TextStyle(color: Colors.green, fontSize: 30)),
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
                            : value.length == 10
                                ? null
                                : "Enter a valid phone number";
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
                            : DesignationConstants.designations.contains(value)
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
                          db.personList.add([
                            nameController.text,
                            emailController.text,
                            numberController.text,
                            designationController.text,
                          ]);
                          db.updatedatabase();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Successfully registerd")));
                          nameController.clear();
                          emailController.clear();
                          numberController.clear();
                          designationController.clear();
                        
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter all fields")));
                        }
                      },
                      child: Text("Click Here to register!")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => MyHomepage()));
                      },
                      child: Text("Click Here already registered")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
