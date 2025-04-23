import 'package:iostest/models/config_model.dart';

class CategoryServiceItem {
  final String categoryId;
  final String icon;
  final String label;
  final String categoryUrl;
  final bool payLaterBillsEnabled;
  final List<BillerRoot> billerRoot;

  CategoryServiceItem({
    required this.categoryId,
    required this.icon,
    required this.label,
    required this.categoryUrl,
    required this.payLaterBillsEnabled,
    required this.billerRoot,
  });

  factory CategoryServiceItem.fromCategory(Category category) {
    return CategoryServiceItem(
      categoryId: category.categoryId,
      icon: category.icon,
      label: category.name,
      categoryUrl: category.categoryUrl,
      payLaterBillsEnabled: category.payLaterBillsEnabled,
      billerRoot: category.billerRoot,
    );
  }
}