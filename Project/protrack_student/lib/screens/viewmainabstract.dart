import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewMainAbstract extends StatefulWidget {
  const ViewMainAbstract({super.key});

  @override
  State<ViewMainAbstract> createState() => _ViewMainAbstractState();
}

class _ViewMainAbstractState extends State<ViewMainAbstract> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> abstracts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAbstracts();
  }

  Future<void> fetchAbstracts() async {
    try {
      String? sid = supabase.auth.currentUser?.id;

      final response = await supabase
          .from('tbl_mainproject')
          .select()
          .eq('student_id', sid!);
      setState(() {
        abstracts = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching abstracts: $e");
      setState(() {
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("View Abstract"),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : abstracts.isEmpty
              ? Center(child: Text("No abstract uploaded yet."))
              : ListView.builder(
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
                        leading: Icon(Icons.description, color: Colors.blue),
                        title: Text(
                          abstract['mainproject_title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Tap to view abstract"),
                        trailing: Icon(Icons.open_in_new, color: Colors.blue),
                        onTap: () =>
                            _launchPDF(abstract['mainproject_abstract']),
                      ),
                    );
                  },
                ),
    );
  }
}
