import 'package:flutter/material.dart';
import 'package:protrack_teacher/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? Name = "";

  fetchTeacherData() async {
    try {
      final response = await supabase
          .from('tbl_teacher')
          .select()
          .eq('teacher_id', supabase.auth.currentUser!.id)
          .maybeSingle()
          .limit(1);
      setState(() {
        Name = response!['teacher_name'];
      });
    } catch (e) {
      print("Error fetching teacher data:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTeacherData();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 16, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber),
                          height: 50,
                          width: 50,
                          child: Icon(Icons.person_2_outlined),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Hi, $Name",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 12, 47, 68)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      child: Image.asset(
                        'assets/Theme.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 10, bottom: 10),
                    child: Container(
                      width: 500,
                      height: 120,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 12, 47, 68),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "“I touch the future. I teach.”               –Christa McAuliffe.",
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 30, right: 30, top: 20),
                  //   child: GridView.count(
                  //     crossAxisCount: 2,
                  //     shrinkWrap: true,
                  //     children: [
                  //       Card(
                  //         elevation: 5,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //         child: Center(child: Text("1")),
                  //       ),
                  //       Card(
                  //         elevation: 5,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20)),
                  //         child: Center(child: Text("2")),
                  //       ),
                  //       Card(
                  //         elevation: 5,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20)),
                  //         child: Center(child: Text("3")),
                  //       ),
                  //       Card(
                  //         elevation: 5,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20)),
                  //         child: Center(child: Text("4")),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
