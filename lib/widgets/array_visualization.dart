import 'package:flutter/material.dart';

class ArrayVisualization extends StatelessWidget {
  final List<int> array;
  final int? comparingA;
  final int? comparingB;
  final Set<int> finalized;
  final int? swappingA;
  final int? swappingB;
  final String? description;

  const ArrayVisualization({
    super.key,
    required this.array,
    this.comparingA,
    this.comparingB,
    this.finalized = const {},
    this.swappingA,
    this.swappingB,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (description != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              description!,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < array.length; i++)
              _buildArrayItem(context, i),
          ],
        ),
      ],
    );
  }

  Widget _buildArrayItem(BuildContext context, int index) {
    Color color = Colors.blueGrey.shade700;
    IconData? icon;
    if (finalized.contains(index)) {
      color = Colors.green;
      icon = Icons.check_circle_outline;
    } else if ((swappingA == index || swappingB == index)) {
      color = Colors.orange;
      icon = Icons.swap_horiz;
    } else if ((comparingA == index || comparingB == index)) {
      color = Colors.amber;
      icon = Icons.compare_arrows;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 18),
          Text(
            array[index].toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
} 