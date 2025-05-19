import 'package:flutter/material.dart';
import 'package:iostest/screen/Flight%20Book/flight_City_list.dart';
import 'package:iostest/screen/Flight%20Book/flight_listing_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlightBookingScreen extends StatefulWidget {
  const FlightBookingScreen({super.key});

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen> {
  String _tripType = "One Way";
  String _from = "From";
  String _to = "To";
  String _departureDate = "Select Date";

  int _adultCount = 1;
  int _childCount = 0;
  String _selectedClass = "Economy";

  bool _directFlightsOnly = false;
  bool _refundableFlights = false;

  String get _travelerClass =>
      "$_adultCount Adult${_adultCount > 1 ? 's' : ''}"
      "${_childCount > 0 ? ', $_childCount Child${_childCount > 1 ? 'ren' : ''}' : ''}"
      " - $_selectedClass";

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tripType = prefs.getString('tripType') ?? "One Way";
      _from = prefs.getString('from') ?? "Select Departure";
      _to = prefs.getString('to') ?? "Select Destination";
      _departureDate = prefs.getString('departureDate') ?? "Select Date";
      _adultCount = prefs.getInt('adultCount') ?? 1;
      _childCount = prefs.getInt('childCount') ?? 0;
      _selectedClass = prefs.getString('selectedClass') ?? "Economy";
      _directFlightsOnly = prefs.getBool('directFlightsOnly') ?? false;
      _refundableFlights = prefs.getBool('refundableFlights') ?? false;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tripType', _tripType);
    await prefs.setString('from', _from);
    await prefs.setString('to', _to);
    await prefs.setString('departureDate', _departureDate);
    await prefs.setInt('adultCount', _adultCount);
    await prefs.setInt('childCount', _childCount);
    await prefs.setString('selectedClass', _selectedClass);
    await prefs.setBool('directFlightsOnly', _directFlightsOnly);
    await prefs.setBool('refundableFlights', _refundableFlights);
  }

  String getTravelerSummary() {
    String travelerText = '$_adultCount Adult';
    if (_childCount > 0) {
      travelerText += ', $_childCount Child';
    }
    return "$travelerText, $_selectedClass";
  }

  void _showTravelerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Travelers & Class",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCounterRow("Adults", _adultCount, (val) {
                    setModalState(() {
                      _adultCount = val < 1 ? 1 : val;
                    });
                    setState(() {}); // update parent display as well
                  }),
                  _buildCounterRow("Children", _childCount, (val) {
                    setModalState(() {
                      _childCount = val < 0 ? 0 : val;
                    });
                    setState(() {});
                  }),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text("Class:", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedClass,
                        items: const [
                          DropdownMenuItem(
                            value: "Economy",
                            child: Text("Economy"),
                          ),
                          DropdownMenuItem(
                            value: "Business",
                            child: Text("Business"),
                          ),
                        ],
                        onChanged: (value) {
                          setModalState(() {
                            _selectedClass = value!;
                          });
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterRow(String title, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => onChanged(value - 1),
            ),
            Text('$value', style: const TextStyle(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Flights"), centerTitle: true),
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
            const Divider(),

            // From
            ListTile(
              leading: const Icon(Icons.flight_takeoff),
              title: Text(_from),
              onTap: () async {
                final selected = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const DepartureListScreen(
                          title: "From (Select Departure)",
                        ),
                  ),
                );
                if (selected != null && selected is City) {
                  setState(() {
                    _from =
                        "${selected.name} (${selected.code}) ${selected.country}";
                  });
                }
              },
            ),
            const Divider(),

            // To
            ListTile(
              leading: const Icon(Icons.flight_land),
              title: Text(_to),
              onTap: () async {
                final selected = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const DepartureListScreen(
                          title: "To (Select Destination )",
                        ),
                  ),
                );
                if (selected != null && selected is City) {
                  setState(() {
                    _to =
                        "${selected.name} (${selected.code}) ${selected.country}";
                  });
                }
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

            // Traveler & Class
            // Traveler & Class
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(getTravelerSummary()),
              onTap: _showTravelerBottomSheet,
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

            // Search Button
            Center(
              child: ElevatedButton(
                // ...existing code...
                onPressed: () async {
                  await _saveData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => FlightListingScreen(
                            from: _from,
                            to: _to,
                            departureDate: _departureDate,
                            adultCount: _adultCount,
                            childCount: _childCount,
                            tripType: _tripType,
                          ),
                    ),
                  );
                },
                // ...existing code...
                child: const Text("SEARCH FLIGHTS"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
