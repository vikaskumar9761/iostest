import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iostest/providers/hotel_city_provider.dart';
import 'package:iostest/screen/Hotel%20Screens/guest_room_selector.dart';
import 'package:iostest/screen/Hotel%20Screens/hotel_city_list.dart';
import 'package:iostest/screen/Hotel%20Screens/hotels_listing.dart';

class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({super.key});

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  // Default selections
  String destination = "TRIKOMO";
  String country = "CYPRUS";
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));
  int adults = 1, rooms = 1, children = 0;
  bool isLoading = true;
  List<Map<String, String>> recentSearches = [];

  // Text styles
  final labelStyle = const TextStyle(
    fontFamily: 'DancingScript',
    fontSize: 16,
    color: Colors.black87,
  );
  final titleStyle = const TextStyle(
    fontFamily: 'CabinSketch',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  final subStyle = const TextStyle(fontFamily: 'DancingScript', fontSize: 16);

  @override
  void initState() {
    super.initState();
    _loadCityData();
  }

  // Load city data from shared preferences or fetch via provider
  Future<void> _loadCityData() async {
    final provider = Provider.of<HotelCityProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('cityList') == null) {
      await provider.fetchAndSaveCities(); // API call if local data not found
    }
    await provider.loadCitiesFromPrefs(); // Load data locally
    setState(() => isLoading = false);
  }

  // Handle date picking
  Future<void> _pickDate({required bool isCheckIn}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkInDate : checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (!checkOutDate.isAfter(picked)) {
            checkOutDate = picked.add(const Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  // Show guest and room selection modal
  Future<void> _selectGuestRooms() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => GuestRoomSelector(
            adults: adults,
            rooms: rooms,
            children: children,
            onDone:
                (a, r, c) => setState(() {
                  adults = a;
                  rooms = r;
                  children = c;
                }),
          ),
    );
  }

  // Add selected city to recent searches
  void _addToRecentSearches(String city, String country) {
    setState(() {
      recentSearches.removeWhere(
        (e) => e['city'] == city && e['country'] == country,
      );
      recentSearches.insert(0, {'city': city, 'country': country});
      if (recentSearches.length > 5) {
        recentSearches = recentSearches.sublist(0, 5);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hotel Search",
          style: TextStyle(fontFamily: 'DancingScript'),
        ),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Same Hotel, Cheapest Price, Guaranteed!",
                style: subStyle,
              ),
            ),
            const SizedBox(height: 16),

            // Destination Selector
            GestureDetector(
              onTap: () async {
                final selected = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HotelCityScreen()),
                );
                if (selected is Map<String, String>) {
                  setState(() {
                    destination = selected['city'] ?? destination;
                    country = selected['country'] ?? country;
                  });
                }
              },
              child: _buildCard(
                title: "Destination/Hotel",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(destination, style: titleStyle),
                    Text(country, style: subStyle),
                  ],
                ),
              ),
            ),

            // Check-in / Check-out Dates
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(isCheckIn: true),
                    child: _buildCard(
                      title: "Check-In",
                      child: _buildDateText(checkInDate),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(isCheckIn: false),
                    child: _buildCard(
                      title: "Check-Out",
                      child: _buildDateText(checkOutDate),
                    ),
                  ),
                ),
              ],
            ),

            // Guests & Rooms
            GestureDetector(
              onTap: _selectGuestRooms,
              child: _buildCard(
                title: "Guest & Rooms",
                child: Text(
                  "$adults Adults, $rooms Room${children > 0 ? ', $children Children' : ''}",
                  style: titleStyle,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  _addToRecentSearches(destination, country);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => HotelsListingScreen(
                            city: destination,
                            checkInDate: DateFormat(
                              'yyyy-MM-dd',
                            ).format(checkInDate),
                            checkOutDate: DateFormat(
                              'yyyy-MM-dd',
                            ).format(checkOutDate),
                            adults: adults,
                            rooms: rooms,
                            children: children,
                          ),
                    ),
                  );
                },
                child: const Text(
                  "SEARCH HOTELS",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'DancingScript',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Recent Searches
            if (recentSearches.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.people),
                  const SizedBox(width: 5),
                  Text("Recently Searched", style: subStyle),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentSearches.length,
                itemBuilder: (_, i) {
                  final item = recentSearches[i];
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(item['city'] ?? ''),
                    subtitle: Text(item['country'] ?? ''),
                    onTap:
                        () => setState(() {
                          destination = item['city']!;
                          country = item['country']!;
                        }),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper widget for reusable card layout
  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      child: ListTile(title: Text(title, style: labelStyle), subtitle: child),
    );
  }

  // Helper widget for date display
  Widget _buildDateText(DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(DateFormat('yyyy-M-d').format(date), style: titleStyle),
        Text(DateFormat('MMM dd, EEE').format(date), style: subStyle),
      ],
    );
  }
}
