import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protrack_student/main.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MainReviewPage extends StatefulWidget {
  final String type;
  final int reviewId;
  const MainReviewPage({super.key, required this.reviewId, required this.type});

  @override
  State<MainReviewPage> createState() => _MainReviewPageState();
}

class _MainReviewPageState extends State<MainReviewPage> {
  List<Map<String, dynamic>> abstracts = [];

  bool isLoading = true;

  File? selectedFile;
  String? fileName;
  String? fileUrl;
  String? _selectedFileType = "";

  int gid = 0;

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
          "Reviewfile/${DateTime.now().millisecondsSinceEpoch}.${fileName!.split('.').last}";

      // Upload file to Supabase storage
      await supabase.storage
          .from('reviewfile')
          .upload(uploadFileName, selectedFile!);

      // Get the public URL of the uploaded file
      fileUrl =
          supabase.storage.from('reviewfile').getPublicUrl(uploadFileName);

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

  Future<void> storereview() async {
    try {
      String? url = await uploadFile();
      await supabase.from('tbl_reviewfile').insert({
        'review_id': widget.reviewId,
        'reviewfile_file': url,
        'file_type': _selectedFileType
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Review file submitted:",
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
      fetchReviewFiles();
      setState(() {
        selectedFile = null;
        _selectedFileType = "";
      });
    } catch (e) {
      print("Error inserting review data:$e");
    }
  }

  void openAbstract(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open file")),
      );
    }
  }

  Future<void> _launchPDF(String abstractUrl) async {
    print("PDF URL: $abstractUrl");
    setState(() => isLoading = true);
    try {
      // Download the PDF temporarily
      final response = await http.get(Uri.parse(abstractUrl));
      final bytes = response.bodyBytes;

      // Save to temporary directory
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(bytes);

      // Open the PDF
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        print('Error opening PDF: ${result.message}');
        // Optional: Show error message to user
      }
    } catch (e) {
      print('Error: $e');
      // Optional: Show error message to user
    }
    setState(() => isLoading = false);
  }

  Future<void> fetchReviewFiles() async {
    try {
      final response = await supabase
          .from('tbl_reviewfile')
          .select()
          .eq('review_id', widget.reviewId);
      setState(() {
        abstracts = response;
        isLoading = false;
      });
      print("File fetched");
      print("Abstract:$response");
    } catch (e) {
      print("Error fetching review files:$e");
    }
  }

  Future<void> updateGpstatus() async {
    try {
      int? status;
      if (widget.type == "FIRST") {
        status = 4;
      } else if (widget.type == "SECOND") {
        status = 6;
      } else if (widget.type == "THIRD") {
        status = 8;
      }
      final response = await supabase
          .from('tbl_review')
          .select()
          .eq('review_id', widget.reviewId)
          .maybeSingle()
          .limit(1);
      await supabase
          .from('tbl_mainproject')
          .update({'mainproject_status': status}).eq(
              'mainproject_id', response!['mainproject_id']);
      print("Mainproject status updated");
    } catch (e) {
      print("Error updating mainproject status:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReviewFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Review",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              updateGpstatus();
              Navigator.pop(context);
            },
            label: Text(
              'Finished',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      "Review Form",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14, bottom: 20),
                      child: Row(
                        children: [
                          Text(
                            "Choose File Type: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          // Radio Button for Image

                          Text(
                            "Image",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Radio<String>(
                            value: "image",
                            groupValue: _selectedFileType,
                            onChanged: (value) {
                              setState(() {
                                _selectedFileType = value;
                              });
                            },
                          ),

                          // Radio Button for PDF
                          Text(
                            "PDF",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Radio<String>(
                            value: "pdf",
                            groupValue: _selectedFileType,
                            onChanged: (value) {
                              setState(() {
                                _selectedFileType = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: pickFile, // Pick File Function
                      icon: Icon(Icons.attach_file,
                          color: Colors.white, size: 24),
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
                            EdgeInsets.symmetric(horizontal: 25, vertical: 12),
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
                          const EdgeInsets.only(left: 80, right: 80, top: 25),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF017AFF),
                          padding: EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onPressed: () {
                          storereview();
                        },
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
            Column(
              children: [
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : abstracts.isEmpty
                        ? Center(child: Text("No Files uploaded yet."))
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(15),
                            itemCount: abstracts.length,
                            itemBuilder: (context, index) {
                              final abstract = abstracts[index];
                              return Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.description,
                                      color: Colors.blue),
                                  title: Text(
                                    abstract['file_type'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("Tap to view abstract"),
                                  trailing: Icon(Icons.open_in_new,
                                      color: Colors.blue),
                                  onTap: () =>
                                      _launchPDF(abstract['reviewfile_file']),
                                ),
                              );
                            },
                          ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
