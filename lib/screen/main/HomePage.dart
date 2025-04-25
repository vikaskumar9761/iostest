import 'package:flutter/material.dart';
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/models/category_service_item.dart';
import 'package:iostest/screen/RechargeScreen/MobileRechargeScreen.dart';
import 'package:iostest/screen/main/MyAccountScreen.dart';
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
                _selectedIndex == 0 ? 'Services' : 'History',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
            )
          : null,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              if (_selectedIndex == 0)
                HeaderComponent(userName: userName, balance: balance),

              if (_selectedIndex == 0)
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _services.isEmpty
                        ? const Center(child: Text('No services available'))
                        : ServicesGrid(
                            services: _services,
                            onServiceTap: _handleServiceTap,
                          ),

              if (_selectedIndex == 1) const HistoryComponent(),

              if (_selectedIndex == 2) const MyAccountScreen(),
            ],
          ),
        ),
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
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
