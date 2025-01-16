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

  Future<void> yearSubmit() async {
    try {
      String year = yearController.text;
      await supabase.from('tbl_year').insert({
        'year_name': year,
      });
    } catch (e) {
      print("ERROR ADDING YEAR: $e");
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
                onPressed: () {
                  setState(() {
                    _isFormVisible = !_isFormVisible;
                  });
                },
                label: Text(_isFormVisible ? "Cancel" : "Add Year"),
                icon: Icon(_isFormVisible ? Icons.cancel : Icons.add),
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
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Year Form"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 30, bottom: 20),
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
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
          SingleChildScrollView(
            child: Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Year Data"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
