import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class MotivationalBanner extends StatefulWidget {
  const MotivationalBanner({super.key});

  @override
  State<MotivationalBanner> createState() => _MotivationalBannerState();
}

class _MotivationalBannerState extends State<MotivationalBanner> {
  int _currentTipIndex = 0;
  Timer? _timer;

  final List<String> dailyTips = [
    'A prática constante é a chave para dominar algoritmos. Comece com conceitos básicos e avance gradualmente!',
    'Entender a lógica por trás dos algoritmos é mais importante que decorar o código.',
    'Faça pequenos exercícios todos os dias para manter seu conhecimento atualizado.',
    'Não tenha medo de errar. Cada erro é uma oportunidade de aprendizado.',
    'Visualize o funcionamento dos algoritmos para melhor compreensão.',
    'Revise regularmente os conceitos já aprendidos para fixar o conhecimento.',
    'Experimente implementar os algoritmos de diferentes formas.',
    'Compare diferentes algoritmos para entender suas vantagens e desvantagens.',
    'Use comentários no código para documentar seu raciocínio.',
    'Pratique a resolução de problemas do dia a dia usando algoritmos.',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    // 90 minutos = 5400 segundos
    _timer = Timer.periodic(const Duration(minutes: 90), (timer) {
      setState(() {
        _currentTipIndex = (_currentTipIndex + 1) % dailyTips.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Dica do Dia',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                dailyTips[_currentTipIndex],
                key: ValueKey<int>(_currentTipIndex),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY();
  }
} 