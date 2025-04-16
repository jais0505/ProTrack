import 'package:flutter/material.dart';
import 'package:protrack_teacher/Screens/addstudents.dart';
import 'package:protrack_teacher/Screens/student_profile.dart';
import 'package:protrack_teacher/main.dart';

class ManagestudentsScreen extends StatefulWidget {
  const ManagestudentsScreen({super.key});

  @override
  State<ManagestudentsScreen> createState() => _ManagestudentsScreenState();
}

class _ManagestudentsScreenState extends State<ManagestudentsScreen> {
  List<Map<String, dynamic>> _studentList = [];
  List<Map<String, dynamic>> _filteredStudentList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  Future<void> fetchStudentsData() async {
    setState(() {
      _isLoading = true;
    });

    String? tid = supabase.auth.currentUser?.id;

    try {
      final response =
          await supabase.from('tbl_student').select().eq('teacher_id', tid!);
      setState(() {
        _studentList = List<Map<String, dynamic>>.from(response);
        _filteredStudentList = _studentList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching students: $e')),
      );
    }
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudentList = _studentList;
      } else {
        _filteredStudentList = _studentList
            .where((student) => student['student_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchStudentsData();
    _searchController.addListener(() {
      _filterStudents(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF004A61),
        title: const Text(
          'Manage Students',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchStudentsData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search students...',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF004A61)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),
              // Students List Header
              Text(
                'Students (${_filteredStudentList.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004A61),
                ),
              ),
              const SizedBox(height: 12),
              // Students Grid
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredStudentList.isEmpty
                        ? Center(
                            child: Text(
                              _searchController.text.isEmpty
                                  ? 'No students found.'
                                  : 'No students match your search.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: _filteredStudentList.length,
                            itemBuilder: (context, index) {
                              final student = _filteredStudentList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StudentProfile(student: student),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Student Photo
                                      Expanded(
                                        flex: 3,
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                          child: student['student_photo'] !=
                                                  null
                                              ? Image.network(
                                                  student['student_photo'],
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: Center(
                                                        child: Text(
                                                          student['student_name']
                                                                  [0]
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 40,
                                                            color: Color(
                                                                0xFF004A61),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  color: Colors.grey[300],
                                                  child: Center(
                                                    child: Text(
                                                      student['student_name'][0]
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 40,
                                                        color:
                                                            Color(0xFF004A61),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      // Student Name
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(16),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              student['student_name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF004A61),
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddstudentsScreen()),
          );
        },
        backgroundColor: const Color(0xFF004A61),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
