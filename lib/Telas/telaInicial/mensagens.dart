import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CCarousel extends StatefulWidget {
  const CCarousel({Key? key}) : super(key: key);

  @override
  State<CCarousel> createState() => _CCarouselState();
}

class _CCarouselState extends State<CCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Widget> _messages = [
    Text(
      "Bem-vindo(a) ao mundo do C! Poderoso, eficiente e fundamental.",
      textAlign: TextAlign.center,
      style: GoogleFonts.robotoMono(
        fontSize: 16,
        color: Colors.white70,
        fontWeight: FontWeight.w500,
      ),
    ),
    Text(
      "Dica: domine os ponteiros para desbloquear o poder total da linguagem.",
      textAlign: TextAlign.center,
      style: GoogleFonts.robotoMono(
        fontSize: 16,
        color: Colors.white70,
        fontWeight: FontWeight.w500,
      ),
    ),
    Text(
      "Por que estudar C? É a base de muitos sistemas e ideal para programação de baixo nível.",
      textAlign: TextAlign.center,
      style: GoogleFonts.robotoMono(
        fontSize: 16,
        color: Colors.white70,
        fontWeight: FontWeight.w500,
      ),
    ),
    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Além disso, temos ',
            style: GoogleFonts.robotoMono(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '+30 exercícios',
            style: GoogleFonts.robotoMono(
              fontSize: 16,
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' para você praticar e se tornar um mestre em C!',
            style: GoogleFonts.robotoMono(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % _messages.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return Center(child: _messages[index]);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_messages.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 10 : 6,
              height: _currentPage == index ? 10 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Colors.white70 // ativo suave, sem brilho intenso
                    : Colors.grey.shade600, // inativo
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}
