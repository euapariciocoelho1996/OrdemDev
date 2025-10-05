import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showCustomAlertDialog({
  required BuildContext context,
  required String title, 
  required String message, 
  required String subMessage, 
  required String buttonText, 
  required VoidCallback onPressed, // Função ao clicar no botão
  Color buttonColor = Colors.orange, 
}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // Impede que feche clicando fora
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: GoogleFonts.robotoMono(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              subMessage,
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o alerta
              onPressed(); 
            },
            child: Text(
              buttonText,
              style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.w600,
                color: buttonColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}
