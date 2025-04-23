// import 'package:flutter/material.dart';
// import 'package:iostest/config/secure_storage_service.dart';
// import 'HeaderComponent.dart';
// import 'ServicesComponent.dart';
// import 'HistoryComponent.dart';
// import 'NavbarComponent.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   Future<List<ServiceItem>> fetchServices() async {
//              var configData= await SecureStorageService.getConfig();
// print(configData);
//     // Simulate a network call
//     await Future.delayed(Duration(seconds: 2));
//     return [
//       ServiceItem(
//           icon:
//               'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25.png',
//           label: 'Pulse'),
//       ServiceItem(
//           icon:
//               'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-2.png',
//           label: 'Internet'),
//       ServiceItem(
//           icon:
//               'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-3.png',
//           label: 'Call Package'),
//       ServiceItem(
//           icon:
//               'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-4.png',
//           label: 'Water'),
//     ];
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           width: double.infinity,
//           constraints:
//               BoxConstraints(minHeight: MediaQuery.of(context).size.height),
//           // decoration: BoxDecoration(
//           //   image: DecorationImage(
//           //     image: NetworkImage('https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/bg.png'),
//           //     fit: BoxFit.cover,
//           //   ),
//           // ),
//           child: Column(
//             children: [
//               HeaderComponent(),
//               if (_selectedIndex == 0)
//                 FutureBuilder<List<ServiceItem>>(
//                   future: fetchServices(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(child: Text('No services available'));
//                     } else {
//                       return ServicesComponent(
//                         topServices: snapshot.data!,
//                         bottomServices:
//                             snapshot.data!, // Use the same data for simplicity
//                       );
//                     }
//                   },
//                 ),
//               if (_selectedIndex == 1) HistoryComponent(),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Services',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'History',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.grey[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// // Assuming HeaderComponent, ServicesComponent, HistoryComponent, and NavbarComponent are defined in their respective files.
