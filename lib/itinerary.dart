import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Itinerary extends StatefulWidget {
  const Itinerary({Key? key}) : super(key: key);

  @override
  _ItineraryState createState() => _ItineraryState();
}

class _ItineraryState extends State<Itinerary> {
  List<Map<String, dynamic>> _itineraries = [];
  List<String> destinations = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic',
    'Democratic Republic of the Congo',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'East Timor (Timor-Leste)',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Ivory Coast (Côte d\'Ivoire)',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Korea, North',
    'Korea, South',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar (Burma)',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe'

  ];
  String? selectedDestination;
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItineraries();
  }
  Future<void> _loadItineraries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedItineraries = prefs.getString('itineraries');
    if (savedItineraries != null) {
      setState(() {
        _itineraries = List<Map<String, dynamic>>.from(jsonDecode(savedItineraries));
      });
    }
  }
  Future<void> _saveItineraries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('itineraries', jsonEncode(_itineraries));
  }
  void _addItinerary(String location, List<Map<String, dynamic>> plans) {
    setState(() {
      _itineraries.add({
        "location": location,
        "plans": plans,
      });
    });
    _saveItineraries();
  }
  void _deleteItinerary(int index) {
    setState(() {
      _itineraries.removeAt(index);
    });
    _saveItineraries();
  }
  void _showAddDialog() {
    TextEditingController activityController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    List<Map<String, dynamic>> plans = [];
    List<String> activities = [];
    DateTime? selectedDate;

    void addPlan() {
      if (selectedDate != null &&
          locationController.text.isNotEmpty &&
          activities.isNotEmpty) {
        setState(() {
          plans.add({
            "date": dateController.text,
            "location": locationController.text,
            "activities": List.from(activities),
          });
          locationController.clear();
          activities.clear();
          selectedDate = null;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Itinerary'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: selectedDestination,
                      hint: const Text('Select a Destination'),
                      items: destinations.map<DropdownMenuItem<String>>((String destination) {
                        return DropdownMenuItem<String>(
                          value: destination,
                          child: Text(destination),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDestination = newValue;
                        });
                      },
                    ),
                    TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
                    TextField(controller: activityController, decoration: const InputDecoration(labelText: 'Activity')),
                    ElevatedButton(
                      onPressed: () {
                        if (activityController.text.isNotEmpty) {
                          setState(() {
                            activities.add(activityController.text);
                            activityController.clear();
                          });
                        }
                      },
                      child: const Text("Add Activity"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                            dateController.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                          });
                        }
                      },
                      child: const Text("Pick a Date"),
                    ),
                    Text(
                      selectedDate == null
                          ? "No date selected"
                          : "Selected Date: ${dateController.text}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: addPlan,
                      child: const Text("Add Date"),
                    ),
                    ...plans.map((plan) => ListTile(
                          title: Text("📅 ${plan['date']} - 📍 ${plan['location']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (plan['activities'] as List<dynamic>).map<Widget>((activity) => Text("- $activity")).toList(),
                          ),
                        )),
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
                    if (selectedDestination != null && plans.isNotEmpty) {
                      _addItinerary(selectedDestination!, plans);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a destination and add at least one plan.')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Itinerary Management')),
      body: _itineraries.isEmpty
          ? const Center(child: Text("No itineraries yet. Add one!"))
          : ListView.builder(
              itemCount: _itineraries.length,
              itemBuilder: (context, index) {
                final itinerary = _itineraries[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text("Location: ${itinerary['location']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItinerary(index),
                    ),
                    children: (itinerary['plans'] as List<dynamic>).map<Widget>((plan) {
                      return ExpansionTile(
                        title: Text("📅 ${plan['date']} - 📍 ${plan['location']}"),
                        children: (plan['activities'] as List<dynamic>).map<Widget>((activity) => Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: ListTile(title: Text("- $activity"))),
                        ).toList(),
                      );
                    }).toList(),
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
