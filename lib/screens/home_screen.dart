import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedClass;
  String? selectedCourse;
  final List<String> classes = ['Seconde', 'Première', 'Terminale'];
  final List<String> courses = [
    'TG Electricité',
    'TG Mécanique',
    'Construction mécanique',
    'Automatisme',
    'Mathématiques',
    'Physique Chimie'
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedClass = prefs.getString('selectedClass') ?? classes.first;
      selectedCourse = prefs.getString('selectedCourse') ?? courses.first;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (selectedClass != null) {
      await prefs.setString('selectedClass', selectedClass!);
    }
    if (selectedCourse != null) {
      await prefs.setString('selectedCourse', selectedCourse!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Extend the body behind the AppBar (as it's removed)
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
          // Translucent container for content to maintain readability
          Container(
            color: Colors.black.withOpacity(0.6), // Semi-transparent background
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Custom title - Tekma
                Text(
                  'Tekma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'La technicité à votre portée !',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for contrast
                  ),
                ),
                SizedBox(height: 30),
                _buildDropdown('Sélectionnez une classe', selectedClass, classes),
                SizedBox(height: 20),
                _buildDropdown('Sélectionnez un cours', selectedCourse, courses),
                SizedBox(height: 40),
                _buildActionButton('Accéder aux Leçons', '/lessons', context),
                SizedBox(height: 20),
                _buildActionButton('Accéder aux Exercices', '/exercises', context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hintText, String? selectedValue, List<String> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF004AAD)),
        borderRadius: BorderRadius.circular(25), // Rounded corners for a modern look
        color: Colors.white.withOpacity(0.8), // Slight white background for readability
      ),
      child: DropdownButton<String>(
        hint: Text(hintText, style: TextStyle(color: Color(0xFF004AAD))),
        value: selectedValue,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down, color: Color(0xFF004AAD)),
        style: TextStyle(color: Color(0xFF004AAD)),
        dropdownColor: Color(0xFFFFDE59), // Dropdown background color
        onChanged: (value) {
          setState(() {
            if (hintText == 'Sélectionnez une classe') {
              selectedClass = value;
            } else {
              selectedCourse = value;
            }
            _savePreferences();
          });
        },
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004AAD),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButton(String label, String route, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFDE59), // Primary color
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: (selectedClass != null && selectedClass!.isNotEmpty) &&
          (selectedCourse != null && selectedCourse!.isNotEmpty)
          ? () {
        Navigator.pushNamed(
          context,
          route,
          arguments: {
            'class': selectedClass!,
            'course': selectedCourse!
          },
        );
      }
          : null,
      child: Text(label),
    );
  }
}
