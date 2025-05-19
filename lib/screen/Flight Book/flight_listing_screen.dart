import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iostest/providers/flight_List_provider.dart';
import 'package:iostest/models/flight_list_model.dart';

class FlightListingScreen extends StatefulWidget {

    final String from;
  final String to;
  final String departureDate;
  final int adultCount;
  final int childCount;
  final String tripType;

  const FlightListingScreen({
    super.key,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.adultCount,
    required this.childCount,
    required this.tripType,
    });

  @override
  State<FlightListingScreen> createState() => _FlightListingScreenState();
}

class _FlightListingScreenState extends State<FlightListingScreen> {
  @override
  void initState() {
    super.initState();
    // Example: fetch flights for demo values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FlightListProvider>(context, listen: false).fetchFlightData(
        adult: 1,
        child: 0,
        date: "2025-05-20",
        dest: "DEL",
        infant: 0,
        origin: "BOM",
        tripType: 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Listings'),
      ),
      body: Consumer<FlightListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }
          final flights = provider.flightList?.data.onw ?? [];
          if (flights.isEmpty) {
            return const Center(child: Text('No flights found.'));
          }
          return ListView.builder(
            itemCount: flights.length,
            itemBuilder: (context, index) {
              final flight = flights[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.flight_takeoff),
                  title: Text('${flight.flightname} (${flight.flghtcode})'),
                  subtitle: Text(
                    '${flight.from} → ${flight.to}\n'
                    'Departure: ${flight.depTime} | Arrival: ${flight.arrivalTime}\n'
                    'Duration: ${flight.duration} | Stops: ${flight.stops}',
                  ),
                  trailing: Text('₹${flight.price}'),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}