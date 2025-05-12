import 'package:flutter/material.dart';
import 'package:iostest/models/hotels_list_model.dart';

class HotelDetailScreen extends StatefulWidget {
  final HotelItem hotel;
  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  int selectedTab = 1;

  // ... (imports & HotelDetailScreen class start remain same)

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scale = screenWidth / 375;

    final checkInDate = "2025-5-12";
    final checkOutDate = "2025-5-12";
    final adults = 1;
    final rooms = 1;
    final children = 0;

    final reviewText =
        hotel.tripAdvisorReviewCount > 0
            ? "Good ${hotel.tripAdvisorReviewCount} reviews"
            : "No reviews";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Hotel Search",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'DancingScript',
            fontWeight: FontWeight.bold,
            fontSize: 22 * scale,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Hotel Image
              if (hotel.imageThumbUrl != null &&
                  hotel.imageThumbUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Image.network(
                    hotel.imageThumbUrl!,
                    height: screenHeight * 0.35,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              // Card with All Details
              Positioned(
                top: screenHeight * 0.28,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          hotel.hotelName ?? "",
                          style: TextStyle(
                            fontFamily: 'CabinSketch',
                            fontSize: 28 * scale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hotel.location ?? "",
                                style: TextStyle(
                                  fontFamily: 'DancingScript',
                                  fontSize: 16 * scale,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    hotel.tripAdvisorRating.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16 * scale,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reviewText,
                          style: TextStyle(
                            fontFamily: 'DancingScript',
                            fontSize: 14 * scale,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _infoTile(
                          context,
                          icon: Icons.apartment,
                          label: hotel.address ?? "",
                          fontSize: 18 * scale,
                        ),
                        const SizedBox(height: 12),
                        _infoTile(
                          context,
                          icon: Icons.calendar_month,
                          label:
                              "Check In Date : $checkInDate\nCheck Out Date : $checkOutDate",
                          title: "Dates",
                          fontSize: 15 * scale,
                        ),
                        const SizedBox(height: 12),
                        _infoTile(
                          context,
                          icon: Icons.people,
                          label:
                              "$adults Adults, $rooms Rooms, $children Children",
                          title: "Guests & Rooms",
                          fontSize: 15 * scale,
                        ),
                        const SizedBox(height: 16),

                        // Tabs
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _tabButton("ROOM", selectedTab == 0, scale, () {
                              setState(() => selectedTab = 0);
                            }),
                            _tabButton("OVERVIEW", selectedTab == 1, scale, () {
                              setState(() => selectedTab = 1);
                            }),
                            _tabButton("DETAILS", selectedTab == 2, scale, () {
                              setState(() => selectedTab = 2);
                            }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildTabContent(selectedTab, scale),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 300), // So it doesn't overflow
        ],
      ),
    );
  }

  Widget _tabButton(
    String label,
    bool selected,
    double scale,
    VoidCallback onTap,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        constraints: const BoxConstraints(minWidth: 80),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: selected ? Colors.blue[300] : Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
          onPressed: onTap,
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              fontFamily: 'DancingScript',
              fontSize: 14 * scale,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? title,
    double fontSize = 16,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'DancingScript',
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(int index, double scale) {
    switch (index) {
      case 0:
        return Text(
          "Available room types, prices, amenities, etc.",
          style: TextStyle(fontFamily: 'DancingScript', fontSize: 16 * scale),
        );
      case 1:
        return Text(
          "Hotel overview including description, facilities, and highlights.",
          style: TextStyle(fontFamily: 'DancingScript', fontSize: 16 * scale),
        );
      case 2:
        return Text(
          "More details such as policies, timings, contact info, etc.",
          style: TextStyle(fontFamily: 'DancingScript', fontSize: 16 * scale),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
