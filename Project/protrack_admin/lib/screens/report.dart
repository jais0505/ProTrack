import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _isFormVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(
            'Project Report',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // A deep bluish tone
              letterSpacing: 1.2,
              fontFamily: 'Roboto', // Optional: if you want a specific font
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
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
                      _isFormVisible ? "Cancel" : "Mini Project",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      _isFormVisible ? Icons.cancel : Icons.summarize_outlined,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
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
                      _isFormVisible ? "Cancel" : "Main Project",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      _isFormVisible ? Icons.cancel : Icons.summarize_outlined,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
