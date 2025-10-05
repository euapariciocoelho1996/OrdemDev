import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;
import '../models/achievement_models.dart';

class AchievementBadge extends StatefulWidget {
  final Achievement achievement;
  final bool showAnimation;
  final bool isCompact;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.showAnimation = true,
    this.isCompact = false,
    this.onTap,
  });

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<AchievementBadge>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  
  late ConfettiController _confettiController;
  
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    if (widget.achievement.isUnlocked && widget.showAnimation) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _glowController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
    
    // Confetti para conquistas lendárias
    if (widget.achievement.rarity == AchievementRarity.legendary) {
      _confettiController.play();
      setState(() {
        _showConfetti = true;
      });
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Color _getRarityColor() {
    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        return Colors.brown.shade400; // Bronze
      case AchievementRarity.rare:
        return Colors.grey.shade400; // Prata
      case AchievementRarity.epic:
        return Colors.amber.shade400; // Ouro
      case AchievementRarity.legendary:
        return Colors.cyan.shade400; // Diamante
    }
  }

  List<Color> _getRarityGradient() {
    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        return [Colors.brown.shade600, Colors.brown.shade400];
      case AchievementRarity.rare:
        return [Colors.grey.shade600, Colors.grey.shade400];
      case AchievementRarity.epic:
        return [Colors.amber.shade600, Colors.amber.shade400];
      case AchievementRarity.legendary:
        return [Colors.cyan.shade600, Colors.cyan.shade400];
    }
  }

  IconData _getRarityIcon() {
    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        return Icons.star_border;
      case AchievementRarity.rare:
        return Icons.star_half;
      case AchievementRarity.epic:
        return Icons.star;
      case AchievementRarity.legendary:
        return Icons.auto_awesome;
    }
  }

  String _getRarityText() {
    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        return 'COMUM';
      case AchievementRarity.rare:
        return 'RARO';
      case AchievementRarity.epic:
        return 'ÉPICO';
      case AchievementRarity.legendary:
        return 'LENDÁRIO';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return _buildCompactBadge();
    }
    
    return _buildFullBadge();
  }

  Widget _buildCompactBadge() {
    final rarityColor = _getRarityColor();
    final rarityGradient = _getRarityGradient();
    
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_glowAnimation, _pulseAnimation, _rotateAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: widget.achievement.isUnlocked ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: rarityGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: widget.achievement.isUnlocked
                    ? [
                        BoxShadow(
                          color: rarityColor.withOpacity(_glowAnimation.value * 0.6),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
              ),
              child: Stack(
                children: [
                  // Ícone da conquista
                  Center(
                    child: AnimatedBuilder(
                      animation: _rotateAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: widget.achievement.isUnlocked
                              ? _rotateAnimation.value * 2 * math.pi
                              : 0,
                          child: Icon(
                            _getIconDataFromString(widget.achievement.iconData),
                            color: Colors.white,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Indicador de raridade
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: rarityColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        _getRarityIcon(),
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
                  
                  // Indicador de desbloqueado
                  if (!widget.achievement.isUnlocked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().scale(
      duration: 500.ms,
      curve: Curves.elasticOut,
    );
  }

  Widget _buildFullBadge() {
    final rarityColor = _getRarityColor();
    final rarityGradient = _getRarityGradient();
    
    return Stack(
      children: [
        // Confetti para conquistas lendárias
        if (_showConfetti)
          Positioned.fill(
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: math.pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.3,
              shouldLoop: false,
              colors: const [
                Colors.cyan,
                Colors.blue,
                Colors.purple,
                Colors.pink,
                Colors.yellow,
              ],
            ),
          ),
        
        GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: Listenable.merge([_glowAnimation, _pulseAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: widget.achievement.isUnlocked ? _pulseAnimation.value : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: rarityGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: widget.achievement.isUnlocked
                        ? [
                            BoxShadow(
                              color: rarityColor.withOpacity(_glowAnimation.value * 0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ícone da conquista
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getIconDataFromString(widget.achievement.iconData),
                          color: Colors.white,
                          size: 40,
                        ),
                      ).animate().scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Título da conquista
                      Text(
                        widget.achievement.title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(
                        duration: 800.ms,
                        delay: 200.ms,
                      ).slideY(begin: 0.2),
                      
                      const SizedBox(height: 8),
                      
                      // Descrição da conquista
                      Text(
                        widget.achievement.description,
                        style: GoogleFonts.robotoMono(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).animate().fadeIn(
                        duration: 800.ms,
                        delay: 400.ms,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Raridade e pontos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Raridade
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getRarityText(),
                              style: GoogleFonts.robotoMono(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          // Pontos
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.achievement.points}',
                                  style: GoogleFonts.robotoMono(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).animate().fadeIn(
                        duration: 800.ms,
                        delay: 600.ms,
                      ),
                      
                      // Data de desbloqueio
                      if (widget.achievement.isUnlocked && widget.achievement.unlockedAt != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Desbloqueado em ${_formatDate(widget.achievement.unlockedAt!)}',
                          style: GoogleFonts.robotoMono(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(
                          duration: 800.ms,
                          delay: 800.ms,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().scale(
      duration: 500.ms,
      curve: Curves.elasticOut,
    );
  }

  IconData _getIconDataFromString(String iconString) {
    switch (iconString) {
      case 'Icons.login':
        return Icons.login;
      case 'Icons.school':
        return Icons.school;
      case 'Icons.quiz':
        return Icons.quiz;
      case 'Icons.flash_on':
        return Icons.flash_on;
      case 'Icons.speed':
        return Icons.speed;
      case 'Icons.calendar_today':
        return Icons.calendar_today;
      case 'Icons.calendar_month':
        return Icons.calendar_month;
      case 'Icons.star':
        return Icons.star;
      case 'Icons.check_circle':
        return Icons.check_circle;
      case 'Icons.emoji_events':
        return Icons.emoji_events;
      case 'Icons.explore':
        return Icons.explore;
      case 'Icons.nightlight':
        return Icons.nightlight;
      case 'Icons.psychology':
        return Icons.psychology;
      case 'Icons.military_tech':
        return Icons.military_tech;
      default:
        return Icons.star;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'hoje';
    } else if (difference.inDays == 1) {
      return 'ontem';
    } else if (difference.inDays < 7) {
      return 'há ${difference.inDays} dias';
    } else if (difference.inDays < 30) {
      return 'há ${(difference.inDays / 7).floor()} semanas';
    } else {
      return 'há ${(difference.inDays / 30).floor()} meses';
    }
  }
}
