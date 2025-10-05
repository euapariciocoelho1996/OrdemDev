import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../Cores/app_colors.dart';

enum LoadingType {
  coding,
  gaming,
  learning,
  processing,
  connecting,
  custom,
}

class CreativeLoadingScreen extends StatefulWidget {
  final LoadingType type;
  final String? title;
  final String? subtitle;
  final List<String>? tips;
  final Duration? duration;

  const CreativeLoadingScreen({
    super.key,
    this.type = LoadingType.coding,
    this.title,
    this.subtitle,
    this.tips,
    this.duration,
  });

  @override
  State<CreativeLoadingScreen> createState() => _CreativeLoadingScreenState();
}

class _CreativeLoadingScreenState extends State<CreativeLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _textController;
  late AnimationController _particleController;
  
  late Animation<double> _mainAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _particleAnimation;
  
  int _currentTipIndex = 0;
  List<String> _tips = [];

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _mainAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));

    _initializeTips();
    _startAnimations();
    _startTipRotation();
  }

  void _initializeTips() {
    _tips = widget.tips ?? _getDefaultTips();
  }

  List<String> _getDefaultTips() {
    switch (widget.type) {
      case LoadingType.coding:
        return [
          '💡 Dica: Pratique código todos os dias para melhorar suas habilidades',
          '🚀 Dica: Comece com problemas simples e aumente a dificuldade gradualmente',
          '📚 Dica: Leia código de outros desenvolvedores para aprender novos padrões',
          '🔧 Dica: Use ferramentas de debug para entender melhor seu código',
          '🎯 Dica: Foque em resolver um problema por vez',
        ];
      case LoadingType.gaming:
        return [
          '🎮 Dica: Pratique regularmente para melhorar sua coordenação',
          '🏆 Dica: Analise seus erros para aprender com eles',
          '⚡ Dica: Mantenha a calma durante os desafios difíceis',
          '🎯 Dica: Defina objetivos pequenos e alcançáveis',
          '🔄 Dica: Repita os níveis difíceis até dominá-los',
        ];
      case LoadingType.learning:
        return [
          '📖 Dica: Faça pausas regulares para absorver melhor o conteúdo',
          '✍️ Dica: Anote pontos importantes para revisar depois',
          '🤝 Dica: Discuta o que aprendeu com outras pessoas',
          '🔄 Dica: Revise o material em intervalos regulares',
          '🎯 Dica: Defina metas claras de aprendizado',
        ];
      case LoadingType.processing:
        return [
          '⏳ Dica: Seja paciente, processamento complexo leva tempo',
          '🔄 Dica: Verifique se todos os dados estão corretos',
          '💾 Dica: Faça backup de dados importantes',
          '🔍 Dica: Monitore o progresso para identificar problemas',
          '✅ Dica: Confirme o resultado antes de prosseguir',
        ];
      case LoadingType.connecting:
        return [
          '🌐 Dica: Verifique sua conexão com a internet',
          '🔄 Dica: Tente novamente se a conexão falhar',
          '📶 Dica: Movimente-se para uma área com melhor sinal',
          '🔧 Dica: Reinicie o aplicativo se necessário',
          '⏰ Dica: Evite horários de pico para melhor performance',
        ];
      case LoadingType.custom:
        return [
          '✨ Dica: Aproveite o momento para relaxar',
          '🎯 Dica: Use este tempo para planejar seus próximos passos',
          '💭 Dica: Reflita sobre o que você aprendeu hoje',
          '🚀 Dica: Mantenha-se motivado para alcançar seus objetivos',
          '🌟 Dica: Cada pequeno progresso conta!',
        ];
    }
  }

  void _startAnimations() {
    _mainController.repeat(reverse: true);
    _textController.forward();
    _particleController.repeat();
  }

  void _startTipRotation() {
    if (_tips.isNotEmpty) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
          });
          _startTipRotation();
        }
      });
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.getTimeBasedGradient(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Partículas de fundo
            _buildParticleBackground(),
            
            // Conteúdo principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animação principal
                  _buildMainAnimation(),
                  
                  const SizedBox(height: 40),
                  
                  // Texto
                  _buildText(),
                  
                  const SizedBox(height: 60),
                  
                  // Dicas
                  _buildTips(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            animationValue: _particleAnimation.value,
            particleCount: 20,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildMainAnimation() {
    return AnimatedBuilder(
      animation: _mainAnimation,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          child: _getLoadingWidget(),
        );
      },
    );
  }

  Widget _getLoadingWidget() {
    switch (widget.type) {
      case LoadingType.coding:
        return _buildCodingAnimation();
      case LoadingType.gaming:
        return _buildGamingAnimation();
      case LoadingType.learning:
        return _buildLearningAnimation();
      case LoadingType.processing:
        return _buildProcessingAnimation();
      case LoadingType.connecting:
        return _buildConnectingAnimation();
      case LoadingType.custom:
        return _buildCustomAnimation();
    }
  }

  Widget _buildCodingAnimation() {
    return Stack(
      children: [
        // Círculo principal
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 3,
            ),
          ),
        ),
        
        // Símbolos de código girando
        ...List.generate(8, (index) {
          final angle = (index * math.pi / 4) + (_mainAnimation.value * 2 * math.pi);
          final radius = 50;
          final x = 60 + radius * math.cos(angle);
          final y = 60 + radius * math.sin(angle);
          
          final symbols = ['<', '>', '{', '}', '[', ']', '(', ')'];
          
          return Positioned(
            left: x - 10,
            top: y - 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbols[index],
                  style: GoogleFonts.sourceCodePro(
                    color: AppColors.primaryGradient.first,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
        
        // Centro
        Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.code,
              color: AppColors.primaryGradient.first,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGamingAnimation() {
    return Stack(
      children: [
        // Controle de jogo
        Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          ),
          child: Stack(
            children: [
              // Botões animados
              Positioned(
                left: 20,
                top: 20,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: _mainAnimation.value > 0.5 ? 25 : 20,
                  height: _mainAnimation.value > 0.5 ? 25 : 20,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: _mainAnimation.value > 0.5 ? 25 : 20,
                  height: _mainAnimation.value > 0.5 ? 25 : 20,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: _mainAnimation.value > 0.5 ? 25 : 20,
                  height: _mainAnimation.value > 0.5 ? 25 : 20,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: _mainAnimation.value > 0.5 ? 25 : 20,
                  height: _mainAnimation.value > 0.5 ? 25 : 20,
                  decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              // D-pad central
              Center(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.gamepad,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLearningAnimation() {
    return Stack(
      children: [
        // Livro
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Páginas
              ...List.generate(5, (index) {
                return Positioned(
                  left: 10 + (index * 2),
                  top: 10,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 60 - (index * 2),
                    height: 80,
                    decoration: BoxDecoration(
                      color: index % 2 == 0 
                          ? Colors.white 
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _mainAnimation.value > (index * 0.2)
                        ? Icon(
                            Icons.text_snippet,
                            color: AppColors.primaryGradient.first,
                            size: 16,
                          )
                        : null,
                  ),
                );
              }),
            ],
          ),
        ),
        
        // Lâmpada
        Positioned(
          right: 10,
          top: 10,
          child: AnimatedBuilder(
            animation: _mainAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_mainAnimation.value * 0.3),
                child: Icon(
                  Icons.lightbulb,
                  color: Colors.amber,
                  size: 30,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingAnimation() {
    return Stack(
      children: [
        // Círculo de progresso
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: _mainAnimation.value,
            strokeWidth: 8,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        
        // Ícones de processamento
        ...List.generate(4, (index) {
          final angle = (index * math.pi / 2) + (_mainAnimation.value * 2 * math.pi);
          final radius = 35;
          final x = 60 + radius * math.cos(angle);
          final y = 60 + radius * math.sin(angle);
          
          final icons = [Icons.computer, Icons.memory, Icons.storage, Icons.network_check];
          
          return Positioned(
              left: x - 15.0,
              top: y - 15.0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icons[index],
                color: AppColors.primaryGradient.first,
                size: 16,
              ),
            ),
          );
        }),
        
        // Centro
        Center(
          child: Icon(
            Icons.settings,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectingAnimation() {
    return Stack(
      children: [
        // Sinal de Wi-Fi
        ...List.generate(4, (index) {
          final size = 40 + (index * 15);
          final opacity = 1.0 - (index * 0.2);
          
          return AnimatedBuilder(
            animation: _mainAnimation,
            builder: (context, child) {
              return Container(
                width: size.toDouble(),
                height: size.toDouble(),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(opacity * _mainAnimation.value),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              );
            },
          );
        }),
        
        // Ícone central
        Center(
          child: AnimatedBuilder(
            animation: _mainAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_mainAnimation.value * 0.2),
                child: Icon(
                  Icons.wifi,
                  color: Colors.white,
                  size: 32,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomAnimation() {
    return Stack(
      children: [
        // Estrelas girando
        ...List.generate(6, (index) {
          final angle = (index * math.pi / 3) + (_mainAnimation.value * 2 * math.pi);
          final radius = 40;
          final x = 60 + radius * math.cos(angle);
          final y = 60 + radius * math.sin(angle);
          
          return Positioned(
            left: x - 10,
            top: y - 10,
            child: AnimatedBuilder(
              animation: _mainAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _mainAnimation.value * 2 * math.pi,
                  child: Icon(
                    Icons.star,
                    color: Colors.amber.withOpacity(0.8),
                    size: 20,
                  ),
                );
              },
            ),
          );
        }),
        
        // Centro
        Center(
          child: Container(
            width: 40,
            height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.primaryGradient),
            shape: BoxShape.circle,
          ),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText() {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textAnimation.value,
          child: Column(
            children: [
              Text(
                widget.title ?? _getDefaultTitle(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subtitle!,
                  style: GoogleFonts.robotoMono(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getDefaultTitle() {
    switch (widget.type) {
      case LoadingType.coding:
        return 'Codificando...';
      case LoadingType.gaming:
        return 'Carregando Jogo...';
      case LoadingType.learning:
        return 'Aprendendo...';
      case LoadingType.processing:
        return 'Processando...';
      case LoadingType.connecting:
        return 'Conectando...';
      case LoadingType.custom:
        return 'Carregando...';
    }
  }

  Widget _buildTips() {
    if (_tips.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Text(
          _tips[_currentTipIndex],
          key: ValueKey(_currentTipIndex),
          style: GoogleFonts.robotoMono(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2);
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;
  final int particleCount;

  ParticlePainter({
    required this.animationValue,
    required this.particleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    for (int i = 0; i < particleCount; i++) {
      final x = (i * 50.0) % size.width;
      final y = (i * 30.0 + animationValue * 100) % size.height;
      
      final opacity = (math.sin(animationValue * 2 * math.pi + i) + 1) / 2;
      
      paint.color = Colors.white.withOpacity(opacity * 0.3);
      
      canvas.drawCircle(
        Offset(x, y),
        2 + (math.sin(animationValue * math.pi + i) + 1) * 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
