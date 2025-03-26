import 'dart:io';
import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/reviewproject.dart';
import 'package:protrack_teacher/main.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class GroupPage extends StatefulWidget {
  final int gid;
  const GroupPage({super.key, required this.gid});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool isLoading = true;

  String projectTitle = "";
  String projectCenter = "";
  String groupmember1 = "";
  String groupmember2 = "";
  String abstractURl = "";
  Map<String, dynamic> groupDetails = {};
  int status = 0;

  Future<void> fetchGroupDetails() async {
    try {
      print("Group: ${widget.gid}");
      final response = await supabase
          .from('tbl_group')
          .select("*, tbl_groupmember(*, tbl_student(*))")
          .eq('group_id', widget.gid)
          .single();
      setState(() {
        groupDetails = response;
        projectTitle = response['project_title'] ?? "No Title";
        projectCenter = response['group_center'] ?? "Not selected";
        groupmember1 =
            response['tbl_groupmember'][0]['tbl_student']['student_name'];
        groupmember2 =
            response['tbl_groupmember'][1]['tbl_student']['student_name'];
        abstractURl = response['group_abstract'] ?? "";
        isLoading = false;
        status = response['group_status'];
      });
      print("Response: $response");
      print("Status:$status");
    } catch (e) {
      print("Error fetching group details: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _launchPDF(String abstractUrl) async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(abstractUrl));
      final bytes = response.bodyBytes;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(bytes);

      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        print('Error opening PDF: ${result.message}');
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> updateGroupStatus(int status) async {
    try {
      await supabase
          .from('tbl_group')
          .update({'group_status': status}).eq('group_id', widget.gid);
      fetchGroupDetails();
      if (status == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abstract Accepted Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (status == 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abstract rejected Successfully!'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No change in abstract status!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error updating group status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update group status. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGroupDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            "Group Page",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        ),
        body: isLoading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.9, // 90% of screen width
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Reduces extra height
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoCard(),
                          SizedBox(height: 15), // Reduced spacing
                          _buildAbstractSection(),
                          SizedBox(height: 15),
                          groupDetails['group_status'] == 1
                              ? _buildActionButtons()
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }

  Widget _buildInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow("📌 Project Title", projectTitle),
        _buildDetailRow("👤 Group Member 1", groupmember1),
        _buildDetailRow("👤 Group Member 2", groupmember2),
        _buildDetailRow("🏢 Project Center", projectCenter),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          children: [
            TextSpan(
              text: value.isNotEmpty ? value : "N/A",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbstractSection() {
    return Column(
      children: [
        status == 1
            ? Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.remove_red_eye, color: Colors.white),
                  label: Text(
                    'View Abstract',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _launchPDF(abstractURl),
                ),
              )
            : SizedBox(),
        SizedBox(
          height: 20,
        ),
        status == 4
            ? ElevatedButton.icon(
                icon: Icon(Icons.remove_red_eye, color: Colors.white),
                label: Text(
                  'Review 1',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewProjectPage(
                                type: "FIRST",
                                gid: widget.gid,
                              )));
                },
              )
            : SizedBox(),
        status == 6
            ? ElevatedButton.icon(
                icon: Icon(Icons.remove_red_eye, color: Colors.white),
                label: Text(
                  'Review 2',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewProjectPage(
                                type: "SECOND",
                                gid: widget.gid,
                              )));
                },
              )
            : SizedBox(),
        status == 8
            ? ElevatedButton.icon(
                icon: Icon(Icons.remove_red_eye, color: Colors.white),
                label: Text(
                  'Review 3',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewProjectPage(
                                type: "THIRD",
                                gid: widget.gid,
                              )));
                },
              )
            : SizedBox(),
        status == 9
            ? Text(
                "Project completed successfully!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  letterSpacing: 1.2, // Slight spacing for readability
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton("Accept", Icons.check, Colors.green, () {
          updateGroupStatus(2);
          print("Abstract Accepted");
          // Add logic for accepting
        }),
        _buildButton("Reject", Icons.close, Colors.red, () {
          updateGroupStatus(3);
          print("Abstract Rejected");
          // Add logic for rejecting
        }),
      ],
    );
  }

  Widget _buildButton(
      String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: onPressed,
    );
  }
}
