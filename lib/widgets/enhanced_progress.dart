import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../Cores/app_colors.dart';

enum ProgressType {
  linear,
  circular,
  wave,
  steps,
  skill,
  level,
}

class EnhancedProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final ProgressType type;
  final String? label;
  final String? subtitle;
  final Color? color;
  final List<Color>? gradientColors;
  final double? height;
  final bool showPercentage;
  final bool animated;
  final Duration animationDuration;
  final VoidCallback? onComplete;

  const EnhancedProgressBar({
    super.key,
    required this.progress,
    this.type = ProgressType.linear,
    this.label,
    this.subtitle,
    this.color,
    this.gradientColors,
    this.height,
    this.showPercentage = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.onComplete,
  });

  @override
  State<EnhancedProgressBar> createState() => _EnhancedProgressBarState();
}

class _EnhancedProgressBarState extends State<EnhancedProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  
  double _animatedProgress = 0.0;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));

    _progressAnimation.addListener(() {
      setState(() {
        _animatedProgress = _progressAnimation.value;
      });
      
      if (_animatedProgress >= 1.0 && widget.onComplete != null) {
        widget.onComplete!();
      }
    });

    if (widget.animated) {
      _startAnimations();
    } else {
      _animatedProgress = widget.progress;
    }
  }

  void _startAnimations() {
    _progressController.forward();
    
    if (widget.type == ProgressType.wave) {
      _waveController.repeat();
    }
    
    if (widget.progress > 0.8) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(EnhancedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _animatedProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ));
      
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case ProgressType.linear:
        return _buildLinearProgress();
      case ProgressType.circular:
        return _buildCircularProgress();
      case ProgressType.wave:
        return _buildWaveProgress();
      case ProgressType.steps:
        return _buildStepsProgress();
      case ProgressType.skill:
        return _buildSkillProgress();
      case ProgressType.level:
        return _buildLevelProgress();
    }
  }

  Widget _buildLinearProgress() {
    final colors = widget.gradientColors ?? [AppColors.primaryGradient.first, AppColors.primaryGradient.last];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label!,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.showPercentage)
                Text(
                  '${(_animatedProgress * 100).toInt()}%',
                  style: GoogleFonts.robotoMono(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        Container(
          height: widget.height ?? 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.secondaryCard,
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  // Fundo
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.secondaryCard,
                    ),
                  ),
                  
                  // Progresso
                  FractionallySizedBox(
                    widthFactor: _animatedProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: colors.first.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Efeito de brilho
                  if (_animatedProgress > 0.8)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: FractionallySizedBox(
                            widthFactor: _animatedProgress,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
        
        if (widget.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.subtitle!,
            style: GoogleFonts.robotoMono(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCircularProgress() {
    final colors = widget.gradientColors ?? AppColors.primaryGradient;
    
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Círculo de fundo
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 8,
                backgroundColor: AppColors.secondaryCard,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryCard),
              ),
            ),
            
            // Círculo de progresso
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: _animatedProgress,
                strokeWidth: 8,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(colors.first),
                strokeCap: StrokeCap.round,
              ),
            ),
            
            // Conteúdo central
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showPercentage)
                  Text(
                    '${(_animatedProgress * 100).toInt()}%',
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (widget.label != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.label!,
                    style: GoogleFonts.robotoMono(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildWaveProgress() {
    final colors = widget.gradientColors ?? AppColors.primaryGradient;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_progressAnimation, _waveAnimation]),
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            Container(
              height: widget.height ?? 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.secondaryCard,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomPaint(
                  painter: WaveProgressPainter(
                    progress: _animatedProgress,
                    waveAnimation: _waveAnimation.value,
                    colors: colors,
                  ),
                ),
              ),
            ),
            
            if (widget.showPercentage || widget.subtitle != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: GoogleFonts.robotoMono(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (widget.showPercentage)
                    Text(
                      '${(_animatedProgress * 100).toInt()}%',
                      style: GoogleFonts.robotoMono(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStepsProgress() {
    final steps = 5; // Número de etapas
    final currentStep = (_animatedProgress * steps).ceil();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        Row(
          children: List.generate(steps, (index) {
            final isCompleted = index < currentStep;
            final isActive = index == currentStep - 1;
            
            return Expanded(
              child: Row(
                children: [
                  // Círculo da etapa
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? AppColors.successGradient.first 
                          : AppColors.secondaryCard,
                      shape: BoxShape.circle,
                      border: isActive 
                          ? Border.all(color: AppColors.primaryGradient.first, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : Text(
                              '${index + 1}',
                              style: GoogleFonts.robotoMono(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  
                  // Linha conectora
                  if (index < steps - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: index < currentStep - 1 
                              ? AppColors.successGradient.first 
                              : AppColors.secondaryCard,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        
        if (widget.subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.subtitle!,
            style: GoogleFonts.robotoMono(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSkillProgress() {
    final colors = widget.gradientColors ?? AppColors.primaryGradient;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label!,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.showPercentage)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.first.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(_animatedProgress * 100).toInt()}%',
                    style: GoogleFonts.robotoMono(
                      color: colors.first,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        Container(
          height: widget.height ?? 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.secondaryCard,
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  // Fundo
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.secondaryCard,
                    ),
                  ),
                  
                  // Progresso
                  FractionallySizedBox(
                    widthFactor: _animatedProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  
                  // Efeito de nível
                  if (_animatedProgress > 0.9)
                    FractionallySizedBox(
                      widthFactor: _animatedProgress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        
        if (widget.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.subtitle!,
            style: GoogleFonts.robotoMono(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLevelProgress() {
    final colors = widget.gradientColors ?? AppColors.primaryGradient;
    final level = (_animatedProgress * 100).toInt();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.map((c) => c.withOpacity(0.1)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.first.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label ?? 'Level Progress',
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Level $level',
                  style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.secondaryCard,
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: _animatedProgress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: colors),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          if (widget.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.subtitle!,
              style: GoogleFonts.robotoMono(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class WaveProgressPainter extends CustomPainter {
  final double progress;
  final double waveAnimation;
  final List<Color> colors;

  WaveProgressPainter({
    required this.progress,
    required this.waveAnimation,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Cria gradiente
    final gradient = LinearGradient(
      colors: colors,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    
    final rect = Rect.fromLTWH(0, 0, size.width * progress, size.height);
    paint.shader = gradient.createShader(rect);

    // Desenha ondas
    final path = Path();
    final waveHeight = 10.0;
    final waveLength = size.width / 4;
    
    path.moveTo(0, size.height);
    path.lineTo(0, size.height / 2);
    
    for (double x = 0; x <= size.width * progress; x += 1) {
      final y = size.height / 2 + 
          math.sin((x / waveLength + waveAnimation * 2 * math.pi)) * waveHeight;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width * progress, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.waveAnimation != waveAnimation;
  }
}
