import 'package:flutter/material.dart';

class HeaderComponent extends StatelessWidget {
  final String userName;
  final String balance;
  final String points;

  const HeaderComponent({
    super.key,
    this.userName = 'Zhafira',
    this.balance = 'IDR 895.500,00',
    this.points = '9.500',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E25),
        image: DecorationImage(
          image: NetworkImage(
              'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            // Welcome section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            color: Color(0xFF7F8088),
                          ),
                        ),
                        Text(
                          userName,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Image.network(
                    //   'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/icon.png',
                    //   width: 24,
                    //   height: 24,
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                // Balance section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet Balance',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        color: Color(0xFFF6E7E2),
                      ),
                    ),
                    Text(
                      balance,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEED7D4),
                      ),
                    ),
                  ],
                ),
                //const SizedBox(height: 20),
                // Points section
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         Image.network(
                //           'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/image-1.png',
                //           width: 24,
                //           height: 24,
                //         ),
                //         const SizedBox(width: 8),
                //         Text(
                //           points,
                //           style: TextStyle(
                //             fontFamily: 'Urbanist',
                //             fontSize: 14,
                //             fontWeight: FontWeight.w700,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 20),
                // Menu section
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     _buildMenuButton('https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-85-2.png'),
                //     _buildMenuButton('https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-85.png'),
                //     _buildMenuButton('https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/icon-fra.png', isIcon: true),
                //     _buildMenuButton('https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-85-3.png'),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String imageUrl, {bool isIcon = false}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF7F7F7),
      ),
      child: Center(
        child: isIcon
            ? SizedBox(
                width: 24,
                height: 24,
                child: Image.network(imageUrl),
              )
            : Image.network(imageUrl),
      ),
    );
  }
}
