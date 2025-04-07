import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';

class MainReviewResults extends StatefulWidget {
  final int mid;
  const MainReviewResults({super.key, required this.mid});

  @override
  State<MainReviewResults> createState() => _MainReviewResultsState();
}

class _MainReviewResultsState extends State<MainReviewResults> {
  List<Map<String, dynamic>> _reviewList = [];

  void dialogBox(BuildContext context, String mark, String remark) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Review Result",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            // Allows dynamic resizing
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Adapts to content size
              children: [
                Row(
                  children: [
                    Icon(Icons.grade, color: Colors.blue), // Icon for mark
                    SizedBox(width: 10),
                    Text(
                      "Mark: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "$mark/5",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.comment, color: Colors.green), // Icon for remark
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Remark: $remark",
                        style: TextStyle(fontSize: 16),
                        softWrap: true, // Allows text wrapping
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchReview() async {
    final response = await supabase
        .from('tbl_review')
        .select()
        .eq('mainproject_id', widget.mid);
    print(response);
    setState(() {
      _reviewList = response;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Review Results",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
      ),
      body: Column(
        children: [
          // Expanded ensures ListView.builder takes available space properly
          Expanded(
            child: ListView.builder(
              itemCount: _reviewList.length, // Number of items in the list
              itemBuilder: (context, index) {
                final data = _reviewList[index];
                String title = data['review_type'];
                return ListTile(
                  leading: Icon(
                    Icons.rate_review,
                    size: 28,
                  ),
                  title: Text(
                    '${title} REVIEW',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    dialogBox(
                        context, data['review_mark'], data['review_reply']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
