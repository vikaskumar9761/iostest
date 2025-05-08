
import 'package:iostest/models/config_model.dart';
import 'package:iostest/config/secure_storage_service.dart';

class ConfigUtil {
  /// Gets the list of BillerRoot for a specific category ID
  static Future<List<BillerRoot>> getBillerRootForCategory(String categoryId) async {
    try {
      final config = await SecureStorageService.getConfig();
      if (config != null) {
        final category = config.categories.firstWhere(
          (category) => category.categoryId == categoryId,
          orElse: () => throw Exception('Category not found: $categoryId'),
        );
        return category.billerRoot;
      }
      throw Exception('Config not found');
    } catch (e) {
      print('Error getting biller root: $e');
      return [];
    }
  }

  /// Gets category details by ID
  static Future<Category?> getCategoryById(String categoryId) async {
    try {
      final config = await SecureStorageService.getConfig();
      if (config != null) {
        return config.categories.firstWhere(
          (category) => category.categoryId == categoryId,
          orElse: () => throw Exception('Category not found: $categoryId'),
        );
      }
      return null;
    } catch (e) {
      print('Error getting category: $e');
      return null;
    }
  }

  /// Gets biller details by operator ID from a specific category
  static Future<Biller?> getBillerByOperatorId(String categoryId, int operatorId) async {
    try {
      final billerRoots = await getBillerRootForCategory(categoryId);
      for (var root in billerRoots) {
        final biller = root.billers.firstWhere(
          (biller) => biller.op == operatorId,
          orElse: () => throw Exception('Biller not found'),
        );
        return biller;
      }
      return null;
    } catch (e) {
      print('Error getting biller: $e');
      return null;
    }
  }

  /// Gets the list of Circles
  static Future<List<Circle>> getCircles() async {
    try {
      final config = await SecureStorageService.getConfig();
      if (config != null) {
        return config.circles; // Assuming `circles` is a field in `ConfigModel`
      }
      throw Exception('Config not found');
    } catch (e) {
      print('Error getting circles: $e');
      return [];
    }
  }


    /// Gets the list of Browse Plans
  static Future<List<BrowsePlan>> getBrowsePlans() async {
    try {
      final config = await SecureStorageService.getConfig();
      if (config != null) {
        return config.browsePlansMapping; // Assuming `browsePlansMapping` is a field in `ConfigModel`
      }
      throw Exception('Config not found');
    } catch (e) {
      print('Error getting browse plans: $e');
      return [];
    }
  }


}