import 'package:flutter/material.dart';
import 'package:iostest/models/category_service_item.dart';



class ServicesComponent extends StatelessWidget {
  final List<CategoryServiceItem> topServices;
  final List<CategoryServiceItem> bottomServices;

  const ServicesComponent({super.key, 
    this.topServices = const [
      
    ],
    this.bottomServices = const [
     
    ],
  });

  // ServicesComponent({
  //   this.topServices = const [
  //     ServiceItem(icon: 'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25.png', label: 'Pulse'),
  //     ServiceItem(icon: 'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-2.png', label: 'Internet'),
  //     ServiceItem(icon: 'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-3.png', label: 'Call Package'),
  //     ServiceItem(icon: 'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-4.png', label: 'Water'),
  //   ],
  //   this.bottomServices = const [
  //     ServiceItem(icon: 'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-5.png', label: 'Electricity'),
  //     ServiceItem(icon: 'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-6.png', label: 'Insurance'),
  //     ServiceItem(icon: 'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-7.png', label: 'Game'),
  //     ServiceItem(icon: 'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-25-8.png', label: 'More'),
  //   ],
  // });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = constraints.maxWidth / 4 - 16;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceRow(topServices, itemWidth),
              _buildServiceRow(bottomServices, itemWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceRow(List<CategoryServiceItem> services, double itemWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: services.map((service) => _buildServiceItem(service, itemWidth)).toList(),
    );
  }

  Widget _buildServiceItem(CategoryServiceItem service, double itemWidth) {
    return SizedBox(
      width: itemWidth,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {},
                child: Image.network(
                  service.icon,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            service.label,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.33,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [
                    Color(0xFF780C0C),
                    Color(0xFF905C3F),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(Rect.fromLTWH(0, 0, 56, 16)),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

