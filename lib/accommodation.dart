import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accommodation extends StatefulWidget {
  const Accommodation({Key? key}) : super(key: key);

  @override
  _AccommodationState createState() => _AccommodationState();
}

class _AccommodationState extends State<Accommodation> {
  List<Map<String, String>> _accommodations = [];

  @override
  void initState() {
    super.initState();
    _loadAccommodations();
  }

  Future<void> _loadAccommodations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAccommodations = prefs.getString('accommodations');
    print('Loaded accommodations: $savedAccommodations');

    if (savedAccommodations != null) {
      List<dynamic> accommodationsList = jsonDecode(savedAccommodations);
      setState(() {
        _accommodations = accommodationsList
            .map((accommodation) =>
                Map<String, String>.from(accommodation as Map))
            .toList();
      });
    }
  }

  Future<void> _saveAccommodations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accommodations', jsonEncode(_accommodations));
    print('Accommodations saved: ${jsonEncode(_accommodations)}');
  }

  void _addAccommodation(String name, String location, String checkIn, String checkOut) {
    setState(() {
      _accommodations.add({
        "name": name,
        "location": location,
        "checkIn": checkIn,
        "checkOut": checkOut,
      });
    });
    _saveAccommodations();
  }

  void _deleteAccommodation(int index) {
    setState(() {
      _accommodations.removeAt(index);
    });
    _saveAccommodations();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  void _showAddDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController checkInController = TextEditingController();
    TextEditingController checkOutController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Accommodation'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
                TextField(
                  controller: checkInController,
                  decoration: const InputDecoration(labelText: 'Check-in Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, checkInController),
                ),
                TextField(
                  controller: checkOutController,
                  decoration: const InputDecoration(labelText: 'Check-out Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, checkOutController),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && locationController.text.isNotEmpty) {
                  _addAccommodation(
                    nameController.text,
                    locationController.text,
                    checkInController.text,
                    checkOutController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accommodation Manager')),
      body: _accommodations.isEmpty
          ? const Center(child: Text("No accommodations yet. Add one!"))
          : ListView.builder(
              itemCount: _accommodations.length,
              itemBuilder: (context, index) {
                final accommodation = _accommodations[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("🏨 ${accommodation['name']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("📍 Location: ${accommodation['location']}"),
                        Text("📅 Check-in: ${accommodation['checkIn']}"),
                        Text("📅 Check-out: ${accommodation['checkOut']}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAccommodation(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
