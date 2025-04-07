import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';

class ResubmitMainAbstract extends StatefulWidget {
  const ResubmitMainAbstract({super.key});

  @override
  State<ResubmitMainAbstract> createState() => _ResubmitMainAbstractState();
}

class _ResubmitMainAbstractState extends State<ResubmitMainAbstract> {
  List<Map<String, dynamic>> _techList = [];

  String? selectedTech;

  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectCenterController =
      TextEditingController();

  File? selectedFile; // Stores the selected file
  String? fileName; // Stores the file name
  String? fileUrl;

  Future<void> storeAbstract() async {
    try {
      // String? sid = supabase.auth.currentUser?.id;
      String? url = await uploadFile();
      String projectTitle = _projectTitleController.text;
      String projectCenter = _projectCenterController.text;
      String? tech = selectedTech;
      print("Title:$projectTitle Center:$projectCenter Tech:$tech Url:$url");
      await supabase.from('tbl_mainproject').update({
        'mainproject_abstract': url,
        'mainproject_title': projectTitle,
        'mainproject_center': projectCenter,
        'technology_id': tech,
        'mainproject_status': 1,
      }).eq('mainproject_status', 3);
      _projectCenterController.clear;
      _projectTitleController.clear;
      setState(() {
        selectedTech = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Abstract Re-submitted",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.green,
      ));

      Navigator.pop(context);
    } catch (e) {
      print("Error submitting abstract:$e");
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'], // Accept PDF & Word files
      );

      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
          fileName = result.files.single.name; // Store selected file name
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File Selected: $fileName")),
        );
      }
    } catch (e) {
      print("Error selecting file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File selection failed!")),
      );
    }
  }

  Future<String?> uploadFile() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a file first!")),
      );
      return null;
    }

    try {
      String uploadFileName =
          "abstracts/${DateTime.now().millisecondsSinceEpoch}.${fileName!.split('.').last}";

      // Upload file to Supabase storage
      await supabase.storage
          .from('Abstract')
          .upload(uploadFileName, selectedFile!);

      // Get the public URL of the uploaded file
      fileUrl = supabase.storage.from('Abstract').getPublicUrl(uploadFileName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File Uploaded Successfully!")),
      );

      print("Uploaded File URL: $fileUrl");

      return fileUrl;
    } catch (e) {
      print("Error uploading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed!")),
      );
      return null;
    }
  }

  Future<void> fetchTechnology() async {
    try {
      final reponse = await supabase.from('tbl_technology').select();
      print("Response:$reponse");
      setState(() {
        _techList = reponse;
      });
    } catch (e) {
      print("Error fetching technology data:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTechnology();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 500,
            height: 600,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Abstract Form",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 16, top: 20),
                    child: TextFormField(
                      controller: _projectTitleController,
                      decoration: InputDecoration(
                          hintText: 'Enter project title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.computer)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      value: selectedTech,
                      hint: const Text("Select technology"),
                      onChanged: (newValue) {
                        setState(() {
                          selectedTech = newValue;
                        });
                      },
                      items: _techList.map((tech) {
                        return DropdownMenuItem<String>(
                          value: tech['technology_id'].toString(),
                          child: Text(tech['technology_name']),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextFormField(
                      controller: _projectCenterController,
                      decoration: InputDecoration(
                          hintText: 'Enter project center',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.hub)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: pickFile, // Pick File Function
                    icon:
                        Icon(Icons.attach_file, color: Colors.white, size: 24),
                    label: Text(
                      "Select File",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004A61),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                    ),
                  ),
                  if (fileName != null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Selected File: $fileName",
                        style: TextStyle(color: Colors.green, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF017AFF),
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        storeAbstract();
                      }, // Uploads the file when clicked
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
