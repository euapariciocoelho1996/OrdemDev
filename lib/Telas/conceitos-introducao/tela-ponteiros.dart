import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para o Clipboard
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Imports (mantenha os seus imports originais aqui)
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../jogo-introducao/tela-niveis-intro.dart';
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

class PointersScreen extends StatelessWidget {
  const PointersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Ponteiros em C'),
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
                        icon: Icons.location_on,
                        title: 'O CEP da Memória',
                        content:
                            'Imagine a memória do computador como uma cidade cheia de casas. Cada variável mora em uma casa com um endereço único (como um CEP). Um ponteiro é simplesmente uma variável especial que não guarda um valor comum, mas sim o "CEP" de outra variável.',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.key,
                        title: 'Operadores-Chave: `&` e `*`',
                        content:
                            '● `&` (Endereço de): É o "descobridor de CEP". Use-o na frente de uma variável para obter seu endereço de memória.\n● `*` (Desreferência): É o "carteiro". Use-o na frente de um ponteiro para acessar ou modificar o valor que vive no endereço que o ponteiro está guardando.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int idade = 25; // Uma variável comum
    int *ponteiro_para_idade; // Declara um ponteiro para um inteiro

    // O ponteiro agora guarda o "CEP" da variável 'idade'
    ponteiro_para_idade = &idade;

    printf("Valor original: %d\\n", idade);
    printf("Endereço (CEP) de 'idade': %p\\n", &idade);
    printf("O ponteiro está guardando o endereço: %p\\n", ponteiro_para_idade);

    // Usando o '*' para acessar o valor que está no endereço
    printf("Valor acessado via ponteiro: %d\\n", *ponteiro_para_idade);

    // Modificando o valor original através do ponteiro
    *ponteiro_para_idade = 30;
    printf("Novo valor de 'idade': %d\\n", idade); // O valor de 'idade' mudou!

    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.format_list_numbered,
                        title: 'Ponteiros e Arrays',
                        content:
                            'Em C, o nome de um array já funciona como um ponteiro para seu primeiro elemento. Isso torna a "aritmética de ponteiros" uma forma muito eficiente de percorrer os elementos de um array.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int notas[] = {10, 8, 9};
    int *ptr_nota = notas; // Não precisa do '&', o nome do array já é o endereço

    // Acessando os elementos com aritmética de ponteiros
    printf("Primeira nota: %d\\n", *ptr_nota);       // 10
    printf("Segunda nota: %d\\n", *(ptr_nota + 1));  // 8
    printf("Terceira nota: %d\\n", *(ptr_nota + 2)); // 9

    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                       _InfoCard(
                        icon: Icons.no_cell,
                        title: 'O Ponteiro NULO (`NULL`)',
                        content:
                            'Um ponteiro `NULL` é um ponteiro que não aponta para lugar nenhum. É uma boa prática inicializar ponteiros com `NULL` e sempre verificar se um ponteiro é `NULL` antes de tentar acessá-lo. Isso evita que seu programa tente acessar um endereço inválido e quebre (crash).',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int *ptr = NULL; // Ponteiro inicializado como nulo

    // Tentar acessar *ptr aqui causaria um erro!
    // Por isso, sempre verificamos antes:
    if (ptr != NULL) {
        printf("Valor apontado: %d\\n", *ptr);
    } else {
        printf("O ponteiro é nulo e não pode ser acessado.\\n");
    }

    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.real_estate_agent,
                        title: 'Aplicação: Alocação Dinâmica',
                        content:
                            'Ponteiros são essenciais para a alocação dinâmica com `malloc`. Essa função reserva um bloco de memória do tamanho que você precisar durante a execução do programa e te devolve o "CEP" inicial desse bloco, que você guarda em um ponteiro.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>
#include <stdlib.h> // Para malloc e free

int main() {
    int *meu_array;
    int tamanho = 5;

    // Aloca memória para 5 inteiros e guarda o endereço em 'meu_array'
    meu_array = (int*) malloc(tamanho * sizeof(int));

    // É crucial verificar se a alocação deu certo (retornou um CEP válido)
    if (meu_array == NULL) {
        printf("Falha na alocação de memória!\\n");
        return 1; // Encerra o programa com erro
    }

    // Usa a memória alocada
    for (int i = 0; i < tamanho; i++) {
        meu_array[i] = i * 10;
        printf("Elemento %d: %d\\n", i, meu_array[i]);
    }

    // Libera a memória que foi alocada para evitar vazamentos
    free(meu_array);

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