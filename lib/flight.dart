import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Flight extends StatefulWidget {
  const Flight({Key? key}) : super(key: key);

  @override
  _FlightState createState() => _FlightState();
}

class _FlightState extends State<Flight> {
  List<Map<String, String>> _flights = [];

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  // Load flights from SharedPreferences
  Future<void> _loadFlights() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedFlights = prefs.getString('flights');
  if (savedFlights != null) {
    List<dynamic> decodedList = jsonDecode(savedFlights);
    
    setState(() {
      _flights = decodedList.map((item) => Map<String, String>.from(item)).toList();
    });
  }
}

  // Save flights to SharedPreferences
  Future<void> _saveFlights() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('flights', jsonEncode(_flights));
  }
  void _addFlight(String airline, String flightNumber, String departureDate, String arrivalDate) {
    setState(() {
      _flights.add({
        "airline": airline,
        "flightNumber": flightNumber,
        "departureDate": departureDate,
        "arrivalDate": arrivalDate,
      });
    });
    _saveFlights();
  }
  void _deleteFlight(int index) {
    setState(() {
      _flights.removeAt(index);
    });
    _saveFlights();
  }
  void _showAddFlightDialog() {
    TextEditingController airlineController = TextEditingController();
    TextEditingController flightNumberController = TextEditingController();
    TextEditingController departureDateController = TextEditingController();
    TextEditingController arrivalDateController = TextEditingController();

    Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
      DateTime selectedDate = DateTime.now();
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          controller.text = "${selectedDate.toLocal()}".split(' ')[0];
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Flight Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: airlineController, decoration: const InputDecoration(labelText: 'Airline')),
                TextField(controller: flightNumberController, decoration: const InputDecoration(labelText: 'Flight Number')),
                TextField(
                  controller: departureDateController,
                  decoration: const InputDecoration(labelText: 'Departure Date'),
                  onTap: () => _selectDate(context, departureDateController),
                  readOnly: true, 
                ),
                TextField(
                  controller: arrivalDateController,
                  decoration: const InputDecoration(labelText: 'Arrival Date'),
                  onTap: () => _selectDate(context, arrivalDateController),
                  readOnly: true,
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
                if (airlineController.text.isNotEmpty && flightNumberController.text.isNotEmpty) {
                  _addFlight(
                    airlineController.text,
                    flightNumberController.text,
                    departureDateController.text,
                    arrivalDateController.text,
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
      appBar: AppBar(title: const Text('Flight Details')),
      body: _flights.isEmpty
          ? const Center(child: Text("No flight details added yet. Add one!"))
          : ListView.builder(
              itemCount: _flights.length,
              itemBuilder: (context, index) {
                final flight = _flights[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("✈ Airline: ${flight['airline']}", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("🛫 Flight Number: ${flight['flightNumber']}", style: TextStyle(fontSize: 14)),
                        Text("📅 Departure Date: ${flight['departureDate']}", style: TextStyle(fontSize: 14)),
                        Text("📅 Arrival Date: ${flight['arrivalDate']}", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteFlight(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFlightDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}