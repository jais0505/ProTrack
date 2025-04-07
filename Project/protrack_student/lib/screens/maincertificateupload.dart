import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protrack_student/main.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MainCertificateUpload extends StatefulWidget {
  const MainCertificateUpload({
    super.key,
  });

  @override
  State<MainCertificateUpload> createState() => _MainCertificateUploadState();
}

class _MainCertificateUploadState extends State<MainCertificateUpload> {
  List<Map<String, dynamic>> abstracts = [];

  bool isLoading = true;

  File? selectedFile;
  String? fileName;
  String? fileUrl;

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
          .from('certificate')
          .upload(uploadFileName, selectedFile!);

      // Get the public URL of the uploaded file
      fileUrl =
          supabase.storage.from('certificate').getPublicUrl(uploadFileName);

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

  Future<void> storecertificate() async {
    try {
      final sid = supabase.auth.currentUser?.id;
      print("SID:$sid");
      String? url = await uploadFile();
      await supabase.from('tbl_mainproject').update({
        'mainproject_certificate': url,
        'mainproject_status': 10
      }).eq('student_id', sid!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Certificate submitted:",
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
      // fetchReviewFiles();
      setState(() {
        selectedFile = null;
      });
    } catch (e) {
      print("Error inserting Ceritficate data:$e");
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

  // Future<void> fetchReviewFiles() async {
  //   try {
  //     final response = await supabase
  //         .from('tbl_reviewfile')
  //         .select()
  //         .eq('review_id', widget.reviewId);
  //     setState(() {
  //       abstracts = response;
  //       isLoading = false;
  //     });
  //     print("File fetched");
  //     print("Abstract:$response");
  //   } catch (e) {
  //     print("Error fetching review files:$e");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // fetchReviewFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Ceritificate Upload",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              // updateGpstatus();
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
              padding: const EdgeInsets.all(16.0), // Slightly increased padding
              child: Container(
                width: 400,
                height: 450, // Slightly taller for better spacing
                decoration: BoxDecoration(
                  color: Colors.white, // White background for contrast
                  border: Border.all(
                      color: Colors.grey.shade300, width: 1.5), // Softer border
                  borderRadius:
                      BorderRadius.circular(15), // More rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Subtle shadow
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center content vertically
                  children: [
                    // Title
                    const Text(
                      "Upload Certificate",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004A61), // Matching the button color
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Icon to represent upload (visual cue)
                    Icon(
                      Icons.cloud_upload_rounded,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 30),

                    // Select File Button
                    ElevatedButton.icon(
                      onPressed: pickFile, // Pick File Function
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: const Text(
                        "Select Certificate",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004A61),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        shadowColor:
                            Colors.black.withOpacity(0.3), // Subtle shadow
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Selected File Display
                    if (fileName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.green
                              .withOpacity(0.1), // Light green background
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Selected: $fileName",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),

                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF017AFF),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.blue,
                            disabledBackgroundColor: Color(0xFF017AFF)),
                        onPressed: fileName != null
                            ? () {
                                storecertificate();
                              }
                            : null,
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            // Column(
            //   children: [
            //     isLoading
            //         ? Center(
            //             child: CircularProgressIndicator(),
            //           )
            //         : abstracts.isEmpty
            //             ? Center(child: Text("No Files uploaded yet."))
            //             : ListView.builder(
            //                 shrinkWrap: true,
            //                 padding: EdgeInsets.all(15),
            //                 itemCount: abstracts.length,
            //                 itemBuilder: (context, index) {
            //                   final abstract = abstracts[index];
            //                   return Card(
            //                     elevation: 3,
            //                     margin: EdgeInsets.symmetric(vertical: 10),
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: ListTile(
            //                       leading: Icon(Icons.description,
            //                           color: Colors.blue),
            //                       title: Text(
            //                         abstract['file_type'],
            //                         style:
            //                             TextStyle(fontWeight: FontWeight.bold),
            //                       ),
            //                       subtitle: Text("Tap to view abstract"),
            //                       trailing: Icon(Icons.open_in_new,
            //                           color: Colors.blue),
            //                       onTap: () =>
            //                           _launchPDF(abstract['reviewfile_file']),
            //                     ),
            //                   );
            //                 },
            //               ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
