// import 'package:flutter/material.dart';
// import 'package:iostest/models/config_model.dart';
// import 'package:iostest/models/operator_model.dart';
// import 'package:iostest/screen/RechargeScreen/SelectCircleScreen.dart';
// import 'package:iostest/screen/connection/ConnectionScreen.dart';
// import 'package:iostest/utils/config_util.dart';
//
// class OperatorSelectionScreen extends StatefulWidget {
//   final List<BillerRoot> billerRoot; // BillerRoot list from API/config
//   final String categoryId; // Selected category like "mobile", "dth", etc.
//   final String phoneNumber; // Phone number entered by user
//
//   const OperatorSelectionScreen({
//     super.key,
//     required this.categoryId,
//     required this.billerRoot,
//     required this.phoneNumber,
//   });
//
//   @override
//   _OperatorSelectionScreenState createState() => _OperatorSelectionScreenState();
// }
//
// class _OperatorSelectionScreenState extends State<OperatorSelectionScreen> {
//   final OperatorModel _selectedOperator = OperatorModel(); // Stores selected operator data
//   bool _isLoading = false; // Loading state indicator
//   ConfigModel? configModel; // Not used in current code
//
//   final TextEditingController _searchController = TextEditingController(); // Controller for search input
//   List<Operator> _filteredOperators = []; // Filtered operators based on search
//   List<Operator> _allOperators = []; // All operators list
//
//   // Loads all operators from billerRoot
//   Future<void> _loadOperators() async {
//     print(widget.billerRoot.length);
//     try {
//       setState(() {
//         _isLoading = true;
//       });
//
//       List<Operator> operators = [];
//
//       // Convert BillerRoot to Operator list
//       for (var billerRoot in widget.billerRoot) {
//         for (var biller in billerRoot.billers) {
//           print(biller.op.toString());
//           operators.add(Operator(
//             id: biller.op.toString(),
//             name: billerRoot.name,
//             description: billerRoot.name,
//             logoUrl: 'assets/images/bharat-connect.png', // Default logo
//             biller: biller,
//           ));
//         }
//       }
//
//       setState(() {
//         _allOperators = operators;
//         _filteredOperators = operators;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//
//       // Show error snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading operators: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadOperators(); // Load operators on screen start
//   }
//
//   // Filters the operator list based on search query
//   void _filterOperators(String query) {
//     print(query);
//     setState(() {
//       if (query.isEmpty) {
//         _filteredOperators = _allOperators;
//       } else {
//         _filteredOperators = _allOperators
//             .where((operator) =>
//                 operator.name.toLowerCase().contains(query.toLowerCase()) ||
//                 operator.description.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose(); // Dispose search controller
//     super.dispose();
//   }
//
//   // Handles operator selection
//   void _selectOperator(Operator operator) {
//     setState(() {
//       _isLoading = true;
//     });
//
//     Future.delayed(const Duration(seconds: 1), () async {
//       _selectedOperator.operatorId = operator.id;
//       _selectedOperator.operatorName = operator.name;
//
//       // Get list of all circles
//       List<Circle> allCircles = await ConfigUtil.getCircles();
//       List<Circle> matchedCircles = [];
//
//       print("selected operator type: ${operator.biller.type}");
//       print("selected operator circle: ${operator.biller.circles}");
//       print("Selected Operator Phone: ${widget.phoneNumber}");
//       print("Selected Operator Category Id: ${widget.categoryId}");
//       print("Selected Operator Name: ${operator.name}");
//       print("Selected Operator Id (op): ${operator.id}");
//
//       // Match circle ids to full circle info
//       for (var circleId in operator.biller.circles) {
//         final matchingCircle = allCircles.firstWhere(
//           (circle) => circle.circleId == circleId.toString(),
//           orElse: () => Circle(circleId: "0", name: "Unknown Circle"),
//         );
//
//         if (matchingCircle != null && matchingCircle.circleId != "0") {
//           print("Circle ID: ${matchingCircle.circleId}, Circle Name: ${matchingCircle.name}");
//           matchedCircles.add(matchingCircle);
//         }
//       }
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Selected operator: ${operator.name}'),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//
//       // Navigation logic based on category
//       if (widget.categoryId.toLowerCase() == "mobile" || widget.categoryId.toLowerCase() == "dth") {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => SelectCircleScreen(
//               operatorName: operator.name,
//               operatorId: operator.id,
//               category: widget.categoryId,
//               billerObject: operator.biller.toMap(),
//               circles: matchedCircles,
//               operatorType: operator.biller.type,
//               number: widget.phoneNumber,
//             ),
//           ),
//         );
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ConnectionScreen(
//               operatorName: operator.name,
//               operatorId: operator.id,
//               category: widget.categoryId,
//               selectedCircleName: '',
//               billerObject: operator.biller.toMap(),
//               number: widget.phoneNumber,
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context), // Back button
//         ),
//         title: const Text(
//           'Select Operator',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: Image.asset(
//               'assets/images/bharat_connect.png', // Top right logo
//               height: 45,
//               width: 45,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search box
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: _filterOperators,
//                 decoration: const InputDecoration(
//                   hintText: 'Search operators...',
//                   prefixIcon: Icon(Icons.search, color: Colors.grey),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.0,
//                     vertical: 12.0,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Operator list
//           Expanded(
//             child: _isLoading
//                 ? const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(), // Loading spinner
//                         SizedBox(height: 16),
//                         Text('Loading Operators...'),
//                       ],
//                     ),
//                   )
//                 : _filteredOperators.isEmpty
//                     ? const Center(
//                         child: Text('No operators found'), // No result text
//                       )
//                     : ListView.builder(
//                         itemCount: _filteredOperators.length,
//                         itemBuilder: (context, index) {
//                           final operator = _filteredOperators[index];
//                           return OperatorListItem(
//                             operator: operator,
//                             onTap: () => _selectOperator(operator),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // UI widget to show operator list item
// class OperatorListItem extends StatelessWidget {
//   final Operator operator;
//   final VoidCallback onTap;
//
//   const OperatorListItem({
//     super.key,
//     required this.operator,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap, // Tap to select operator
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         child: Row(
//           children: [
//             // Operator Logo
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: Image.asset(
//                   operator.logoUrl,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     color: Colors.grey[300],
//                     child: Icon(
//                       Icons.electric_bolt,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             // Operator name and description
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     operator.name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     operator.description,
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 14,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//


// lib/screen/RechargeScreen/operator_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:iostest/models/config_model.dart';
import 'package:iostest/screen/RechargeScreen/SelectCircleScreen.dart';
import 'package:iostest/screen/connection/ConnectionScreen.dart';
import 'package:iostest/screen/operator/OperatorController.dart';
import 'package:iostest/screen/operator/OperatorListItem.dart';
import 'package:provider/provider.dart';


class OperatorSelectionScreen extends StatelessWidget {
  final List<BillerRoot> billerRoot;
  final String categoryId;
  final String phoneNumber;

  const OperatorSelectionScreen({
    super.key,
    required this.billerRoot,
    required this.categoryId,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OperatorController(
        billerRoot: billerRoot,
        categoryId: categoryId,
        phoneNumber: phoneNumber,
      )..loadOperators(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Select Operator',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset('assets/images/bharat_connect.png', height: 45, width: 45),
            ),
          ],
        ),
        body: Consumer<OperatorController>(
          
          builder: (context, controller, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      onChanged: controller.filterOperators,
                      decoration: const InputDecoration(
                        hintText: 'Search operators...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.filteredOperators.isEmpty
                          ? const Center(child: Text('No operators found'))
                          : ListView.builder(
                              itemCount: controller.filteredOperators.length,
                              itemBuilder: (context, index) {
                                final operator = controller.filteredOperators[index];
                                return OperatorListItem(
                                  operator: operator,
                                  onTap: () async {
                                    controller.selectedOperator.operatorId = operator.id;
                                    controller.selectedOperator.operatorName = operator.name;

                                    List<Circle> circles = await controller.getCirclesForOperator(operator);

                                    if (categoryId.toLowerCase() == "mobile" || categoryId.toLowerCase() == "dth") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SelectCircleScreen(
                                            operatorName: operator.name,
                                            operatorId: operator.id,
                                            category: categoryId,
                                            billerObject: operator.biller.toMap(),
                                            circles: circles,
                                            operatorType: operator.biller.type,
                                            number: phoneNumber,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ConnectionScreen(
                                            operatorName: operator.name,
                                            operatorId: operator.id,
                                            category: categoryId,
                                            selectedCircleName: '',
                                            selectedCircleId: '',
                                            billerObject: operator.biller.toMap(),
                                            number: phoneNumber,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

