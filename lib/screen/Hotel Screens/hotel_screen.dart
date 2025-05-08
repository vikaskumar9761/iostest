import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({super.key});

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  String selectedDestination = "TRIKOMO";
  String selectedCountry = "CYPRUS";
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int adults = 0;
  int rooms = 0;

  final List<Map<String, String>> destinationList = [
    {"destination": "TRIKOMO", "country": "CYPRUS"},
    {"destination": "LONDON", "country": "UNITED KINGDOM"},
    {"destination": "PARIS", "country": "FRANCE"},
    {"destination": "DUBAI", "country": "UNITED ARAB EMIRATES"},
    {"destination": "NEW YORK", "country": "UNITED STATES"},
    {"destination": "TOKYO", "country": "JAPAN"},
    {"destination": "ISTANBUL", "country": "TURKEY"},
    {"destination": "BANGKOK", "country": "THAILAND"},
    {"destination": "ROME", "country": "ITALY"},
    {"destination": "BARCELONA", "country": "SPAIN"},
    {"destination": "MUMBAI", "country": "INDIA"},
    {"destination": "SINGAPORE", "country": "SINGAPORE"},
    {"destination": "KUALA LUMPUR", "country": "MALAYSIA"},
    {"destination": "CAPE TOWN", "country": "SOUTH AFRICA"},
    {"destination": "SYDNEY", "country": "AUSTRALIA"},
    {"destination": "TORONTO", "country": "CANADA"},
    {"destination": "AMSTERDAM", "country": "NETHERLANDS"},
    {"destination": "BERLIN", "country": "GERMANY"},
    {"destination": "MOSCOW", "country": "RUSSIA"},
    {"destination": "SEOUL", "country": "SOUTH KOREA"},
  ];

  Future<void> _selectDate(bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  void _selectDestinationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Destination"),
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: ListView.builder(
              itemCount: destinationList.length,
              itemBuilder: (context, index) {
                final item = destinationList[index];
                return ListTile(
                  title: Text(item["destination"]!),
                  subtitle: Text(item["country"]!),
                  onTap: () {
                    setState(() {
                      selectedDestination = item["destination"]!;
                      selectedCountry = item["country"]!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _selectGuestsDialog() {
    int tempAdults = adults;
    int tempRooms = rooms;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Guests & Rooms"),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(child: Text("Adults")),
                    IconButton(
                      onPressed: () {
                        if (tempAdults > 0) {
                          setStateDialog(() => tempAdults--);
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$tempAdults'),
                    IconButton(
                      onPressed: () => setStateDialog(() => tempAdults++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(child: Text("Rooms")),
                    IconButton(
                      onPressed: () {
                        if (tempRooms > 0) {
                          setStateDialog(() => tempRooms--);
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$tempRooms'),
                    IconButton(
                      onPressed: () => setStateDialog(() => tempRooms++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                adults = tempAdults;
                rooms = tempRooms;
              });
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Select Date";
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Hotel Search",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Center(
              child: Text(
                "Same Hotel, Cheapest Price, Guaranteed!",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 16),

            // Destination Card
            GestureDetector(
              onTap: _selectDestinationDialog,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Destination/Hotel", style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 8),
                      Text(selectedDestination, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(selectedCountry, style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Check-In / Check-Out
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(true),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Check-In", style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 8),
                            Text(
                              _formatDate(checkInDate),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(false),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Check-Out", style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 8),
                            Text(
                              _formatDate(checkOutDate),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Guests & Rooms
            GestureDetector(
              onTap: _selectGuestsDialog,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Guests & Rooms", style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 8),
                      Text("$adults Adults, $rooms Room(s)", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle search
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("SEARCH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
