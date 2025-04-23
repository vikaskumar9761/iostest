import 'package:flutter/material.dart';
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/models/category_service_item.dart';
import 'package:iostest/utils/config_util.dart';
import 'package:iostest/widgets/services_grid.dart';
import 'package:iostest/screen/RechargeScreen/MobileRechargeScreen.dart';
import 'package:iostest/screen/operator/OperatorSelectionScreen.dart';

class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({super.key});

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  List<CategoryServiceItem> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  /// Load all services from the configuration
  Future<void> _loadServices() async {
    try {
      final configData = await SecureStorageService.getConfig();
      if (configData != null) {
        final config = configData;
        setState(() {
          // Filter out the "More" item if it exists
          _services = config.categories
              .map((category) => CategoryServiceItem.fromCategory(category))
              .where((service) => service.label.toLowerCase() != 'more') // Exclude "More"
              .toList();
          _isLoading = false;
        });

        print('Total Services: ${_services.length}');
        for (var service in _services) {
          print('Category ID: ${service.categoryId}, Label: ${service.label}');
        }
      }
    } catch (e) {
      print('Error loading services: $e');
      setState(() => _isLoading = false);
    }
  }

  /// Handle service tap
  void _handleServiceTap(CategoryServiceItem service) async {
    switch (service.categoryId) {
      case 'mobile':
        final billerRoots = await ConfigUtil.getBillerRootForCategory('mobile');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MobileRechargeScreen(
              categoryId: "mobile",
              billerRoot: billerRoots,
            ),
          ),
        );
        break;

      case 'electricity':
        final billerRoots = await ConfigUtil.getBillerRootForCategory('electricity');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OperatorSelectionScreen(
              categoryId: 'electricity',
              billerRoot: billerRoots,
              phoneNumber: "",
            ),
          ),
        );
        break;

      default:
        final billerRoots = await ConfigUtil.getBillerRootForCategory(service.categoryId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OperatorSelectionScreen(
              categoryId: service.categoryId,
              billerRoot: billerRoots,
              phoneNumber: "",
            ),
          ),
        );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('All Services'),
      centerTitle: true,
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _services.isEmpty
            ? const Center(child: Text('No services available'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: ServicesGrid(
                  services: _services,
                  onServiceTap: _handleServiceTap,
                  showMore: false, // Hide the "More" item
                ),
              ),
  );
}
}