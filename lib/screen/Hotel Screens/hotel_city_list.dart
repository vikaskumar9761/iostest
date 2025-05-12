import 'package:flutter/material.dart';
import 'package:iostest/providers/hotel_city_provider.dart';
import 'package:iostest/models/hotel_city_model.dart';
import 'package:provider/provider.dart';

class HotelCityScreen extends StatefulWidget {
  const HotelCityScreen({super.key});

  @override
  State<HotelCityScreen> createState() => _HotelCityScreenState();
}

class _HotelCityScreenState extends State<HotelCityScreen> {
  List<Map<String, String>> destinations = [];
  List<Map<String, String>> filteredDestinations = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCities();
    _searchController.addListener(_filterDestinations);
  }

  Future<void> _loadCities() async {
    final provider = Provider.of<HotelCityProvider>(context, listen: false);
    final List<CityInfo> cityList = await provider.loadCitiesFromPrefs();
    setState(() {
      destinations = cityList
          .map((city) => {
                'city': city.city,
                'country': city.countryName,
              })
          .toList();
      filteredDestinations = destinations;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDestinations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredDestinations = destinations.where((destination) {
        final city = destination['city']!.toLowerCase();
        final country = destination['country']!.toLowerCase();
        return city.contains(query) || country.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter City/Location/Hotel Name"),
        backgroundColor: Colors.blue,
        leading: const BackButton(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search by city or country",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),

                // Recent Search Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent Search",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            filteredDestinations = [];
                            _searchController.clear();
                          });
                        },
                        child: const Text(
                          "Clear",
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),

                // List of Destinations
                Expanded(
                  child: filteredDestinations.isEmpty
                      ? const Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredDestinations.length,
                          itemBuilder: (context, index) {
                            final item = filteredDestinations[index];
                            return ListTile(
                              leading: const Icon(Icons.compare_arrows, color: Colors.black),
                              title: Text(
                                item['city']!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                item['country']!,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              onTap: () {
                                Navigator.pop(context, item); // Return selected city
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}