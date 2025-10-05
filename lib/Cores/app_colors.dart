import 'package:flutter/material.dart';

class AppColors {
  // Cores base aprimoradas
  static const Color neutral80 = Color(0xFF01173C);
  static const Color background = Color(0xFF0A0D14); // Fundo mais escuro e rico
  static const Color primaryCard = Color(0xFF1A1D29); // Cartão com mais contraste
  static const Color secondaryCard = Color(0xFF252836); // Cartões secundários mais vibrantes
  static const Color accent = Color(0xFF6366F1); // Índigo vibrante
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE2E8F0); // Texto mais claro
  static const Color subtleText = Color(0xFF94A3B8); // Texto sutil melhorado
  static const Color icon = Color(0xFF8B5CF6); // Roxo vibrante
  static const Color cardColor = Color(0xFF1E2128);

  // Cores de cartões mais vibrantes e saturadas
  static const Color cardBlue = Color(0xFF3B82F6); // Azul mais vibrante
  static const Color cardPurple = Color(0xFF8B5CF6); // Roxo mais saturado
  static const Color cardTeal = Color(0xFF10B981); // Verde esmeralda
  static const Color cardOrange = Color(0xFFF59E0B); // Laranja mais quente
  static const Color cardPink = Color(0xFFEC4899); // Rosa mais intenso
  static const Color cardYellow = Color(0xFFFCD34D); // Amarelo mais dourado
  static const Color cardRed = Color(0xFFEF4444); // Vermelho vibrante
  static const Color cardGreen = Color(0xFF22C55E); // Verde vibrante
  static const Color cardCyan = Color(0xFF06B6D4); // Ciano vibrante

  // Gradientes dinâmicos
  static const List<Color> primaryGradient = [
    Color(0xFF667EEA), // Azul índigo
    Color(0xFF764BA2), // Roxo profundo
  ];

  static const List<Color> successGradient = [
    Color(0xFF10B981), // Verde esmeralda
    Color(0xFF059669), // Verde escuro
  ];

  static const List<Color> warningGradient = [
    Color(0xFFF59E0B), // Laranja
    Color(0xFFD97706), // Laranja escuro
  ];

  static const List<Color> errorGradient = [
    Color(0xFFEF4444), // Vermelho
    Color(0xFFDC2626), // Vermelho escuro
  ];

  static const List<Color> cardGradient1 = [
    Color(0xFF667EEA),
    Color(0xFF764BA2),
  ];

  static const List<Color> cardGradient2 = [
    Color(0xFFF093FB),
    Color(0xFFF5576C),
  ];

  static const List<Color> cardGradient3 = [
    Color(0xFF4FACFE),
    Color(0xFF00F2FE),
  ];

  static const List<Color> cardGradient4 = [
    const Color(0xFF50D5B7), // Verde-água claro
          const Color(0xFF067D68), // Verde-água escuro
  ];

  static const List<Color> cardGradient5 = [
    Color(0xFFFA709A),
    Color(0xFFFEE140),
  ];

  static const List<Color> cardGradient6 = [
   const Color(0xFFC22ED0), // Roxo
    const Color(0xFF5FFAE0), // Ciano
  ];

  // Gradientes para diferentes horários
  static const List<Color> morningGradient = [
    Color(0xFFFFD89B), // Dourado claro
    Color(0xFF19547B), // Azul escuro
  ];

  static const List<Color> afternoonGradient = [
    Color(0xFF4FACFE), // Azul claro
    Color(0xFF00F2FE), // Ciano
  ];

  static const List<Color> eveningGradient = [
    Color(0xFF667EEA), // Índigo
    Color(0xFF764BA2), // Roxo
  ];

  static const List<Color> nightGradient = [
    Color(0xFF2C3E50), // Azul escuro
    Color(0xFF3498DB), // Azul médio
  ];

  // Método para obter gradiente baseado no horário
  static List<Color> getTimeBasedGradient() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return morningGradient;
    } else if (hour >= 12 && hour < 17) {
      return afternoonGradient;
    } else if (hour >= 17 && hour < 21) {
      return eveningGradient;
    } else {
      return nightGradient;
    }
  }

  // Método para obter gradiente de cartão baseado no índice
  static List<Color> getCardGradient(int index) {
    final gradients = [
      cardGradient1,
      cardGradient2,
      cardGradient3,
      cardGradient4,
      cardGradient5,
      cardGradient6,
    ];
    return gradients[index % gradients.length];
  }
} 