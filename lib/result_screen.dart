import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  final String results;
  const ResultScreen({Key? key, required this.results}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results',
          style: GoogleFonts.lato(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "Generated Text",
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: const Color.fromARGB(255, 30, 58, 81),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              color: Colors.white70,
              child: ListTile(
                title: Text(
                  widget.results,
                  style: GoogleFonts.lato(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
