import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:card/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrPage extends StatefulWidget {
  const OcrPage({super.key});

  @override
  State<OcrPage> createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> {
  final HomeController _homeController = Get.put(HomeController());
  bool textScanning = false;

  String recognizedText = "No text detected";
  XFile? imageFile;
  String extractedName = "No name found";
  String extractedEmail = "No email found";
  String extractedPhone = "No phone number found";
  String extractedAddress = "No address found";
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image:  AssetImage('assets/bg_3.jpg',),fit: BoxFit.cover)
      ),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white60,
                  Colors.black45,

                ])
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.teal,
            leading: IconButton(onPressed: (){
              Get.back();
              _homeController.textAnimationFinished.value=false;
            },
                icon: Icon(Icons.arrow_back)
            ),
            centerTitle: true,
            title: const Text("Text Recognition"),
          ),
          body: Obx(()=> SingleChildScrollView(
                    child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!textScanning && imageFile == null)
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.teal[100],
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      width: double.infinity,
                      height: screenHeight*0.4,

                      child: Center(
                          child: Text(
                        textAlign: TextAlign.center,
                        "No Selected Image!\nCapture or select image to scan text.",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                    ),
                  ),
                ),
              if (imageFile != null)
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Image.file(
                        height: MediaQuery.of(context).size.height*.3,
                        width: double.infinity,
                        fit:BoxFit.cover,
                        File(imageFile!.path,))),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Please Select an Image.",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          backgroundColor: Colors.white,
                          shadowColor: Colors.grey[400],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image,
                                size: 30,
                                color: Colors.teal,
                              ),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          backgroundColor: Colors.white,
                          shadowColor: Colors.grey[400],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Colors.teal,
                              ),
                              Text(
                                "Camera",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              scannedText.isNotEmpty ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 1,color: Colors.black26,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      border:Border.all(
                        color: Colors.teal
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                      child: Text(
                        textAlign: TextAlign.start,
                        "Recognized Text",
                        style: TextStyle(
                          color: Colors.teal[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  textScanning? Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Center(child: SpinKitThreeBounce(color: Colors.teal,size: 32,)),
                  ):
                  Card(
                    color: Colors.teal[50],
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: AnimatedTextKit(
                          onFinished: (){
                            _homeController.textAnimationFinished.value=true;
                          },
                            isRepeatingAnimation: false,
                            animatedTexts: [TyperAnimatedText(speed:Duration(milliseconds: 50) ,scannedText,textAlign: TextAlign.start,textStyle:TextStyle(fontSize: 20), )]
                        ),
                      ),
                    ),
                  ),
                ],
              ):SizedBox(),
              SizedBox(height: 10,),
              _homeController.textAnimationFinished.value? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 1,color: Colors.black26,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        border:Border.all(
                            color: Colors.teal
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                      child: Text(
                        textAlign: TextAlign.start,
                        "Copy Text From Here",
                        style: TextStyle(
                          color: Colors.teal[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: Colors.grey[100],
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SelectableText(
                          scannedText,
                          style: TextStyle(fontSize: 22, color: Colors.black54),
                          onTap: () {
                            // Copy text to clipboard on tap
                            Clipboard.setData(ClipboardData(text: scannedText));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Text copied to clipboard')),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Extracted Name: $extractedName'),
                  Text('Extracted Email: $extractedEmail'),
                  Text('Extracted Phone: $extractedPhone'),
                  Text('Extracted Address: $extractedAddress'),
                ],
              ):SizedBox(),


              // Text(
              //   recognizedText,
              //   style: TextStyle(fontSize: 20),
              // ),
            ],
          ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        // getRecognisedText(pickedImage);
        _recognizeText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occurred while scanning";
      setState(() {});
    }
  }

  Future<void> _recognizeText(XFile imageFile) async {
    _homeController.textAnimationFinished.value=false;
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final textRecognizer = TextRecognizer();
    try {
      final RecognizedText recognizedTextResult =
          await textRecognizer.processImage(inputImage);
      setState(() {
        recognizedText = recognizedTextResult.text;
      });
      _extractDetails(recognizedText);
      scannedText = "";
      for (TextBlock block in recognizedTextResult.blocks) {
        for (TextLine line in block.lines) {
          scannedText = "$scannedText${line.text}\n";
        }
      }
      textScanning = false;
      setState(() {});
    } catch (e) {
      print("Error recognizing text: $e");
    } finally {
      textRecognizer
          .close(); // Always close the recognizer to free up resources
    }
  }
  void _extractDetails(String fullText) {
    // Simple regex for email and phone numbers
    final RegExp emailRegExp = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}');
    final RegExp phoneRegExp = RegExp(r'(\+?\d{1,4}?[-.\s]?)?((\(?\d{3}\)?[-.\s]?)|(\d{3}[-.\s]?))\d{3}[-.\s]?\d{4}');
    final RegExp nameRegExp = RegExp(r'[A-Z][a-z]+\s[A-Z][a-z]+'); // Assuming full name with first and last name.
    // Simple regex for addresses (matches common address structures: street number, street name, city, state, postal code)
    final RegExp addressRegExp = RegExp(r'\d+\s+\w+\s+(Street|St|Avenue|Ave|Road|Rd|Boulevard|Blvd|Lane|Ln|Drive|Dr|Court|Ct)\s*,?\s*\w+,\s*\w+\s*\d{5}(-\d{4})?');
    // Extract email
    final Iterable<Match> emailMatches = emailRegExp.allMatches(fullText);
    final Iterable<Match> phoneMatches = phoneRegExp.allMatches(fullText);
    final Iterable<Match> nameMatches = nameRegExp.allMatches(fullText);
    final Iterable<Match> addressMatches = addressRegExp.allMatches(fullText);

    setState(() {
      extractedEmail = emailMatches.isNotEmpty ? emailMatches.first.group(0)! : "No email found";
      extractedPhone = phoneMatches.isNotEmpty ? phoneMatches.first.group(0)! : "No phone number found";
      extractedName = nameMatches.isNotEmpty ? nameMatches.first.group(0)! : "No name found";
      extractedAddress = addressMatches.isNotEmpty ? addressMatches.first.group(0)! : "No address found";
    });
  }
  // void getRecognisedText(XFile image) async {
  //   final inputImage = InputImage.fromFilePath(image.path);
  //   final textDetector = Googlete.vision.textDetector();
  //   RecognisedText recognisedText = await textDetector.processImage(inputImage);
  //   await textDetector.close();
  //   scannedText = "";
  //   for (TextBlock block in recognisedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       scannedText = scannedText + line.text + "\n";
  //     }
  //   }
  //   textScanning = false;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
  }
}
