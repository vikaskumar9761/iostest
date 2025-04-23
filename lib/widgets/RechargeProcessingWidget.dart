import 'package:flutter/material.dart';

class RechargeProcessingWidget extends StatelessWidget {
  final String operator;
  final String number;
  final String status;
  
  const RechargeProcessingWidget({
    super.key,
    required this.operator,
    required this.number,
    this.status = "PROCESSING",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operator Logo
            _buildOperatorLogo(),
            const SizedBox(width: 12),
            
            // Recharge Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recharge Info
                  Text(
                    'Recharge of',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Mobile Operator and Number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$operator Mobile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // Status Chip
                      _buildStatusChip(),
                    ],
                  ),
                  
                  // Mobile Number
                  Text(
                    number,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Status Message
                  Text(
                    'Waiting for operator confirmation',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorLogo() {
    // Different logos based on operator
    if (operator.toLowerCase() == 'vodafone') {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Image.asset(
          'assets/images/vodafone_logo.png',
          // If you don't have the asset, use a colored container instead
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  'V',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else if (operator.toLowerCase() == 'airtel') {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            'A',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      );
    } else {
      // Generic operator logo
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Icon(
            Icons.phone_android,
            color: Colors.white,
            size: 24,
          ),
        ),
      );
    }
  }

  Widget _buildStatusChip() {
    Color chipColor;
    Color textColor;
    
    switch (status.toUpperCase()) {
      case "PROCESSING":
        chipColor = Colors.orange;
        textColor = Colors.white;
        break;
      case "SUCCESS":
        chipColor = Colors.green;
        textColor = Colors.white;
        break;
      case "FAILED":
        chipColor = Colors.red;
        textColor = Colors.white;
        break;
      default:
        chipColor = Colors.orange;
        textColor = Colors.white;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}