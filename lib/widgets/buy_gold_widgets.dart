import 'package:flutter/material.dart';

class BuyGoldWidgets {
  static Widget buildProviderOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 40, color: Colors.amber),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
      onTap: onTap,
    );
  }

  static Widget buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? Colors.blue : Colors.grey, width: 2),
            ),
            child: isSelected
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  static Widget buildAmountChip({
    required int amount,
    required bool buyInRupees,
    required double goldPrice,
    required TextEditingController controller,
    required VoidCallback onUpdate,
  }) {
    return GestureDetector(
      onTap: () {
        if (buyInRupees) {
          controller.text = amount.toString();
        } else {
          controller.text = (amount / goldPrice).toStringAsFixed(4);
        }
        onUpdate();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
        child: Text('₹$amount', style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
