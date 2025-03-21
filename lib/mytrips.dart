import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyTrips extends StatefulWidget {
  const MyTrips({Key? key}) : super(key: key);

  @override
  _MyTripsState createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  List<String> _itineraries = [];
  List<String> _flights = [];
  List<String> _accommodations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _itineraries = _getDataFromPrefs(prefs, 'itineraries');
      _flights = _getDataFromPrefs(prefs, 'flights');
      _accommodations = _getDataFromPrefs(prefs, 'accommodations');
    });
  }
  List<String> _getDataFromPrefs(SharedPreferences prefs, String key) {
    String? storedData = prefs.getString(key);

    if (storedData != null) {
      try {
        var decodedData = json.decode(storedData);
        if (decodedData is List) {
          return List<String>.from(decodedData);
        }
      } catch (e) {
        print("Error decoding data for key $key: $e");
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: ListView(
        children: [
          _buildListSection("🗺 Itineraries", _itineraries),
          _buildListSection("✈ Flights", _flights),
          _buildListSection("🏨 Accommodations", _accommodations),
        ],
      ),
    );
  }
  Widget _buildListSection(String title, List<String> data) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: data.isEmpty
          ? [const Padding(padding: EdgeInsets.all(10), child: Text("No data available."))]
          : data.map((item) {
              return ListTile(
                title: Text(item),
              );
            }).toList(),
    );
  }
}