import 'dart:io';

import 'package:djangify/screens/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExercisesScreen extends StatefulWidget {
  final String selectedClass;
  final String selectedCourse;

  ExercisesScreen({
    required this.selectedClass,
    required this.selectedCourse,
  });

  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  late CollectionReference exercisesCollection;
  late SharedPreferences prefs;
  Map<String, bool> isDownloading = {}; // Track downloading state

  @override
  void initState() {
    super.initState();
    initializeDownloader();

    if (widget.selectedClass.isNotEmpty && widget.selectedCourse.isNotEmpty) {
      exercisesCollection = FirebaseFirestore.instance
          .collection('exercises')
          .doc(widget.selectedClass)
          .collection(widget.selectedCourse);
    } else {
      print('Error: selectedClass or selectedCourse is null or empty');
    }
  }

  Future<void> initializeDownloader() async {
    prefs = await SharedPreferences.getInstance();
    await FlutterDownloader.initialize(debug: true); // Initialize downloader
  }

  Future<String> getDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> isFileDownloaded(String fileName) async {
    final downloadDir = await getDownloadDirectory();
    final filePath = "$downloadDir/$fileName";
    return File(filePath).exists();
  }

  Future<void> downloadFile(String url, String fileName) async {
    final downloadDir = await getDownloadDirectory();
    final filePath = "$downloadDir/$fileName";

    setState(() {
      isDownloading[fileName] = true; // Mark as downloading
    });

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: downloadDir,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );

    if (taskId != null) {
      prefs.setBool(fileName, true); // Mark file as downloaded
    }

    setState(() {
      isDownloading[fileName] = false; // Remove downloading state
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedClass.isEmpty || widget.selectedCourse.isEmpty) {
      return Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            // Full-screen gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF004AAD), Color(0xFFFFDE59)], // Gradient colors
                ),
              ),
            ),
            // Semi-transparent overlay for readability
            Container(
              color: Colors.black.withOpacity(0.6),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Center(
                child: Text(
                  'Veuillez sélectionner une classe et un cours.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Full-screen gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF004AAD), Color(0xFFFFDE59)], // Gradient colors
              ),
            ),
          ),
          // Semi-transparent overlay for readability
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              children: [
                // Custom title - Exercices
                Text(
                  'Exercices',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 30),
                // StreamBuilder for fetching exercises
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: exercisesCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('Aucun exercice disponible.'));
                      }

                      final exercises = snapshot.data!.docs;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          final title = exercise['title'];
                          final pdfUrl = exercise['pdf_url'];
                          final fileName = "$title.pdf";

                          return FutureBuilder<bool>(
                            future: isFileDownloaded(fileName),
                            builder: (context, snapshot) {
                              final isDownloaded = snapshot.data ?? false;

                              return Card(
                                margin: EdgeInsets.only(bottom: 15.0), // Reduced margin
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 8, // Slight shadow for depth
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                                  title: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF004AAD), // Secondary color
                                    ),
                                  ),
                                  trailing: isDownloading[fileName] == true
                                      ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ),
                                  ) // Show loader when downloading
                                      : IconButton(
                                    icon: Icon(
                                      isDownloaded
                                          ? Icons.check_circle
                                          : Icons.download,
                                      color: isDownloaded ? Colors.green : Colors.blue,
                                    ),
                                    onPressed: isDownloaded
                                        ? null // Disable button if already downloaded
                                        : () => downloadFile(pdfUrl, fileName),
                                  ),
                                  onTap: () async {
                                    if (isDownloaded) {
                                      final downloadDir = await getDownloadDirectory();
                                      final filePath = "$downloadDir/$fileName";
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PDFViewerScreen(
                                            filePath: filePath,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Veuillez télécharger le fichier.'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
