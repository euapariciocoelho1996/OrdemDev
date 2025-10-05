import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. MODIFICADO: Convertido de StatelessWidget para StatefulWidget
class BotaoVidro extends StatefulWidget {
  final String texto;
  final IconData icone;
  final VoidCallback onPressed;

  const BotaoVidro({
    super.key,
    required this.texto,
    required this.icone,
    required this.onPressed,
  });

  @override
  State<BotaoVidro> createState() => _BotaoVidroState();
}

class _BotaoVidroState extends State<BotaoVidro>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  
  // MODIFICADO: A animação agora controla um valor 'double' (pixels) em vez de 'Offset'.
  // Isso nos dá um controle mais fino e direto sobre o movimento.
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // 1. DURAÇÃO AUMENTADA: De 2 para 3 segundos para um movimento mais lento e gracioso.
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      // 2. DISTÂNCIA AJUSTADA: Movimento sutil de 4 pixels para cima.
      begin: 0.0,
      end: -4.0, 
    ).animate(CurvedAnimation(
      parent: _controller,
      // 3. CURVA MAIS SUAVE: Usando 'easeInOutSine' para a aceleração e
      // desaceleração mais orgânica possível.
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(16.0),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 4. WIDGET DE ANIMAÇÃO REFATORADO:
                // Usando AnimatedBuilder para reconstruir apenas o ícone,
                // que é a abordagem mais performática.
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    // O Transform.translate aplica o movimento vertical
                    // com base no valor atual da animação.
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: child,
                    );
                  },
                  // O 'child' aqui é o Icon, que é passado para o 'builder'
                  // para não ser reconstruído desnecessariamente.
                  child: Icon(widget.icone, color: Colors.amber, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.texto,
                  style: GoogleFonts.robotoMono(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}