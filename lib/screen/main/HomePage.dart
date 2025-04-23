import 'package:flutter/material.dart';
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/models/category_service_item.dart';
import 'package:iostest/screen/RechargeScreen/MobileRechargeScreen.dart';
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
String userName="";
String balance="";

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
var user = await SecureStorageService.getUser();
print(user);
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
              .take(7) // Take first 7 services
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
    switch (service.categoryId) {
      case 'mobile':
            final billerRoots = await ConfigUtil.getBillerRootForCategory('mobile');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MobileRechargeScreen(categoryId: "mobile",billerRoot: billerRoots),
            //OperatorSelectionScreen(categoryId: 'mobile',billerRoot: billerRoots),

            // MobileRechargeScreen(
            //   operators: service.billerRoot,
            // ),
          ),
        );
        break;
      
      case 'electricity':
                  
                  final billerRoots = await ConfigUtil.getBillerRootForCategory('electricity');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OperatorSelectionScreen(categoryId: 'electricity',  billerRoot: billerRoots,phoneNumber: "", ),
            // ElectricityBillersScreen(
            //   billers: service.billerRoot,
            // ),
          ),
        );
        break;

      // Add other cases as needed
      default:
           final billerRoots = await ConfigUtil.getBillerRootForCategory(service.categoryId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OperatorSelectionScreen(categoryId: service.categoryId,  billerRoot: billerRoots, 
            phoneNumber: "",
            ),
            // ElectricityBillersScreen(
            //   billers: service.billerRoot,
            // ),
          ),
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Coming soon: ${service.label}')),
        // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              HeaderComponent(userName: userName,balance: balance,),
              if (_selectedIndex == 0) ...[
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_services.isEmpty)
                  const Center(child: Text('No services available'))
                else
                  ServicesGrid(
                    services: _services,
                    onServiceTap: _handleServiceTap,
                  ),
              ],
              if (_selectedIndex == 1) 
                const HistoryComponent(),
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[800],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}