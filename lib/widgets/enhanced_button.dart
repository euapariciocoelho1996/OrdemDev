import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../Cores/app_colors.dart';

class EnhancedButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool enableHapticFeedback;

  const EnhancedButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.padding,
    this.enableHapticFeedback = true,
  });

  @override
  State<EnhancedButton> createState() => _EnhancedButtonState();
}

class _EnhancedButtonState extends State<EnhancedButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _glowAnimation;
  
  bool _isPressed = false;
  Offset? _ripplePosition;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Inicia animação de brilho contínua
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null || widget.isLoading) return;
    
    setState(() {
      _isPressed = true;
      _ripplePosition = details.localPosition;
    });
    
    _scaleController.forward();
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
    
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      _scaleController.reverse();
    }
  }

  void _handleTap() {
    if (widget.onPressed != null && !widget.isLoading) {
      widget.onPressed!();
      if (widget.enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
    }
  }

  List<Color> _getGradientColors() {
    switch (widget.type) {
      case ButtonType.primary:
        return AppColors.primaryGradient;
      case ButtonType.success:
        return AppColors.successGradient;
      case ButtonType.warning:
        return AppColors.warningGradient;
      case ButtonType.error:
        return AppColors.errorGradient;
      case ButtonType.secondary:
        return [AppColors.secondaryCard, AppColors.primaryCard];
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.success:
      case ButtonType.warning:
      case ButtonType.error:
        return Colors.white;
      case ButtonType.secondary:
        return AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();
    final textColor = _getTextColor();
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height ?? 56,
              padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(_glowAnimation.value * 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: gradientColors.last.withOpacity(_glowAnimation.value * 0.2),
                    blurRadius: 40,
                    spreadRadius: 4,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Conteúdo do botão
                  Center(
                    child: widget.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(textColor),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: textColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.text,
                                style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                  
                  // Efeito de ripple
                  if (_isPressed && _ripplePosition != null)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _rippleAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: RipplePainter(
                              center: _ripplePosition!,
                              radius: _rippleAnimation.value * 100,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().scale(
      duration: 300.ms,
      curve: Curves.elasticOut,
    );
  }
}

class RipplePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final Color color;

  RipplePainter({
    required this.center,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.center != center || oldDelegate.radius != radius;
  }
}

enum ButtonType {
  primary,
  secondary,
  success,
  warning,
  error,
}

