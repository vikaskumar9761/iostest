import 'package:flutter/material.dart';
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/models/category_service_item.dart';
import 'package:iostest/screen/Flight%20Book/flight_boking.dart';
import 'package:iostest/screen/Gold%20Sip/gold_screen.dart';
import 'package:iostest/screen/Hotel%20Screens/hotel_screen.dart';
import 'package:iostest/screen/RechargeScreen/MobileRechargeScreen.dart';
import 'package:iostest/screen/main/MyAccountScreen.dart';
import 'package:iostest/screen/main/more_services_component.dart';
import 'package:iostest/screen/operator/OperatorSelectionScreen.dart';
import 'package:iostest/utils/config_util.dart';
import 'package:iostest/widgets/services_grid.dart';
import 'HeaderComponent.dart';
import 'HistoryComponent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<CategoryServiceItem> _services = [];
  bool _isLoading = true;
  String userName = "";
  String balance = "";

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      var user = await SecureStorageService.getUser();
      if (user != null) {
        setState(() {
          userName = user["firstName"];
          balance = user["balance"].toString();
        });
      }

      final configData = await SecureStorageService.getConfig();
      if (configData != null) {
        final config = configData;
        setState(() {
          _services = config.categories
              .take(7)
              .map((category) => CategoryServiceItem.fromCategory(category))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading services: $e');
      setState(() => _isLoading = false);
    }
  }

  void _handleServiceTap(CategoryServiceItem service) async {
    final billerRoots =
        await ConfigUtil.getBillerRootForCategory(service.categoryId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => service.categoryId == 'mobile'
            ? MobileRechargeScreen(
                categoryId: "mobile",
                billerRoot: billerRoots,
              )
            : OperatorSelectionScreen(
                categoryId: service.categoryId,
                billerRoot: billerRoots,
                phoneNumber: "",
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 2
          ? AppBar(
              title: Text(
                _selectedIndex == 0
                    ? 'Services'
                    : _selectedIndex == 1
                        ? 'History'
                        : _selectedIndex == 2
                            ? 'Profile'
                            : 'Flight Booking',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Services Screen
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderComponent(userName: userName, balance: balance),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _services.isEmpty
                        ? const Center(child: Text('No services available'))
                        : ServicesGrid(
                            services: _services,
                            onServiceTap: _handleServiceTap,
                          ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEBEBF2),
                ),
                const SizedBox(height: 5),




 // Sip Gold Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    "Wealth",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
   GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    MoreServicesComponent(
                      image: "https://cdn-icons-png.flaticon.com/128/9210/9210106.png",
                      label: 'Gold',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GoldScreen(),
                          ),
                        );
                      },
                    ),
                      MoreServicesComponent(
                      image: "https://cdn-icons-png.flaticon.com/128/15014/15014319.png",
                      label: 'Gold SIP',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FlightBookingScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
               
                 const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEBEBF2),
                ),
                const SizedBox(height: 5),




 // Travel Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    "Travel",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    MoreServicesComponent(
                      image: "https://cdn-icons-png.flaticon.com/128/1085/1085493.png",
                      label: 'Flights',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FlightBookingScreen(),
                          ),
                        );
                      },
                    ),

                    MoreServicesComponent(
                      image: "https://cdn-icons-png.flaticon.com/512/4707/4707600.png",
                      label: 'Bus',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FlightBookingScreen(),
                          ),
                        );
                      },
                    ),

                    MoreServicesComponent(
                      image: "https://cdn-icons-png.flaticon.com/128/4320/4320277.png",
                      label: 'Hotel',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  HotelSearchScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEBEBF2),
                ),

                

 //Shopping Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    "Shopping",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
   GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    MoreServicesComponent(
                      image: "https://cdn-icons-png.flaticon.com/128/9674/9674658.png",
                      label: 'Sopping',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FlightBookingScreen(),
                          ),
                        );
                      },
                    ),
                      MoreServicesComponent(
                      image: "https://cdn-icons-png.flaticon.com/128/2777/2777142.png",
                      label: 'Electronics',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FlightBookingScreen(),
                          ),
                        );
                      },
                    ),
                        MoreServicesComponent(
                      image: "https://cdn-icons-png.flaticon.com/512/1261/1261089.png",
                      label: 'Grocery',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FlightBookingScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
               
                 const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEBEBF2),
                ),
                const SizedBox(height: 5),



              ],
            ),
          ),
          // History Screen
          const HistoryComponent(),
          // My Account Screen
          const MyAccountScreen(),
          // Flight Booking Screen
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
         
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}