import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:validation_machine_test/db/database.dart';
import 'package:validation_machine_test/view/Edit_screen/editing_screen.dart';
import 'package:validation_machine_test/widgets/listview_widget.dart';
import 'package:open_file/open_file.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  Database db = Database();
  Future<void> requestStoragePermissions() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  Future getMobileDirectory() async {
    if (Platform.isAndroid) {
      // Use path_provider for Android's external storage
      final directory = await getExternalStorageDirectory();
      return directory?.path != null ? directory : null;
    } else if (Platform.isIOS) {
      // Use file_chooser for iOS's Documents directory
      final directory = await FilePicker.platform.getDirectoryPath();
      return directory;
    }
    return null;
  }

  Future<void> savePdfToMobile(
    String name,
    String email,
    String number,
    String designation,
  ) async {
    await requestStoragePermissions();
    final ttf = await rootBundle.load('assets/fonts/unicodehelvetic.ttf');
    final helveticaUnicode = pw.Font.ttf(ttf);
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(name, style: pw.TextStyle(font: helveticaUnicode)),
            pw.Text(email, style: pw.TextStyle(font: helveticaUnicode)),
            pw.Text(number, style: pw.TextStyle(font: helveticaUnicode)),
            pw.Text(designation, style: pw.TextStyle(font: helveticaUnicode)),
          ],
        );
      },
    ));

    final mobileDir = await getMobileDirectory();
    if (mobileDir == null) {
      print('Error: Could not access mobile storage');
      return;
    }

    final file = File('${mobileDir.path}/my_pdf.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);

    print('PDF saved to: ${file.path}');
  }

  @override
  Widget build(BuildContext context) {
    db.loadfromdatabase();
    db.personList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("interviewee Details"),
      ),
      body: ListView.builder(
        itemCount: db.personList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: DetailsWidget(
                  printPDf: () async {
                    await savePdfToMobile(
                      await db.personList[index][0],
                      await db.personList[index][1],
                      await db.personList[index][2],
                      await db.personList[index][3],
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Successfully saved to your storage")));
                  },
                  onPressedOnDelete: () async {
                    await db.personList.removeAt(index);
                    db.updatedatabase();
                    setState(() {});
                  },
                  onPressedOnEdit: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => EditingScreen(
                              index: index,
                            )));
                  },
                  index: index,
                  name: db.personList[index][0],
                  email: db.personList[index][1],
                  number: db.personList[index][2],
                  designation: db.personList[index][3]));
        },
      ),
    );
  }
}
