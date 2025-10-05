import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para o Clipboard
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart'; // Tema mais moderno
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

class IfElseScreenC extends StatelessWidget {
  const IfElseScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Condicionais em C',
      ),
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
                        icon: Icons.alt_route,
                        title: 'Tomando Decisões no Código',
                        content:
                            'Estruturas condicionais são como uma bifurcação na estrada para o seu programa. Usando if, else if e else, ele pode analisar uma condição e decidir qual caminho seguir, executando blocos de código diferentes para cada situação.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
// Exemplo básico de if/else
#include <stdio.h>

int main() {
    int idade = 20;

    if (idade >= 18) { // Se esta condição for verdadeira...
        printf("Você é maior de idade.\\n"); // ...execute este bloco.
    } else { // Caso contrário...
        printf("Você é menor de idade.\\n"); // ...execute este outro.
    }

    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.format_list_numbered,
                        title: 'Múltiplas Condições com "else if"',
                        content:
                            'Para verificar várias condições em sequência, use o "else if". O programa testará cada condição na ordem e executará o primeiro bloco que encontrar cuja condição seja verdadeira.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
// Exemplo com múltiplas condições
#include <stdio.h>

int main() {
    int nota = 75;

    if (nota >= 90) {
        printf("Conceito A\\n");
    } else if (nota >= 80) {
        printf("Conceito B\\n");
    } else if (nota >= 70) { // Esta condição é a primeira verdadeira!
        printf("Conceito C\\n"); // O programa imprime isso e para.
    } else {
        printf("Conceito D\\n");
    }

    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.compare_arrows,
                        title: 'Operadores de Comparação',
                        content: 'Essas são as ferramentas que você usará dentro dos parênteses do `if` para criar suas condições.',
                      ),
                      const SizedBox(height: 16),
                      _OperatorGrid(operators: const [
                        ['==', 'Igual a'],
                        ['!=', 'Diferente de'],
                        ['>', 'Maior que'],
                        ['<', 'Menor que'],
                        ['>=', 'Maior ou igual a'],
                        ['<=', 'Menor ou igual a'],
                      ]),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.join_full,
                        title: 'Operadores Lógicos',
                        content: 'Use-os para criar condições mais complexas, combinando duas ou mais verificações.',
                      ),
                      const SizedBox(height: 16),
                      _OperatorGrid(operators: const [
                        ['&&', 'E (AND)'],
                        ['||', 'OU (OR)'],
                        ['!', 'NÃO (NOT)'],
                      ]),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.code,
                        title: 'Dica Pro: O Operador Ternário',
                        content:
                            'Para atribuições condicionais simples, o operador ternário (?:) é uma alternativa elegante e compacta ao if/else.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int idade = 21;
    // condição ? valor_se_verdadeiro : valor_se_falso;
    const char* status = (idade >= 18) ? "Maior de idade" : "Menor de idade";

    printf("Status: %s\\n", status); // Imprime "Status: Maior de idade"
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.electric_bolt,
                        title: 'Alternativa: A Estrutura `switch`',
                        content:
                            'Quando você precisa comparar uma única variável com múltiplos valores constantes, a estrutura `switch` é mais limpa e, muitas vezes, mais eficiente que vários `if-else if`.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int dia = 3;
    switch (dia) {
        case 1: printf("Domingo\\n"); break;
        case 2: printf("Segunda\\n"); break;
        case 3: printf("Terça\\n"); break; // Encontra a correspondência aqui
        default: printf("Dia inválido\\n"); break;
    }
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.warning_amber_rounded,
                        title: 'Pontos Cruciais',
                        content:
                            '● Cuidado para não confundir `=` (atribuição) com `==` (comparação) dentro de um `if`.\n● As chaves `{}` são opcionais se o bloco de código tiver apenas uma linha, mas usá-las sempre é uma boa prática para evitar bugs.',
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


// --- Widgets de Suporte Refatorados ---

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
      color: const Color(0xFF282c34), // Cor base do tema atom-one-dark
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


class _OperatorGrid extends StatelessWidget {
  final List<List<String>> operators;

  const _OperatorGrid({required this.operators});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: operators.map((op) {
          return Chip(
            backgroundColor: AppColors.primary,
            label: Text(op[0]),
            labelStyle: GoogleFonts.robotoMono(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
            side: BorderSide(color: AppColors.accent.withOpacity(0.5)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}