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

class LoopsScreenC extends StatelessWidget {
  const LoopsScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Laços de Repetição em C'),
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
                        icon: Icons.autorenew,
                        title: 'Automatizando Tarefas Repetitivas',
                        content:
                            'Laços (ou loops) são ferramentas para instruir o computador a executar um bloco de código várias vezes, sem que você precise reescrevê-lo. Eles continuam até que uma condição de parada seja atingida.',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.rule,
                        title: 'Quando Usar Qual Laço?',
                        content:
                            '● for: Use quando souber o número exato de repetições (ex: contar de 1 a 10, percorrer todos os itens de um array).\n● while: Use quando a repetição depender de uma condição que pode variar (ex: repetir enquanto o usuário não digitar "sair").\n● do-while: Use como o `while`, mas quando precisar garantir que o código execute pelo menos uma vez (ex: mostrar um menu de opções).',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.looks_one,
                        title: 'O Laço `for`',
                        content:
                            'É o mais estruturado, contendo três partes essenciais: `for (inicialização; condição; incremento)`. Ideal para repetições contadas.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    // 1. Inicializa i=0; 2. Repete enquanto i < 5; 3. Incrementa i a cada volta.
    for (int i = 0; i < 5; i++) {
        printf("Contagem: %d\\n", i); // Imprime de 0 a 4
    }
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.looks_two,
                        title: 'O Laço `while`',
                        content:
                            'Mais simples, ele apenas verifica uma condição antes de cada repetição. É sua responsabilidade garantir que a condição eventualmente se torne falsa para não criar um loop infinito.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int contador = 0;

    while (contador < 3) { // A condição é testada ANTES da execução
        printf("O contador é %d\\n", contador);
        contador++; // Essencial para que o loop termine!
    }
    printf("Fim do loop. Contador = %d\\n", contador);
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                       _InfoCard(
                        icon: Icons.looks_3,
                        title: 'O Laço `do-while`',
                        content:
                            'A principal diferença é que ele executa o bloco de código PRIMEIRO e só depois verifica a condição. Isso garante que o código rode no mínimo uma vez.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int i = 5;

    do {
        // Este bloco é executado mesmo que 'i' já seja 5
        printf("Valor de i: %d\\n", i);
    } while (i < 5); // A condição (falsa) só é verificada aqui

    return 0;
}
''',
                      ),
                       const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.alt_route,
                        title: 'Controlando o Fluxo: `break` e `continue`',
                        content:
                            '● break: Interrompe e sai do laço imediatamente.\n● continue: Pula a iteração atual e avança para a próxima.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    printf("Exemplo com continue (pula o número 2):\\n");
    for (int i = 0; i < 5; i++) {
        if (i == 2) {
            continue; // Pula o resto do código desta iteração
        }
        printf("%d ", i); // Imprime 0 1 3 4
    }
    printf("\\n");

    printf("Exemplo com break (para no número 5):\\n");
     for (int i = 0; i < 10; i++) {
        if (i == 5) {
            break; // Sai completamente do laço
        }
        printf("%d ", i); // Imprime 0 1 2 3 4
    }
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.warning_amber_rounded,
                        title: 'Ponto de Atenção: Loops Infinitos',
                        content:
                            'Um loop infinito ocorre quando a condição de parada nunca é atingida. Isso trava o programa. Certifique-se sempre de que a variável de controle (como `contador` no `while`) seja modificada dentro do laço.',
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