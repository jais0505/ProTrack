import 'package:flutter/material.dart';
import 'package:protrack_admin/main.dart';

class YearScreen extends StatefulWidget {
  const YearScreen({super.key});

  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen>
    with SingleTickerProviderStateMixin {
  bool _isFormVisible = false;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final TextEditingController yearController = TextEditingController();
  List<Map<String, dynamic>> _year = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchYear();
  }

  Future<void> yearSubmit() async {
    try {
      String year = yearController.text;
      await supabase.from('tbl_year').insert({
        'year_name': year,
      });
      fetchYear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Year Added',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      print("Inserted");
      print("The year data:$year");
      yearController.clear();
    } catch (e) {
      print("ERROR ADDING YEAR: $e");
    }
  }

  Future<void> fetchYear() async {
    try {
      final response = await supabase.from('tbl_year').select();
      setState(() {
        _year = response;
      });
    } catch (e) {
      print("Error selecting yaer:$e");
    }
  }

  Future<void> deleteyear(int yearId) async {
    try {
      await supabase.from('tbl_year').delete().eq('id', yearId);
    } catch (e) {
      print("ERROR DELETING YEAR:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Manage Year'),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF161616),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18)),
                onPressed: () {
                  setState(() {
                    _isFormVisible = !_isFormVisible;
                  });
                },
                label: Text(
                  _isFormVisible ? "Cancel" : "Add Year",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  _isFormVisible ? Icons.cancel : Icons.add,
                  color: Colors.white,
                ),
              )
            ],
          ),
          AnimatedSize(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            child: _isFormVisible
                ? Form(
                    child: Container(
                      height: 250,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 246, 243, 243)
                                  .withOpacity(0.5),
                            )
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 6),
                            child: Text(
                              "Year Form",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 20, bottom: 20),
                            child: TextFormField(
                              controller: yearController,
                              decoration: InputDecoration(
                                hintText: 'Year',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_month),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 15),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF017AFF),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 70, vertical: 18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () {
                                  yearSubmit();
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text("Year Data"),
                  ListView.builder(
                      itemCount: _year.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final yeardata = _year[index];
                        return ListTile(
                          title: Text(yeardata['year_name']),
                        );
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
