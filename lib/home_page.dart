import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:qa_generator/result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var logger = Logger();
  File? _image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        _image = imageTemp;
      });
    } on PlatformException catch (e) {
      logger.e("Error occured while selecting image: $e");
    }
  }

  Future recognizeTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognisedText =
        await textDetector.processImage(inputImage);

    String text = '';
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          text += '${element.text} ';
        }
        text += '\n';
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 58, 81),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "QA-Generator",
              style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 40,
            ),
            _image != null
                ? Image.file(
                    _image!,
                    width: 300,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 250,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue[50],
                    ),
                  ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: "Camera",
                  icon: Icons.camera_alt,
                  onClick: () => getImage(ImageSource.camera),
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomButton(
                  icon: Icons.upload_rounded,
                  text: "Device",
                  onClick: () => getImage(ImageSource.gallery),
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_image != null) {
            final String recognizedText = await recognizeTextFromImage(_image!);
            logger.i(recognizedText);
            var localContext = context;
            await Future.delayed(Duration.zero);
            // ignore: use_build_context_synchronously
            Navigator.push(
              localContext,
              MaterialPageRoute(
                builder: (context) => ResultScreen(results: recognizedText,),
              ),
            );
          } else {
            logger.d("No Image Selected");
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  IconData icon;
  String text;
  VoidCallback onClick;
  CustomButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 130,
      child: ElevatedButton.icon(
        onPressed: onClick,
        label: Text(
          text,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(icon),
      ),
    );
  }
}
