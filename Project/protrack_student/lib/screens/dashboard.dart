import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Hello, John!"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project Progress",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                  backgroundColor: Colors.blue,
                  //valueColor: Color(Colors.grey),
                  semanticsLabel: '75%',
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Current Projects',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  title: Text('College Project Management System'),
                  subtitle: Text('Due: Jan 31, 2025'),
                  trailing: Text('In Progress'),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Upcoming Deadlines',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.blue),
                      title: Text('Review ${index + 1}'),
                      subtitle: Text('Deadline: Feb ${index + 1}, 2025'),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Announcements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                color: Colors.deepPurple.shade50,
                child: ListTile(
                  leading: Icon(Icons.campaign, color: Colors.blue),
                  title: Text('Mid-Semester Project Review'),
                  subtitle: Text('Scheduled on Feb 10, 2025'),
                ),
              ),
              BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.grey,
                  currentIndex: 0,
                  onTap: (index) {},
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.work),
                      label: 'Projects',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: 'Notifications',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
