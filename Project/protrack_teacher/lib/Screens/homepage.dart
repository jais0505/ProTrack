import 'package:flutter/material.dart';
import 'package:protrack_teacher/main.dart';
import 'package:protrack_teacher/Screens/mainproject.dart';
import 'package:protrack_teacher/Screens/miniproject.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String teacherName = "";
  int studentCount = 0;
  int miniProjectCount = 0;
  int mainProjectCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      final teacherId = supabase.auth.currentUser!.id;

      // Fetch teacher name
      final teacherRes = await supabase
          .from('tbl_teacher')
          .select('teacher_name')
          .eq('teacher_id', teacherId)
          .maybeSingle();
      teacherName = teacherRes?['teacher_name'] ?? "";
      // Fetch student count
      final studentsRes = await supabase
          .from('tbl_student')
          .count()
          .eq('teacher_id', teacherId);
      studentCount = studentsRes;

      // Fetch mini project count
      final miniRes = await supabase
          .from('tbl_project')
          .count()
          .eq('project_type', 'Mini Project');
      miniProjectCount = miniRes;

      // Fetch main project count
      final mainRes = await supabase
          .from('tbl_project')
          .count()
          .eq('project_type', 'Main Project');
      mainProjectCount = mainRes;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching homepage data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> openMiniProject(BuildContext context) async {
    try {
      final response = await supabase
          .from('tbl_project')
          .select()
          .eq('project_type', 'Mini Project')
          .eq('project_status', 0)
          .order('createdAt', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No Mini Project Started")),
        );
      } else {
        final project = response[0];
        int id = project['project_id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Miniproject(pid: id),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  Future<void> openMainProject(BuildContext context) async {
    try {
      final response = await supabase
          .from('tbl_project')
          .select()
          .eq('project_type', 'Main Project')
          .order('createdAt', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No Main Project Started")),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Mainproject(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 12, 47, 68),
        title: const Text(
          "Home Page",
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFFF6F8FB),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Greeting
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                        ),
                        height: 50,
                        width: 50,
                        child: const Icon(Icons.person_2_outlined, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        "Hi, $teacherName",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 12, 47, 68),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Banner
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/Theme.jpg',
                        fit: BoxFit.cover,
                        height: 160,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Stats
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: .65,
                        ),
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return _StatCard(
                                label: "Students Count",
                                count: studentCount,
                                icon: Icons.group,
                                color: Colors.blue,
                              );
                            case 1:
                              return _StatCard(
                                label: "Mini Projects",
                                count: miniProjectCount,
                                icon: Icons.computer,
                                color: Colors.orange,
                              );
                            case 2:
                            default:
                              return _StatCard(
                                label: "Main Projects",
                                count: mainProjectCount,
                                icon: Icons.rocket_launch,
                                color: Colors.green,
                              );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Project Navigation Cards
                  Row(
                    children: [
                      Expanded(
                        child: _ProjectCard(
                          title: "Mini Project",
                          subtitle: "Tap to view or start",
                          icon: Icons.computer,
                          color: Colors.blue,
                          onTap: () => openMiniProject(context),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _ProjectCard(
                          title: "Main Project",
                          subtitle: "Tap to view or start",
                          icon: Icons.rocket_launch,
                          color: Colors.green,
                          onTap: () => openMainProject(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              count.toString(),
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                radius: 32,
                child: Icon(icon, color: color, size: 36),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
