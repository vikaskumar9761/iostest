import 'package:flutter/material.dart';
import 'package:iostest/models/config_model.dart';
import 'package:iostest/screen/connection/SelectPlansScreen.dart';

import '../connection/ConnectionScreen.dart';


class SelectCircleScreen extends StatefulWidget {
  final String operatorType;
  final String operatorName;
  final String operatorId;
  final String category;
  final String number;
  final Map<String, dynamic> billerObject;
  final List<Circle> circles;

  const SelectCircleScreen({
    super.key,
    required this.operatorName,
    required this.operatorId,
    required this.category,
    required this.operatorType,
    required this.number,
    required this.billerObject,
    required this.circles,
  });

  @override
  _SelectCircleScreenState createState() => _SelectCircleScreenState();
}

class _SelectCircleScreenState extends State<SelectCircleScreen> {
  List<Circle> filteredCircles = [];
  Circle? selectedCircle;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the filteredCircles with the passed circles
    filteredCircles = List.from(widget.circles);
  }

  void filterSearch(String query) {
    List<Circle> dummyList = [];
    dummyList.addAll(widget.circles);
    if (query.isNotEmpty) {
      dummyList =
          dummyList
              .where(
                (item) => item.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    setState(() {
      filteredCircles = dummyList;
    });
  }

  void onItemClicked(Circle circle) {
    setState(() {
      selectedCircle = circle;
    });

    if (widget.operatorType.toLowerCase() == "prepaid") {
      // Navigate to SelectPlansScreen for Prepaid
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
              //               //Selectplansscreen()
              //           SelectPlansScreen(
              //   operatorId: "1", // Replace with actual operator ID
              //   circleId: "1",   // Replace with actual circle ID
              // ),
              SelectPlansScreen(
                operatorType: widget.operatorType,
                selectedCircleName: circle.name,
                selectedCircleId: circle.circleId,
                number: widget.number,
                operatorName: widget.operatorName,
                operatorId: widget.operatorId,
                category: widget.category,
                billerObject: widget.billerObject,
              ),
        ),
      );
    } else {
      // Navigate to ConnectionScreen (Postpaid case)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ConnectionScreen(
                operatorName: widget.operatorName,
                operatorId: widget.operatorId,
                category: widget.category,
                selectedCircleName: circle.name,
                billerObject: widget.billerObject,
                number: widget.number,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, //e1e8f0
        title: const Text(
          'Select Circle',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Optional: bold title
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/images/bharat_connect.png', // ✅ Path to your image
              height: 45,
              width: 45,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child:
          //   TextField(
          //     controller: searchController,
          //     onChanged: (value) {
          //       filterSearch(value);
          //     },
          //     decoration: InputDecoration(
          //       hintText: 'Search Circles',
          //       prefixIcon: Icon(Icons.search),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                filterSearch(value);
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'see all',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                prefixIcon: Icon(Icons.search_outlined, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredCircles.length,
              itemBuilder: (context, index) {
                final circle = filteredCircles[index];
                final isSelected = selectedCircle == circle;

                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.check, // You can change icon if needed
                      color: Colors.green, // Change color as per your design
                      size: 20,
                    ),
                  ),
                  title: Text(
                    circle.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, // 👈 Bold font style
                    ),
                  ), //subtitle: Text('Circle ID: ${circle.circleId}'),
                  trailing:
                      isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const SizedBox(width: 24),
                  onTap: () {
                    onItemClicked(circle);
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

// NEXT SCREEN BANAI
