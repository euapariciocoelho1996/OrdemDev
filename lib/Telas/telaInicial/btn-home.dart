import 'package:flutter/material.dart';

// Widget reutilizável
class CustomFloatingButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Widget navigateTo;

  const CustomFloatingButton({
    super.key,
    required this.icon,
    required this.color,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: color,
      shape: const CircleBorder(), // garante formato totalmente circular
      child: Icon(icon, size: 30, color: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      },
    );
  }
}
