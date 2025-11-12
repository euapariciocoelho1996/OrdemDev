import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Cores/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'WOW!',
      'text': 'O passo mais importante você já deu: a decisão de começar.',
      'icon': Icons.emoji_events,
      'color': AppColors.cardOrange,
    },
    {
      'title': 'Desafie seus Limites',
      'text': 'Prepare-se para explorar estruturas, funções e desafios que desafiam sua mente.',
      'icon': Icons.auto_graph,
      'color': AppColors.cardCyan,
    },
    {
      'title': 'HORA DE COMEÇAR!',
      'text': 'Vamos lá, o próximo nível de habilidades te espera!',
      'icon': Icons.rocket_launch,
      'color': AppColors.cardBlue,
    },
  ];

  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingSeen', true);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ícone moderno
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                page['color'],
                                page['color'].withOpacity(0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: page['color'].withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(32),
                          child: Icon(
                            page['icon'],
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Título com gradiente
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [page['color'], page['color'].withOpacity(0.8)],
                          ).createShader(bounds),
                          child: Text(
                            page['title'],
                            style: GoogleFonts.robotoMono(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          page['text'],
                          style: GoogleFonts.robotoMono(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicadores de página modernos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final page = _pages[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: _currentPage == index
                        ? LinearGradient(colors: [page['color'], page['color'].withOpacity(0.7)])
                        : null,
                    color: _currentPage == index ? null : const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: _currentPage == index
                        ? [
                            BoxShadow(
                              color: page['color'].withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                );
              }),
            ),
            // Botão moderno
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _pages[_currentPage]['color'],
                      _pages[_currentPage]['color'].withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _pages[_currentPage]['color'].withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Começar Jornada' : 'Próximo',
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
