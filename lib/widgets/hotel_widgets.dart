import 'package:flutter/material.dart';
import 'package:iostest/models/hotels_list_model.dart';

class TopFilterButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onPressed;

  const TopFilterButton({
    super.key,
    this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        icon: icon != null
            ? Icon(icon, color: Colors.black)
            : const SizedBox.shrink(),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'CabinSketch',
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.black12),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed ?? () {},
      ),
    );
  }
}


//// Widget to display hotel card
class HotelCard extends StatelessWidget {
  final HotelItem hotel;
  final VoidCallback? onTap; // <-- New parameter added

  const HotelCard({super.key, required this.hotel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18), // ripple inside card
      onTap: onTap, // <-- This will trigger when card is tapped
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: hotel.imageThumbUrl?.isNotEmpty == true
                  ? Image.network(
                      hotel.imageThumbUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.hotel, size: 60)),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.hotelName ?? "",
                    style: const TextStyle(
                      fontFamily: 'CabinSketch',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    hotel.location ?? "",
                    style: const TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  if (hotel.address != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        hotel.address!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'DancingScript',
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (hotel.rating != null)
                        Row(
                          children: [
                            Text(
                              hotel.rating!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.star, color: Colors.orange, size: 20),
                          ],
                        ),
                      const SizedBox(width: 12),
                      if (hotel.tripAdvisorReviewCount > 0)
                        Text(
                          "Good ${hotel.tripAdvisorReviewCount} reviews",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'DancingScript',
                          ),
                        ),
                      const SizedBox(width: 12),
                      if (hotel.isBreakFast)
                        const Text(
                          "Free wifi",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontFamily: 'DancingScript',
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${hotel.price}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CabinSketch',
                        ),
                      ),
                      const Text(
                        "+₹701 Taxes & fees",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'DancingScript',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
