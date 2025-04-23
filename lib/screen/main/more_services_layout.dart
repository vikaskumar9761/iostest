import 'package:flutter/material.dart';
import 'more_services_component.dart';

class MoreServicesLayout extends StatelessWidget {
  const MoreServicesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double gridWidth = constraints.maxWidth;
        int crossAxisCount = gridWidth ~/ 80;

        return Container(
          width: gridWidth,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'More Services',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Color(0xFF1D1E25),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 56,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFE9ECF2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1,
                  children: [
                    MoreServicesComponent(
                      image: 'https://dashboard.codeparrot.ai/api/image/Z-gtz3n5m-GBkPAF/group-25.png',
                      label: 'Service 1',
                      onTap: () {},
                    ),
                    MoreServicesComponent(
                      image: 'https://dashboard.codeparrot.ai/api/image/Z-gtz3n5m-GBkPAF/group-26.png',
                      label: 'Service 2',
                      onTap: () {},
                    ),
                    MoreServicesComponent(
                      image: 'https://dashboard.codeparrot.ai/api/image/Z-gtz3n5m-GBkPAF/group-27.png',
                      label: 'Service 3',
                      onTap: () {},
                    ),
                    MoreServicesComponent(
                      image: 'https://dashboard.codeparrot.ai/api/image/Z-gtz3n5m-GBkPAF/group-28.png',
                      label: 'Service 4',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Container(
                height: 21,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://dashboard.codeparrot.ai/api/image/Z-gtz3n5m-GBkPAF/i-phone-x.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

