import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';

class AbstractForm extends StatefulWidget {
  const AbstractForm({super.key});

  @override
  State<AbstractForm> createState() => _AbstractFormState();
}

class _AbstractFormState extends State<AbstractForm> {
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectCenterController =
      TextEditingController();
  final supabase = Supabase.instance.client;

  File? selectedFile; // Stores the selected file
  String? fileName; // Stores the file name
  String? fileUrl; // Stores the uploaded file URL;

  Future<void> storeAbstract() async {
    try {
      String? sid = supabase.auth.currentUser?.id;

      final group = await supabase
          .from('tbl_groupmember')
          .select()
          .eq('student_id', sid!)
          .maybeSingle()
          .limit(1);
      String? url = await uploadFile();
      String projectTitle = _projectTitleController.text;
      String projectCenter = _projectCenterController.text;
      await supabase.from('tbl_group').update({
        'group_abstract': url,
        'project_title': projectTitle,
        'group_center': projectCenter,
        'group_status': 1,
      }).eq('group_id', group!['group_id']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Abstract Submitted:",
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green, // Background color
          behavior: SnackBarBehavior.floating, // Floating style
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          margin: EdgeInsets.all(20), // Add margin around Snackbar
          elevation: 6, // Add shadow effect
          duration: Duration(seconds: 5), // Display duration
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  "Abstract Form",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
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
                  icon: Icon(Icons.attach_file, color: Colors.white, size: 24),
                  label: Text(
                    "Select File",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004A61),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  padding: const EdgeInsets.only(left: 80, right: 80, top: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF017AFF),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: storeAbstract, // Uploads the file when clicked
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
    );
  }
}
