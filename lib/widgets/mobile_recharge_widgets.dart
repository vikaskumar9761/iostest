import 'package:flutter/material.dart';

class MobileRechargeWidgets {
  // Recharge Type Selector
  static Widget rechargeTypeSelector({
    required String selectedType,
    required ValueChanged<String> onChanged,
  }) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          rechargeOption(
            type: 'Prepaid',
            selectedType: selectedType,
            onChanged: onChanged,
          ),
          SizedBox(width: 20),
          rechargeOption(
            type: 'PostPaid',
            selectedType: selectedType,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // Recharge Option (Radio Button)
  static Widget rechargeOption({
    required String type,
    required String selectedType,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: [
        Radio<String>(
          value: type,
          groupValue: selectedType,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
        Text(
          type,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Phone Number Input Field
  static Widget phoneNumberInput({
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Enter Valid Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Proceed Button
  static Widget proceedButton({
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Proceed',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
