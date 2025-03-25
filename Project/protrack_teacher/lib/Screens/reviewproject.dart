import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protrack_teacher/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewProjectPage extends StatefulWidget {
  final int gid;
  final String type;
  const ReviewProjectPage({super.key, required this.gid, required this.type});

  @override
  State<ReviewProjectPage> createState() => _ReviewProjectPageState();
}

class _ReviewProjectPageState extends State<ReviewProjectPage> {
  final TextEditingController _markController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  List<Map<String, dynamic>> abstracts = [];

  bool isLoading = true;

  int rid = 0;

  final formKey = GlobalKey<FormState>();

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
      final review = await supabase
          .from('tbl_review')
          .select()
          .eq('group_id', widget.gid)
          .eq('review_type', widget.type)
          .maybeSingle()
          .limit(1);
      final response = await supabase
          .from('tbl_reviewfile')
          .select()
          .eq('review_id', review!['review_id']);
      print(response);
      setState(() {
        abstracts = response;
        isLoading = false;
        rid = review['review_id'];
      });
      print("File fetched");
      print("Abstract:$response");
    } catch (e) {
      print("Error fetching review files:$e");
    }
  }

  Future<void> updateMark() async {
    try {
      int? status;
      if (widget.type == "FIRST") {
        status = 5;
      } else if (widget.type == "SECOND") {
        status = 7;
      } else if (widget.type == "THIRD") {
        status = 9;
      }
      await supabase.from('tbl_review').update({
        'review_mark': _markController.text,
        'review_reply': _replyController.text
      }).eq('review_id', rid);

      await supabase
          .from('tbl_group')
          .update({'group_status': status}).eq('group_id', widget.gid);
      print("Status:$status");
      Navigator.pop(context);
    } catch (e) {
      print("Error updating mark:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReviewFiles();
  }

  void dialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Submit Mark"),
          content: SizedBox(
            height: 300,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                      validator: (value) {
                        int mark = int.parse(value!);
                        if (mark > 5) {
                          return "Mark should be less than or equal to 5";
                        }
                        return null;
                      },
                      controller: _markController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Enter review mark',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.score_outlined))),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      minLines: 3,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: _replyController,
                      decoration: InputDecoration(
                          hintText: 'Enter review reply',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.message)))
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    updateMark();
                  }
                },
                child: Text("Submit")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Review Project",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : abstracts.isEmpty
              ? Center(child: Text("No reviewfile uploaded yet."))
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
                        leading: Icon(Icons.description, color: Colors.blue),
                        title: Text(
                          abstract['file_type'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Tap to view abstract"),
                        trailing: Icon(Icons.open_in_new, color: Colors.blue),
                        onTap: () => _launchPDF(abstract['reviewfile_file']),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: OutlinedButton(
            onPressed: () {
              dialogBox();
            },
            child: Text("Proceed")),
      ),
    );
  }
}
