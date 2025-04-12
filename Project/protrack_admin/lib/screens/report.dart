import 'package:flutter/material.dart';
import 'package:protrack_admin/main.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final Duration _animationDuration = const Duration(milliseconds: 400);
  final List<Map<String, dynamic>> _miniList = [];

  Future<void> fetchMiniDetails() async {
    try {
      final response = await supabase.from('tbl_group').select();
      print("Response:$response");
    } catch (e) {
      print("Error fetching mini peoject details:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMiniDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
                height: 500,
                width: 1100,
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
                    Text(
                      "Project Report",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // A deep bluish tone
                        letterSpacing: 1.2,
                        fontFamily:
                            'Roboto', // Optional: if you want a specific font
                      ),
                    ),
                    DataTable(
                      columnSpacing: 12,
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Group')),
                        DataColumn(label: Text('Project Title')),
                        DataColumn(label: Text('Guide')),
                        DataColumn(label: Text('Review 1')),
                        DataColumn(label: Text('Review 2')),
                        DataColumn(label: Text('Review 3')),
                        DataColumn(label: Text('Total (15)')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: _miniList.map((_miniList) {
                        final total60 =
                            _miniList['r1'] + _miniList['r2'] + _miniList['r3'];
                        final total100 = total60 + _miniList['final'];

                        return DataRow(cells: [
                          DataCell(Text(_miniList['name'])),
                          DataCell(Text(_miniList['group'])),
                          DataCell(Text(_miniList['title'])),
                          DataCell(Text(_miniList['guide'])),
                          DataCell(Text(_miniList['r1'].toString())),
                          DataCell(Text(_miniList['r2'].toString())),
                          DataCell(Text(_miniList['r3'].toString())),
                          DataCell(Text(total60.toString())),
                          DataCell(Text(total100.toString())),
                          DataCell(Text(_miniList['status'])),
                        ]);
                      }).toList(),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
