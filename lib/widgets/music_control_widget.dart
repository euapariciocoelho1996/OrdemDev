import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../Cores/app_colors.dart';
import '../services/background_music_service.dart';

class MusicControlWidget extends StatefulWidget {
  final bool isCompact;
  final VoidCallback? onToggle;

  const MusicControlWidget({
    super.key,
    this.isCompact = false,
    this.onToggle,
  });

  @override
  State<MusicControlWidget> createState() => _MusicControlWidgetState();
}

class _MusicControlWidgetState extends State<MusicControlWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
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

    // Inicia animações se música estiver tocando
    if (BackgroundMusicController.isPlaying) {
      _pulseController.repeat(reverse: true);
      _rotateController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void _toggleMusic() async {
    HapticFeedback.lightImpact();
    
    if (BackgroundMusicController.isEnabled) {
      await BackgroundMusicController.setEnabled(false);
      _pulseController.stop();
      _rotateController.stop();
    } else {
      await BackgroundMusicController.setEnabled(true);
      _pulseController.repeat(reverse: true);
      _rotateController.repeat();
    }
    
    setState(() {});
    widget.onToggle?.call();
  }

  void _adjustVolume(double newVolume) async {
    await BackgroundMusicController.setVolume(newVolume);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return _buildCompactWidget();
    }
    
    return _buildFullWidget();
  }

  Widget _buildCompactWidget() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotateAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: BackgroundMusicController.isPlaying ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: _toggleMusic,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: BackgroundMusicController.isEnabled
                      ? AppColors.primaryGradient
                      : [Colors.grey.shade600, Colors.grey.shade800],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGradient.first.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _rotateAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: BackgroundMusicController.isPlaying ? 
                        _rotateAnimation.value * 2 * 3.14159 : 0,
                    child: Icon(
                      BackgroundMusicController.isEnabled
                          ? Icons.music_note
                          : Icons.music_off,
                      color: Colors.white,
                      size: 20,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradient.first.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabeçalho
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _rotateAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: BackgroundMusicController.isPlaying ? 
                            _rotateAnimation.value * 2 * 3.14159 : 0,
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Música de Fundo',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _toggleMusic,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: BackgroundMusicController.isPlaying ? _pulseAnimation.value : 1.0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          BackgroundMusicController.isEnabled
                              ? Icons.volume_up
                              : Icons.volume_off,
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
          
          const SizedBox(height: 16),
          
          // Controle de volume
          if (BackgroundMusicController.isEnabled) ...[
            Row(
              children: [
                Icon(
                  Icons.volume_down,
                  color: Colors.white70,
                  size: 20,
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                      thumbColor: Colors.white,
                      overlayColor: Colors.white.withOpacity(0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: BackgroundMusicController.volume,
                      onChanged: _adjustVolume,
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                ),
                Icon(
                  Icons.volume_up,
                  color: Colors.white70,
                  size: 20,
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().scale(
      duration: 300.ms,
      curve: Curves.elasticOut,
    );
  }
}

// Widget flutuante para controle rápido de música
class FloatingMusicControl extends StatefulWidget {
  const FloatingMusicControl({super.key});

  @override
  State<FloatingMusicControl> createState() => _FloatingMusicControlState();
}

class _FloatingMusicControlState extends State<FloatingMusicControl>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      right: 16,
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: const MusicControlWidget(isCompact: true),
            ),
          );
        },
      ),
    );
  }
}
