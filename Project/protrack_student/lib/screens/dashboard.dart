import 'package:flutter/material.dart';
import 'package:protrack_student/main.dart';
import 'package:protrack_student/screens/changepassword.dart';
import 'package:protrack_student/screens/editprofile.dart';
import 'package:protrack_student/screens/mainproject.dart';
import 'package:protrack_student/screens/miniproject.dart';
import 'package:protrack_student/screens/newlogin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  String photo = "";
  String name = "";
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      String? studentId = supabase.auth.currentUser?.id;

      if (studentId != null) {
        final response = await supabase
            .from('tbl_student')
            .select("*,tbl_year(*)")
            .eq("student_id", studentId)
            .single();

        setState(() {
          name = response['student_name'];
          photo = response['student_photo'] ?? "";
          _emailController.text = response['student_email'];
          _phonenoController.text = response['student_contact'];
          _yearController.text = response['tbl_year']['year_name'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: No user ID found")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    }
  }

  Future<void> checkMiniProject() async {
    try {
      final response = await supabase
          .from('tbl_project')
          .select()
          .eq('project_status', 0)
          .order('createdAt', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No mini project started")),
        );
      } else {
        final project = response[0];
        int id = project['project_id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Miniproject(id: id),
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
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phonenoController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchData,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Profile Info
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF004A61),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: photo.isNotEmpty
                                        ? NetworkImage(photo)
                                        : null,
                                    child: photo.isEmpty
                                        ? const Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome,",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          _yearController.text,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Editprofile()),
                                        );
                                        fetchData();
                                      } else if (value == 'password') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ChangepasswordScreen()),
                                        );
                                      } else if (value == 'logout') {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NewLoginPage()),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit Profile'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'password',
                                        child: Text('Change Password'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'logout',
                                        child: Text('Logout'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "My Projects",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Projects Section
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Projects",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF004A61),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Project Cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildProjectCard(
                                  title: "Mini Project",
                                  icon: Icons.lightbulb_outline,
                                  onTap: checkMiniProject,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildProjectCard(
                                  title: "Main Project",
                                  icon: Icons.work_outline,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MainProjectScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Profile Information Section
                          const Text(
                            "Profile Information",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF004A61),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Profile Info Card
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildInfoField(
                                    label: "Email",
                                    value: _emailController.text,
                                    icon: Icons.email,
                                  ),
                                  const Divider(height: 20),
                                  _buildInfoField(
                                    label: "Phone",
                                    value: _phonenoController.text,
                                    icon: Icons.phone,
                                  ),
                                  const Divider(height: 20),
                                  _buildInfoField(
                                    label: "Year",
                                    value: _yearController.text,
                                    icon: Icons.school,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFF004A61),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004A61),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF004A61),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
