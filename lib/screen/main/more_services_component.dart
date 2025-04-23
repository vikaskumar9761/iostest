import 'package:flutter/material.dart';

class MoreServicesComponent extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const MoreServicesComponent({
    super.key,
    this.image = 'https://dashboard.codeparrot.ai/api/image/Z-gtz3n5m-GBkPAF/group-25.png',
    this.label = 'Service',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents the Column from expanding unnecessarily
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[100], // Background color for the icon
                ),
                padding: const EdgeInsets.all(12),
                child: Image.network(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.error_outline,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1D1E25),
                height: 16 / 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1, // Ensures the text does not overflow
              overflow: TextOverflow.ellipsis, // Adds ellipsis if the text is too long
            ),
          ),
        ],
      ),
    );
  }
}