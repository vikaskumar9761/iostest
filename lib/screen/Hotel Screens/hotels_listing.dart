import 'package:flutter/material.dart';
import 'package:iostest/screen/Hotel%20Screens/hotel_details_screen.dart';
import 'package:iostest/widgets/hotel_widgets.dart';
import 'package:provider/provider.dart';
import 'package:iostest/providers/hotels_list_provider.dart';
import 'package:iostest/models/hotels_list_model.dart';

class HotelsListingScreen extends StatefulWidget {
  final String city, checkInDate, checkOutDate;
  final int adults, rooms, children;

  const HotelsListingScreen({
    super.key,
    required this.city,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.rooms,
    required this.children,
  });

  @override
  State<HotelsListingScreen> createState() => _HotelsListingScreenState();
}

class _HotelsListingScreenState extends State<HotelsListingScreen> {
  bool isLoading = true;
  

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    final provider = Provider.of<HotelsListProvider>(context, listen: false);
    await provider.fetchHotelsList(widget.city);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final hotelsList = context.watch<HotelsListProvider>().hotelsListResponse;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hotelsList == null
              ? const Center(child: Text("No data found"))
              : _buildHotelListUI(hotelsList),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      centerTitle: true,
      title: Text(
        widget.city.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'CabinSketch',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHotelListUI(HotelsListResponse hotelsList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            "${widget.checkInDate} | ${widget.adults} Adults | ${widget.rooms} Room | ${widget.children} Children",
            style: const TextStyle(fontSize: 15, fontFamily: 'DancingScript'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              TopFilterButton(icon: Icons.filter_list, label: "FILTERS",
              ),
              const SizedBox(width: 8),
              const TopFilterButton(label: "SORT BY"),
              const SizedBox(width: 8),
              const TopFilterButton(label: "PRICE"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "${hotelsList.hotellist.length} Properties Available",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'CabinSketch',
            ),
          ),
        ),
        const SizedBox(height: 8),
 Expanded(
  child: ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: hotelsList.hotellist.length,
    itemBuilder: (_, index) => HotelCard(
      hotel: hotelsList.hotellist[index],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HotelDetailScreen(
              hotel: hotelsList.hotellist[index],
            ),
          ),
        );
      },
    ),
  ),
),

      ],
    );
  }
}
