import 'package:OrdemDev/Cores/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

class MenuCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final VoidCallback onTap;
  final bool hasInternet;
  final int cardIndex; // índice do card para escolher a cor automaticamente

  const MenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.onTap,
    this.hasInternet = true,
    required this.cardIndex,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pulseController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _pulseAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Inicia animação de pulse para cartões especiais
    if (widget.title == "Algoritmos de Ordenação" ||
        widget.title == "Atividades Principais") {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.hasInternet) {
      HapticFeedback.lightImpact();
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = AppColors.getCardGradient(widget.cardIndex);

    return AnimatedBuilder(
      animation: Listenable.merge([_hoverAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _isHovered ? _hoverAnimation.value : 1.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: _handleTap,
                onTapDown: (_) {
                  setState(() {
                    _isHovered = true;
                  });
                  _hoverController.forward();
                },
                onTapUp: (_) {
                  setState(() {
                    _isHovered = false;
                  });
                  _hoverController.reverse();
                },
                onTapCancel: () {
                  setState(() {
                    _isHovered = false;
                  });
                  _hoverController.reverse();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: widget.hasInternet
                        ? [
                            BoxShadow(
                              color: gradientColors.first.withOpacity(0.0),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: gradientColors.last.withOpacity(0.0),
                              blurRadius: 40,
                              spreadRadius: 4,
                              offset: const Offset(0, 16),
                            ),
                          ]
                        : null,
                  ),
                  child: SizedBox(
                    width: 160, // 🔹 largura fixa
                    height: 200, // 🔹 altura fixa
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!widget.hasInternet) ...[
                            Icon(
                              Icons.wifi_off,
                              size: 32,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sem conexão',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ] else ...[
                            // Ícone com efeito
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                widget.icon,
                                size: 28,
                                color: Colors.white,
                              ),
                            ).animate().scale(
                                  duration: 600.ms,
                                  curve: Curves.elasticOut,
                                ),
                            const SizedBox(height: 12),
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            )
                                .animate()
                                .fadeIn(
                                  duration: 800.ms,
                                  delay: 200.ms,
                                )
                                .slideY(begin: 0.2),
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoMono(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                                .animate()
                                .fadeIn(
                                  duration: 800.ms,
                                  delay: 400.ms,
                                ),
                            const SizedBox(height: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.white.withOpacity(0.7),
                            ).animate().slideX(
                                  duration: 1000.ms,
                                  delay: 600.ms,
                                  begin: -0.5,
                                ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Estrela animada
              if (widget.title == "Algoritmos de Ordenação" ||
                  widget.title == "Atividades Principais")
                Positioned(
                  top: -16,
                  right: 20,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade400,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.shade400.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    ).animate().scale(
          duration: 300.ms,
          curve: Curves.elasticOut,
          delay: Duration(milliseconds: widget.cardIndex * 100),
        );
  }
}
