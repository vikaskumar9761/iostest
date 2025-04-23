import 'package:flutter/material.dart';
import 'package:iostest/models/category_service_item.dart';
import 'package:iostest/screen/main/more_services_component.dart';
import 'package:iostest/screen/main/AllServicesScreen.dart';

class ServicesGrid extends StatelessWidget {
  final List<CategoryServiceItem> services;
  final Function(CategoryServiceItem) onServiceTap;
  final bool showMore; // Flag to control whether "More" is displayed

  const ServicesGrid({
    super.key,
    required this.services,
    required this.onServiceTap,
    this.showMore = true, // Default to true for home screen
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recharge',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7GSXIG5qySF2UD2H9RXxjai2xdq-XoJEFLQ&s', // Replace with your image URL
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            ...services.map((service) => MoreServicesComponent(
                  image: service.icon,
                  label: service.label,
                  onTap: () {
                    onServiceTap(service);
                  },
                )),
            if (showMore) // Conditionally show the "More" item
              MoreServicesComponent(
                image: 'https://dashboard.codeparrot.ai/api/image/Z-gtz3n5m-GBkPAF/group-25-8.png',
                label: 'More',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllServicesScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}