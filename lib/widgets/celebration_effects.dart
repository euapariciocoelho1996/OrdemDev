import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import '../Cores/app_colors.dart';
import '../services/audio_service.dart';

enum CelebrationType {
  success,
  achievement,
  levelUp,
  perfect,
  streak,
  milestone,
}

class CelebrationOverlay extends StatefulWidget {
  final CelebrationType type;
  final String title;
  final String subtitle;
  final VoidCallback? onComplete;
  final Duration duration;

  const CelebrationOverlay({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    this.onComplete,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _bounceController;
  late AnimationController _glowController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;
  
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeInOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _confettiController = ConfettiController(duration: widget.duration);
    _audioPlayer = AudioPlayer();

    _startCelebration();
  }

  void _startCelebration() async {
    // Toca som de celebração
    await _playCelebrationSound();
    
    // Inicia animações
    _scaleController.forward();
    _rotateController.repeat();
    _bounceController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
    
    // Inicia confetti
    _confettiController.play();
    
    // Auto-dismiss após duração
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  Future<void> _playCelebrationSound() async {
    try {
      switch (widget.type) {
        case CelebrationType.success:
          await AudioService().playCorrectSound();
          break;
        case CelebrationType.achievement:
        case CelebrationType.levelUp:
          await AudioService().playCongratulationsSound();
          break;
        case CelebrationType.perfect:
          await _audioPlayer.play(AssetSource('audio/congratulations.mp3'));
          break;
        case CelebrationType.streak:
          await _audioPlayer.play(AssetSource('audio/congratulations.mp3'));
          break;
        case CelebrationType.milestone:
          await _audioPlayer.play(AssetSource('audio/congratulations.mp3'));
          break;
      }
    } catch (e) {
      print('Erro ao tocar som de celebração: $e');
    }
  }

  void _dismiss() async {
    _scaleController.reverse();
    _confettiController.stop();
    
    widget.onComplete?.call();
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    _bounceController.dispose();
    _glowController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors() {
    switch (widget.type) {
      case CelebrationType.success:
        return AppColors.successGradient;
      case CelebrationType.achievement:
        return [Colors.amber.shade400, Colors.orange.shade400];
      case CelebrationType.levelUp:
        return AppColors.primaryGradient;
      case CelebrationType.perfect:
        return [Colors.purple.shade400, Colors.pink.shade400];
      case CelebrationType.streak:
        return [Colors.green.shade400, Colors.teal.shade400];
      case CelebrationType.milestone:
        return [Colors.cyan.shade400, Colors.blue.shade400];
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case CelebrationType.success:
        return Icons.check_circle;
      case CelebrationType.achievement:
        return Icons.emoji_events;
      case CelebrationType.levelUp:
        return Icons.trending_up;
      case CelebrationType.perfect:
        return Icons.star;
      case CelebrationType.streak:
        return Icons.local_fire_department;
      case CelebrationType.milestone:
        return Icons.flag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();
    
    return Material(
      color: Colors.black.withOpacity(0.7),
      child: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: math.pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 100,
              gravity: 0.3,
              shouldLoop: false,
              colors: [
                gradientColors.first,
                gradientColors.last,
                Colors.white,
                Colors.yellow,
                Colors.cyan,
              ],
            ),
          ),
          
          // Conteúdo principal
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _scaleAnimation,
                _rotateAnimation,
                _bounceAnimation,
                _glowAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors.first.withOpacity(_glowAnimation.value * 0.6),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ícone animado
                        AnimatedBuilder(
                          animation: _rotateAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotateAnimation.value * 2 * math.pi,
                              child: Transform.scale(
                                scale: _bounceAnimation.value,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getIcon(),
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Título
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Subtítulo
                        Text(
                          widget.subtitle,
                          style: GoogleFonts.robotoMono(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Botão de fechar
                        GestureDetector(
                          onTap: _dismiss,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Continuar',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para mostrar celebração simples
class SimpleCelebration extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;
  final Duration duration;

  const SimpleCelebration({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<SimpleCelebration> createState() => _SimpleCelebrationState();
}

class _SimpleCelebrationState extends State<SimpleCelebration>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0),
    ));

    _controller.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.message,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Funções utilitárias para mostrar celebrações
class CelebrationUtils {
  static void showSuccess(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationOverlay(
        type: CelebrationType.success,
        title: 'Sucesso!',
        subtitle: message,
      ),
    );
  }

  static void showAchievement(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationOverlay(
        type: CelebrationType.achievement,
        title: title,
        subtitle: description,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showLevelUp(BuildContext context, String level) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationOverlay(
        type: CelebrationType.levelUp,
        title: 'Level Up!',
        subtitle: 'Você alcançou o nível $level!',
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showPerfect(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationOverlay(
        type: CelebrationType.perfect,
        title: 'Perfeito!',
        subtitle: 'Pontuação perfeita!',
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showStreak(BuildContext context, int days) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationOverlay(
        type: CelebrationType.streak,
        title: 'Sequência!',
        subtitle: '$days dias consecutivos!',
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showMilestone(BuildContext context, String milestone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationOverlay(
        type: CelebrationType.milestone,
        title: 'Marco Alcançado!',
        subtitle: milestone,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showSimpleSuccess(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleCelebration(
        message: message,
        icon: Icons.check_circle,
        color: AppColors.successGradient.first,
      ),
    );
  }

  static void showSimpleError(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleCelebration(
        message: message,
        icon: Icons.error,
        color: AppColors.errorGradient.first,
      ),
    );
  }
}
