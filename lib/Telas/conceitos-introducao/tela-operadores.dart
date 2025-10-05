import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para o Clipboard
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Imports (mantenha os seus imports originais aqui)
import '../jogo-introducao/tela-niveis-intro.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

// Paleta de cores para consistência visual
class AppColors {
  static const Color background = Color(0xFF1A1A2E);
  static const Color primary = Color(0xFF16213E);
  static const Color accent = Color(0xFF00BFFF); // DeepSkyBlue
  static const Color text = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color cardBackground = Color(0xFF1F294A);
}

class OperatorsScreenC extends StatelessWidget {
  const OperatorsScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Operadores em C'),
      body: BodyContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _InfoCard(
                        icon: Icons.functions,
                        title: 'Os Verbos da Programação',
                        content:
                            'Operadores são símbolos que realizam operações em variáveis e valores. Eles são como os "verbos" da linguagem: somam, subtraem, comparam e atribuem, permitindo que seu programa execute ações e tome decisões.',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.calculate,
                        title: 'Operadores Aritméticos',
                        content:
                            'Os mais comuns, usados para realizar cálculos matemáticos. Fique atento à diferença entre divisão inteira e divisão com ponto flutuante.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int a = 10, b = 3;

    printf("Soma: %d\\n", a + b);           // 13
    printf("Subtração: %d\\n", a - b);        // 7
    printf("Multiplicação: %d\\n", a * b);  // 30
    printf("Divisão Inteira: %d\\n", a / b); // 3 (a parte decimal é truncada)
    printf("Módulo (resto): %d\\n", a % b);   // 1 (10 dividido por 3 dá 3 e resta 1)

    // Para divisão precisa, use float ou double
    float c = 10.0, d = 3.0;
    printf("Divisão Precisa: %f\\n", c / d); // 3.333333
    
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.edit,
                        title: 'Operadores de Atribuição',
                        content:
                            'São atalhos para modificar o valor de uma variável. `x += 5` é uma forma mais curta e eficiente de escrever `x = x + 5`.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int x = 10;
    printf("Valor inicial de x: %d\\n", x);

    x += 5; // x agora é 15
    printf("Após x += 5: %d\\n", x);

    x *= 2; // x agora é 30
    printf("Após x *= 2: %d\\n", x);
    
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.plus_one,
                        title: 'Incremento e Decremento',
                        content:
                            'Atalhos para adicionar ou subtrair 1. A posição do operador importa: `++x` (pré-incremento) altera o valor ANTES de usá-lo na expressão, enquanto `x++` (pós-incremento) altera DEPOIS.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int a = 5;
    int b = 5;

    // Pós-incremento: usa o valor de 'a' (5) e DEPOIS incrementa para 6
    int resultado_pos = a++; 

    // Pré-incremento: incrementa 'b' para 6 e DEPOIS usa o novo valor
    int resultado_pre = ++b; 
    
    printf("Resultado Pós: %d, a final: %d\\n", resultado_pos, a); // 5, a final: 6
    printf("Resultado Pré: %d, b final: %d\\n", resultado_pre, b); // 6, b final: 6
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.sort_by_alpha,
                        title: 'Precedência de Operadores',
                        content:
                            'A linguagem C tem uma ordem definida para resolver operações. Multiplicação e divisão (`*`, `/`) são resolvidas antes de adição e subtração (`+`, `-`). Use parênteses `()` para forçar a ordem que você deseja.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    // Sem parênteses, a multiplicação ocorre primeiro (5 * 2 = 10)
    int resultado1 = 10 + 5 * 2; // 10 + 10 = 20
    printf("Resultado 1: %d\\n", resultado1);

    // Com parênteses, forçamos a soma a ocorrer primeiro (10 + 5 = 15)
    int resultado2 = (10 + 5) * 2; // 15 * 2 = 30
    printf("Resultado 2: %d\\n", resultado2);
    
    return 0;
}
''',
                      ),
                      const SizedBox(height: 32),
                      _buildPracticeButton(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        icon: Icons.home,
        color: AppColors.accent,
        navigateTo: const HomeScreen(),
      ),
    );
  }

  Widget _buildPracticeButton(BuildContext context) {
    return Center(
      child: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, streamSnapshot) {
          return FutureBuilder<ConnectivityResult>(
            future: Connectivity().checkConnectivity(),
            builder: (context, initialSnapshot) {
              final result = streamSnapshot.data ?? initialSnapshot.data;
              final hasInternet = result != ConnectivityResult.none;

              return ElevatedButton.icon(
                onPressed: hasInternet
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const CodeCompletionLevelsScreen()),
                        )
                    : null,
                icon: Icon(hasInternet ? Icons.play_arrow : Icons.wifi_off,
                    color: AppColors.primary),
                label: Text(
                  hasInternet ? 'Quero praticar' : 'Sem conexão',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          );
        },
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3);
  }
}

// --- Widgets de Suporte (Reutilizados) ---

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoCard(
      {required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.accent, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1);
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  final String language;

  const _CodeBlock({required this.code, required this.language});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF282c34),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.toUpperCase(),
                  style: GoogleFonts.robotoMono(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18, color: Colors.white54),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado!')),
                    );
                  },
                ),
              ],
            ),
          ),
          HighlightView(
            code,
            language: language,
            theme: atomOneDarkTheme,
            padding: const EdgeInsets.all(16),
            textStyle: GoogleFonts.robotoMono(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scaleXY(begin: 0.95);
  }
}