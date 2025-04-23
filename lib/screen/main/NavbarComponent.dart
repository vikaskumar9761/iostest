import 'package:flutter/material.dart';

class NavbarComponent extends StatelessWidget {
  const NavbarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home, true),
                _buildNavItem(Icons.description_outlined, false),
                _buildNavItem(Icons.calendar_today_outlined, false),
                _buildNavItem(Icons.person_outline, false),
              ],
            ),
          ),
          Container(
            height: 21,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/i-phone-x.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return InkWell(
      onTap: () {
        // Handle navigation
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          icon,
          size: 24,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}

