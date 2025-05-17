import 'package:flutter/material.dart';

// City model
class City {
  final String code;
  final String name;
  final String country;
  City(this.code, this.name, this.country);
}

// Cities list
final List<City> cities = [
  City("DEL", "New Delhi", "IN"),
  City("BOM", "Mumbai", "IN"),
  City("BLR", "Bangalore", "IN"),
  City("MAA", "Chennai", "IN"),
  City("CCU", "Kolkata", "IN"),
  City("HYD", "Hyderabad", "IN"),
  City("DXB", "Dubai", "AE"),
  City("SIN", "Singapore", "SG"),
  City("BKK", "Bangkok", "TH"),
  City("LHR", "London", "GB"),
  City("JFK", "New York", "US"),
  City("SFO", "San Francisco", "US"),
];

class DepartureListScreen extends StatelessWidget {
  final String title;
  const DepartureListScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return ListTile(
            leading: CircleAvatar(child: Text(city.code)),
            title: Text(city.name),
            subtitle: Text(city.country),
            onTap: () {
              Navigator.pop(context, city);
            },
          );
        },
      ),
    );
  }
}
