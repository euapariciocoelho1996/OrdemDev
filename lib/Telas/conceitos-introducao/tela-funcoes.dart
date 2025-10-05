import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class FunctionsScreenC extends StatelessWidget {
  const FunctionsScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Funções em C'),
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
                        icon: Icons.kitchen,
                        title: 'O que são Funções?',
                        content:
                            'Pense em funções como receitas reutilizáveis. São blocos de código que realizam uma tarefa específica. Em vez de reescrever os mesmos passos várias vezes, você simplesmente "chama" a receita (função) pelo nome sempre que precisar dela.',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.biotech,
                        title: 'Anatomia de uma Função',
                        content:
                            'Toda função em C possui uma estrutura básica:\n● Tipo de Retorno: O tipo de dado que a função devolve (ex: `int`, `float`, `void` se não devolver nada).\n● Nome: Como você irá chamar a função.\n● Parâmetros: (Opcional) Os "ingredientes" que a função recebe para trabalhar.\n● Corpo: O bloco de código `{...}` com as instruções a serem executadas.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

// 1. Função sem retorno (void) e sem parâmetros
void saudacao() {
    printf("Olá! Bem-vindo(a).\\n");
}

// 2. Função com retorno (int) e com parâmetros (a, b)
int somar(int a, int b) {
    return a + b; // Devolve a soma de a e b
}

int main() {
    saudacao(); // Chama a função de saudação

    int resultado = somar(10, 5); // Chama a soma e guarda o valor retornado
    printf("O resultado da soma é: %d\\n", resultado);

    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.bookmark_added,
                        title: 'Protótipos de Função',
                        content:
                            'Em C, você deve declarar uma função antes de usá-la. Se você definir sua função depois da `main`, o compilador não a conhecerá. O protótipo é uma "promessa" que você faz ao compilador, informando a assinatura da função que será definida depois.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

// Protótipo da função. Agora a main sabe que ela existe!
int multiplicar(int x, int y);

int main() {
    int resultado = multiplicar(7, 3); // Funciona!
    printf("Resultado da multiplicação: %d\\n", resultado);
    return 0;
}

// Definição completa da função
int multiplicar(int x, int y) {
    return x * y;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.copy_all,
                        title: 'Valor vs. Referência',
                        content:
                            '● Por Valor: É como dar uma FOTOCÓPIA de um dado para a função. A função pode alterar a cópia, mas o seu dado original permanece intacto.\n● Por Referência: É como dar o ENDEREÇO do seu dado. A função usa esse endereço (ponteiro) para modificar o dado original diretamente.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

// Passagem por valor (a função recebe uma cópia)
void naoAltera(int num) {
    num = 100; // Modifica apenas a cópia local
}

// Passagem por referência (a função recebe o endereço)
void altera(int *numPtr) {
    *numPtr = 100; // Modifica o valor original
}

int main() {
    int meuNumero = 10;

    naoAltera(meuNumero);
    printf("Após 'naoAltera': %d\\n", meuNumero); // Imprime 10

    altera(&meuNumero); // Passamos o endereço da variável
    printf("Após 'altera': %d\\n", meuNumero); // Imprime 100
    
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.all_inclusive,
                        title: 'Funções Recursivas',
                        content:
                            'Recursividade é a capacidade de uma função chamar a si mesma. É uma técnica poderosa para resolver problemas que podem ser divididos em subproblemas menores e idênticos, como o cálculo de um fatorial.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

// Calcula o fatorial de n (n!)
int fatorial(int n) {
    // Caso base: condição de parada para evitar loop infinito
    if (n == 0 || n == 1) {
        return 1;
    }
    // Passo recursivo: a função chama a si mesma com um problema menor
    else {
        return n * fatorial(n - 1);
    }
}

int main() {
    int num = 5;
    printf("O fatorial de %d é %d\\n", num, fatorial(num)); // 5 * 4 * 3 * 2 * 1 = 120
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