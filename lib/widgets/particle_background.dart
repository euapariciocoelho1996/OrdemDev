import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final bool isAnimated;
  final ParticleType particleType;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.isAnimated = true,
    this.particleType = ParticleType.circles,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _initializeParticles();
    
    if (widget.isAnimated) {
      _animationController.repeat();
    }
  }

  void _initializeParticles() {
    _particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 4 + 1,
        speed: math.Random().nextDouble() * 0.5 + 0.1,
        opacity: math.Random().nextDouble() * 0.5 + 0.1,
        color: _getRandomColor(),
        type: widget.particleType,
      ),
    );
  }

  Color _getRandomColor() {
    final colors = [
      Colors.blue.withOpacity(0.3),
      Colors.purple.withOpacity(0.3),
      Colors.cyan.withOpacity(0.3),
      Colors.pink.withOpacity(0.3),
      Colors.amber.withOpacity(0.3),
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Partículas animadas
        if (widget.isAnimated)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: _particles,
                  animationValue: _animationController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        
        // Conteúdo principal
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final Color color;
  final ParticleType type;
  double direction;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
    required this.type,
  }) : direction = math.Random().nextDouble() * 2 * math.pi;
}

enum ParticleType {
  circles,
  squares,
  stars,
  code,
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Atualiza posição da partícula
      particle.x += math.cos(particle.direction) * particle.speed * 0.01;
      particle.y += math.sin(particle.direction) * particle.speed * 0.01;
      
      // Wraps around screen
      if (particle.x < 0) particle.x = size.width;
      if (particle.x > size.width) particle.x = 0;
      if (particle.y < 0) particle.y = size.height;
      if (particle.y > size.height) particle.y = 0;
      
      // Adiciona movimento sinuoso
      final offsetX = math.sin(animationValue * 2 * math.pi + particle.x * 0.01) * 10;
      final offsetY = math.cos(animationValue * 2 * math.pi + particle.y * 0.01) * 10;
      
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;
      
      final center = Offset(
        particle.x + offsetX,
        particle.y + offsetY,
      );
      
      // Desenha partícula baseada no tipo
      switch (particle.type) {
        case ParticleType.circles:
          canvas.drawCircle(center, particle.size, paint);
          break;
        case ParticleType.squares:
          canvas.drawRect(
            Rect.fromCenter(
              center: center,
              width: particle.size * 2,
              height: particle.size * 2,
            ),
            paint,
          );
          break;
        case ParticleType.stars:
          _drawStar(canvas, center, particle.size, paint);
          break;
        case ParticleType.code:
          _drawCodeSymbol(canvas, center, particle.size, paint);
          break;
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.5;
    
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi / 5) - (math.pi / 2);
      final x1 = center.dx + outerRadius * math.cos(angle);
      final y1 = center.dy + outerRadius * math.sin(angle);
      
      final innerAngle = angle + (math.pi / 5);
      final x2 = center.dx + innerRadius * math.cos(innerAngle);
      final y2 = center.dy + innerRadius * math.sin(innerAngle);
      
      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
      }
      path.lineTo(x2, y2);
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }

  void _drawCodeSymbol(Canvas canvas, Offset center, double size, Paint paint) {
    final symbols = ['<', '>', '{', '}', '[', ']', '(', ')', ';', '='];
    final symbol = symbols[math.Random().nextInt(symbols.length)];
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: symbol,
        style: TextStyle(
          color: paint.color,
          fontSize: size * 3,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Widget específico para fundo com partículas de código
class CodeParticleBackground extends StatelessWidget {
  final Widget child;
  final int particleCount;

  const CodeParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 30,
  });

  @override
  Widget build(BuildContext context) {
    return ParticleBackground(
      particleCount: particleCount,
      particleType: ParticleType.code,
      child: child,
    );
  }
}

// Widget específico para fundo com estrelas
class StarParticleBackground extends StatelessWidget {
  final Widget child;
  final int particleCount;

  const StarParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 40,
  });

  @override
  Widget build(BuildContext context) {
    return ParticleBackground(
      particleCount: particleCount,
      particleType: ParticleType.stars,
      child: child,
    );
  }
}

// Widget para fundo com gradiente animado + partículas
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
    ],
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradiente animado
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    _animation.value,
                    1.0 - _animation.value,
                  ],
                ),
              ),
            );
          },
        ),
        
        // Partículas
        ParticleBackground(
          particleCount: 30,
          particleType: ParticleType.circles,
          child: Container(),
        ),
        
        // Conteúdo
        widget.child,
      ],
    );
  }
}

