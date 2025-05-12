// lib/widgets/guest_room_selector.dart
import 'package:flutter/material.dart';

class GuestRoomSelector extends StatelessWidget {
  final int adults;
  final int rooms;
  final int children;
  final Function(int, int, int) onDone;

  const GuestRoomSelector({
    super.key,
    required this.adults,
    required this.rooms,
    required this.children,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    int tempAdults = adults;
    int tempRooms = rooms;
    int tempChildren = children;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel, color: Colors.red, size: 36),
                SizedBox(height: 8),
                Text(
                  "Room & Guest",
                  style: TextStyle(
                    fontFamily: 'CabinSketch',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                _dropdownRow(
                  icon: Icons.home,
                  label: "Room",
                  value: tempRooms,
                  min: 1,
                  max: 10,
                  onChanged: (v) => setModalState(() => tempRooms = v),
                ),
                _dropdownRow(
                  icon: Icons.people,
                  label: "Adult",
                  value: tempAdults,
                  min: 1,
                  max: 10,
                  onChanged: (v) => setModalState(() => tempAdults = v),
                ),
                _dropdownRow(
                  icon: Icons.family_restroom,
                  label: "Children",
                  value: tempChildren,
                  min: 0,
                  max: 5,
                  onChanged: (v) => setModalState(() => tempChildren = v),
                ),
                SizedBox(height: 16),
                Text(
                  "Please provide right number of children along with their right age for best options and price",
                  style: TextStyle(
                    color: Colors.orange,
                    fontFamily: 'DancingScript',
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      onDone(tempAdults, tempRooms, tempChildren);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "DONE",
                      style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dropdownRow({
    required IconData icon,
    required String label,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontFamily: 'DancingScript', fontSize: 18),
            ),
          ),
          DropdownButton<int>(
            value: value,
            items: List.generate(
              max - min + 1,
              (index) => DropdownMenuItem(
                value: min + index,
                child: Text('${min + index}'),
              ),
            ),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
