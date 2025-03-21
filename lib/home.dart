import 'package:flutter/material.dart';
import 'package:travel_planner/main.dart';
import 'package:travel_planner/itinerary.dart';
import 'package:travel_planner/accommodation.dart';
import 'package:travel_planner/flight.dart';
import 'package:travel_planner/mytrips.dart';
import 'package:travel_planner/notes.dart';
import 'package:travel_planner/account.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(), 
    MyTrips(),
    MyAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 77, 166, 116),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), 
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 77, 166, 116),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.location_city), label: "My Trips"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "My Account"),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 77, 166, 116),
              ),
              child: Icon(
                Icons.person, size: 100.0,
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Itinerary Management"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Itinerary()));
              },
            ),
            ListTile(
              leading: Icon(Icons.flight),
              title: Text("Flights"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Flight()));
              },
            ),
            ListTile(
              leading: Icon(Icons.hotel),
              title: Text("Accommodation"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Accommodation()));
              },
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text("Travel Notes"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Notes()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/WANDERWISE.png'), 
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.withOpacity(0.7), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "WanderWise",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your smart travel companion.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Itinerary()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Plan Your Trip",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
