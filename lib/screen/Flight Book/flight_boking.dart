import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlightBookingScreen extends StatefulWidget {
  const FlightBookingScreen({super.key});

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen> {
  String _tripType = "One Way"; // Default trip type
  String _from = "From"; // Default departure
  String _to = "To"; // Default destination
  String _departureDate = "Select Date"; // Default date
  String _travelerClass = "1 Adult"; // Default traveler and class
  bool _directFlightsOnly = false; // Default checkbox value
  bool _refundableFlights = false; // Default checkbox value

  final List<String> _departureList = [
    "New York",
    "Los Angeles",
    "Chicago",
    "Houston",
    "San Francisco"
  ]; // Dummy list for departure

  final List<String> _destinationList = [
    "Miami",
    "Seattle",
    "Boston",
    "Dallas",
    "Atlanta"
  ]; // Dummy list for destination

  final List<String> _travelerClassList = [
    "1 Adult",
    "2 Adults",
    "1 Adult, 1 Child",
    "Business Class"
  ]; // Dummy list for travelers & class

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Load saved data from SharedPreferences
  }

  /// Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tripType = prefs.getString('tripType') ?? "One Way";
      _from = prefs.getString('from') ?? "Select Departure";
      _to = prefs.getString('to') ?? "Select Destination";
      _departureDate = prefs.getString('departureDate') ?? "Select Date";
      _travelerClass = prefs.getString('travelerClass') ?? "1 Adult";
      _directFlightsOnly = prefs.getBool('directFlightsOnly') ?? false;
      _refundableFlights = prefs.getBool('refundableFlights') ?? false;
    });
  }

  /// Save data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tripType', _tripType);
    await prefs.setString('from', _from);
    await prefs.setString('to', _to);
    await prefs.setString('departureDate', _departureDate);
    await prefs.setString('travelerClass', _travelerClass);
    await prefs.setBool('directFlightsOnly', _directFlightsOnly);
    await prefs.setBool('refundableFlights', _refundableFlights);
  }

  /// Show a dropdown for selection
  Future<void> _showDropdownDialog(
      String title, List<String> options, Function(String) onSelected) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Set a fixed width
            height: 200, // Set a fixed height
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(options[index]),
                  onTap: () {
                    onSelected(options[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Flights"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Type Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("One Way"),
                  selected: _tripType == "One Way",
                  onSelected: (selected) {
                    setState(() {
                      _tripType = "One Way";
                    });
                  },
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text("Round Trip"),
                  selected: _tripType == "Round Trip",
                  onSelected: (selected) {
                    setState(() {
                      _tripType = "Round Trip";
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // From Dropdown
            ListTile(
              leading: const Icon(Icons.flight_takeoff),
              title: Text(_from),
              onTap: () {
                _showDropdownDialog(
                  "From",
                  _departureList,
                  (value) {
                    setState(() {
                      _from = value;
                    });
                  },
                );
              },
            ),
            const Divider(),

            // To Dropdown
            ListTile(
              leading: const Icon(Icons.flight_land),
              title: Text(_to),
              onTap: () {
                _showDropdownDialog(
                  "To",
                  _destinationList,
                  (value) {
                    setState(() {
                      _to = value;
                    });
                  },
                );
              },
            ),
            const Divider(),

            // Departure Date
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(_departureDate),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (selectedDate != null) {
                  setState(() {
                    _departureDate =
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                  });
                }
              },
            ),
            const Divider(),

            // Travelers and Class
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(_travelerClass),
              onTap: () {
                _showDropdownDialog(
                  "Select Travelers & Class",
                  _travelerClassList,
                  (value) {
                    setState(() {
                      _travelerClass = value;
                    });
                  },
                );
              },
            ),
            const Divider(),

            // Checkboxes
            Row(
              children: [
                Checkbox(
                  value: _directFlightsOnly,
                  onChanged: (value) {
                    setState(() {
                      _directFlightsOnly = value!;
                    });
                  },
                ),
                const Text("Direct Flights Only"),
                const SizedBox(width: 16),
                Checkbox(
                  value: _refundableFlights,
                  onChanged: (value) {
                    setState(() {
                      _refundableFlights = value!;
                    });
                  },
                ),
                const Text("Refundable Flights"),
              ],
            ),
            const SizedBox(height: 16),

            // Search Flights Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveData(); // Save data to SharedPreferences
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Flight details saved!")),
                  );
                },
                child: const Text("SEARCH FLIGHTS"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}