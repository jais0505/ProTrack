import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String projectType = "";
  String startDate = "";
  String review1Date = "";
  String review2Date = "";
  String review3Date = "";

  Future<void> FetchProject() async {
    try {
      final response = await supabase
          .from('tbl_project')
          .select()
          .eq('project_status', 1)
          .single()
          .limit(1);

      setState(() {
        projectType = response['project_type'];
        startDate = response['project_date'];
        review1Date = response['project_review1'];
        review2Date = response['project_review2'];
        review3Date = response['project_review3'];
      });
    } catch (e) {
      print("Error fetching project data:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FetchProject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        title: Text(
          "Home Page",
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Image.asset(
                  'assets/tech.avif',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Current Projects',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 12, 47, 68)),
              ),
              SizedBox(height: 6),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Add padding for better spacing
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectType,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4), // Space between title and subtitle
                      Text("Start date:$startDate"),
                      SizedBox(
                          height: 8), // Space between subtitle and progress bar
                      LinearProgressIndicator(
                        value: 0.6, // Change this value dynamically (0.0 - 1.0)
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                      SizedBox(
                          height: 8), // Space between progress bar and status
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'In Progress',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 12, 47, 68),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Upcoming Deadlines',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.calendar_today,
                      color: const Color.fromARGB(255, 12, 47, 68)),
                  title: Text('Review 1'),
                  subtitle: Text('Deadline: $review1Date'),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.calendar_today,
                      color: const Color.fromARGB(255, 12, 47, 68)),
                  title: Text('Review 2'),
                  subtitle: Text('Deadline: $review2Date'),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.calendar_today,
                      color: const Color.fromARGB(255, 12, 47, 68)),
                  title: Text('Review 3'),
                  subtitle: Text('Deadline: $review3Date'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
