import 'package:flutter/material.dart';

enum Difficulty { iniciante, basico, intermediario, avancado }

class CodeCompletionTask {
  final String id;
  final String? title;
  final String description;
  final String code;
  final List<String> options;
  final int correctOptionIndex;
  final String feedbackCorrect;
  final String feedbackIncorrect;
  late List<String> shuffledOptions;
  late int shuffledCorrectIndex;

  CodeCompletionTask({
    required this.id,
    this.title,
    required this.description,
    required this.code,
    required this.options,
    required this.correctOptionIndex,
    required this.feedbackCorrect,
    required this.feedbackIncorrect,
  }) {
    _shuffleOptions();
  }

  void _shuffleOptions() {
    // Cria uma lista de índices
    List<int> indices = List.generate(options.length, (i) => i);
    // Embaralha os índices
    indices.shuffle();

    // Cria a lista de opções embaralhadas
    shuffledOptions = List.generate(options.length, (i) => options[indices[i]]);

    // Encontra o novo índice da resposta correta
    shuffledCorrectIndex = indices.indexOf(correctOptionIndex);
  }

  // Método para reembaralhar as opções
  void reshuffle() {
    _shuffleOptions();
  }
}

class CodeCompletionLevel {
  final int id;
  final String title;
  final String description;
  final Difficulty difficulty;
  final List<CodeCompletionTask> tasks;
  final bool isLocked;
  final String theme;
  final String content;
  final String feedbackSuccess;
  final String feedbackFailure;

  const CodeCompletionLevel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.tasks,
    this.isLocked = true,
    required this.theme,
    required this.content,
    this.feedbackSuccess =
        "Parabéns! Você completou todas as tarefas com sucesso! Continue praticando para se tornar um mestre em Python!",
    this.feedbackFailure =
        "Ops! Você ainda não acertou todas as tarefas. Não desanime, tente novamente e aprenda com seus erros!",
  });
}

// Dados dos níveis
final List<CodeCompletionLevel> codeCompletionLevels = [
  CodeCompletionLevel(
  id: 1,
  title: 'Variáveis em C',
  description: 'Aprenda os conceitos fundamentais sobre variáveis em C.',
  difficulty: Difficulty.iniciante,
  theme: 'Tipos de dados, declaração e inicialização',
  content:
      'O que são variáveis, como declará-las, os diferentes tipos de dados e a importância da inicialização em C.',
  isLocked: false,
  feedbackSuccess:
      "Muito bem! Você entendeu os conceitos iniciais sobre variáveis em C!",
  feedbackFailure:
      "Não desanime! Revise os conceitos básicos de variáveis e tente novamente!",
  tasks: [
    CodeCompletionTask(
      id: '1_1',
      description: 'O que é uma variável em C?',
      code: '',
      options: [
        'Um tipo de dado que nunca muda',
        'Um espaço nomeado na memória para armazenar valores',
        'Uma palavra-chave reservada para funções',
        'Um tipo especial de constante'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Excelente! Em C, uma variável é uma abstração para uma localização de memória que possui um nome simbólico (identificador) e armazena um valor que pode ser modificado durante a execução do programa.',
      feedbackIncorrect:
          'Não foi desta vez, mas a persistência é a chave para a programação. Releia a definição fundamental de variáveis e você chegará lá!',
    ),
    CodeCompletionTask(
      id: '1_2',
      description:
          'Qual é a forma correta de declarar uma variável inteira em C?',
      code: '',
      options: [
        'int = idade;',
        'idade int;',
        'inteiro idade;',
        'int idade;'
      ],
      correctOptionIndex: 3,
      feedbackCorrect: 'Perfeito! A sintaxe de declaração em C segue estritamente a ordem `tipo_de_dado identificador;`. `int` especifica o tipo e `idade` é o nome da variável.',
      feedbackIncorrect:
          'Quase lá! A sintaxe em C é muito precisa. Analise a ordem dos elementos na declaração de uma variável e tente novamente.',
    ),
    CodeCompletionTask(
      id: '1_3',
      description: 'O que a linha faz?',
      code: 'char letra = \'A\';',
      options: [
        'Declara uma variável chamada `letra` do tipo caractere e a inicializa com o valor \'A\'.',
        'Atribui o valor \'A\' a uma variável chamada `char`.',
        'Gera um erro de sintaxe.',
        'Declara uma função que retorna um caractere.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Isso mesmo! Esta linha executa duas operações essenciais: a declaração, que aloca memória para a variável `letra` do tipo `char`, e a inicialização, que atribui o valor literal \'A\' a esse espaço de memória.',
      feedbackIncorrect:
          'Continue tentando! Analise cada parte da instrução: o tipo, o nome, o operador de atribuição e o valor. O entendimento virá com a prática.',
    ),
    CodeCompletionTask(
      id: '1_4',
      description:
          'Em C, qual é a principal diferença entre uma variável do tipo `int` e uma do tipo `float`?',
      code: '',
      options: [
        '`int` armazena números decimais e `float` armazena números inteiros.',
        'Ambos armazenam números inteiros, mas `float` é mais rápido.',
        '`int` armazena números inteiros e `float` armazena números com ponto flutuante (decimais).',
        '`int` e `float` são exatamente a mesma coisa.'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! A distinção é fundamental: `int` (integer) destina-se a números inteiros, enquanto `float` (floating-point) é usado para representar números reais, que podem ter casas decimais, seguindo o padrão de ponto flutuante IEEE 754.',
      feedbackIncorrect:
          'A jornada do aprendizado tem seus desafios. Pense na natureza dos números que cada tipo de dado precisa representar. Você está no caminho certo!',
    ),
    CodeCompletionTask(
      id: '1_5',
      description:
          'Qual das opções abaixo NÃO é um nome válido para uma variável em C?',
      code: '',
      options: ['idade_aluno', '1_idade', 'minhaIdade', 'MAX_VALOR'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exato! As regras de nomenclatura de identificadores em C especificam que eles devem começar com uma letra ou um sublinhado (_), nunca com um dígito numérico. Iniciar com um número viola essa regra sintática do compilador.',
      feedbackIncorrect:
          'Cada erro é um aprendizado. Lembre-se das regras para nomear variáveis em C. Revise o material e tente identificar qual opção não segue o padrão.',
    ),
  ],
),

CodeCompletionLevel(
  id: 2,
  title: 'Variáveis e Tipos em C',
  description:
      'Explore os tipos de dados fundamentais em C, como inteiros, pontos flutuantes e caracteres.',
  difficulty: Difficulty.iniciante,
  theme: 'Declaração, Tipos de Dados e Inicialização',
  content:
      'Aprenda a declarar variáveis com tipos como int, float e char, e como inicializá-las com valores para uso em seus programas.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você demonstrou um bom entendimento dos tipos de dados e variáveis em C!",
  feedbackFailure:
      "Não desanime! A base de C está nos tipos e variáveis. Revise os conceitos e tente novamente!",
  tasks: [
    CodeCompletionTask(
      id: '2_1',
      description:
          'Como você declararia uma variável inteira chamada `pontuacao` e a inicializaria com o valor 100 em C?',
      code: '',
      options: [
        'pontuacao = 100;',
        'integer pontuacao = 100;',
        'int pontuacao = 100;',
        'pontuacao int = 100;'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! A sintaxe em C exige a especificação do tipo (`int`), seguida pelo nome da variável (`pontuacao`), o operador de atribuição (`=`) e o valor inicial (`100`), finalizando com um ponto e vírgula.',
      feedbackIncorrect:
          'Opa, a sintaxe não está exata. Lembre-se que em C, toda variável precisa ter seu tipo de dado definido explicitamente antes do nome. Continue tentando!',
    ),
    CodeCompletionTask(
      id: '2_2',
      description:
          'Qual tipo de dado é o mais apropriado para armazenar o valor `3.14159` em C?',
      code: '',
      options: ['int', 'char', 'float', 'boolean'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exato! O tipo `float` é projetado para armazenar números de ponto flutuante (decimais). O tipo `int` armazena apenas inteiros e `char` armazena caracteres únicos.',
      feedbackIncorrect:
          'Pense bem sobre a natureza do número. Ele é um inteiro ou possui casas decimais? A escolha do tipo de dado correto é fundamental em C.',
    ),
    CodeCompletionTask(
      id: '2_3',
      description:
          'No código, o que `%d` representa?',
      code: 'int idade = 25; printf("Minha idade é %d", idade);',
      options: [
        'Uma string literal que será impressa',
        'Um especificador de formato para um número inteiro (int)',
        'Um erro de sintaxe que precisa ser corrigido',
        'Um especificador de formato para um caractere (char)'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Perfeito! `%d` é um especificador de formato usado pela função `printf` para indicar que um argumento do tipo `int` deve ser inserido naquele ponto da string no formato decimal.',
      feedbackIncorrect:
          'Não desista! Cada símbolo na string de formato de `printf` tem um propósito especial. Investigue o que os símbolos de porcentagem (%) significam nessa função.',
    ),
    CodeCompletionTask(
      id: '2_4',
      description:
          'Qual das opções a seguir declara e inicializa corretamente uma variável para armazenar a letra \'C\'?',
      code: '',
      options: [
        'char letra = "C";',
        'character letra = \'C\';',
        'string letra = "C";',
        'char letra = \'C\';'
      ],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Correto! Em C, o tipo de dado para um único caractere é `char`, e os literais de caractere são definidos com aspas simples (\'\'). Aspas duplas ("") são usadas para strings (vetores de caracteres).',
      feedbackIncorrect:
          'Atenção aos detalhes! Em C, tanto o nome do tipo de dado para caracteres quanto a forma como você escreve o valor (com aspas simples ou duplas) são muito importantes.',
    ),
    CodeCompletionTask(
      id: '2_5',
      description:
          'É possível declarar e inicializar múltiplas variáveis do mesmo tipo em uma única linha em C?',
      code: '',
      options: [
        'Não, cada variável deve ser declarada em sua própria linha.',
        'Sim, mas apenas se elas não forem inicializadas.',
        'Sim, usando vírgulas para separar as variáveis, como em: `int a = 1, b = 2;`',
        'Não, isso sempre causa um erro de compilação.'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exatamente! C permite uma sintaxe concisa para declarar e/ou inicializar múltiplas variáveis do mesmo tipo em uma única instrução, separando cada declarador com uma vírgula.',
      feedbackIncorrect:
          'Explore as diferentes formas de sintaxe da linguagem. C oferece algumas maneiras de tornar o código mais conciso. Continue investigando!',
    ),
  ],
),

  CodeCompletionLevel(
  id: 3,
  title: 'Variáveis em C - Tópicos Intermediários',
  description:
      'Aprofunde seu conhecimento em C explorando modificadores de tipo, o operador `sizeof`, constantes e o ciclo de vida de variáveis estáticas.',
  difficulty: Difficulty.intermediario,
  theme: 'Modificadores de Tipo, sizeof, const, static',
  content:
      'Entenda como os modificadores `unsigned` e `long` alteram os tipos de dados, como `sizeof` mede o uso de memória e a diferença de comportamento das palavras-chave `const` e `static`.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você demonstrou um conhecimento sólido sobre aspectos mais profundos das variáveis em C!",
  feedbackFailure:
      "Não desanime! Estes são conceitos mais complexos. A revisão e a prática levarão à maestria!",
  tasks: [
    CodeCompletionTask(
      id: '3_1',
      description:
          'Qual é a principal vantagem de declarar uma variável como `unsigned int` em vez de `int`?',
      code: '',
      options: [
        'Ela pode armazenar números negativos com maior precisão.',
        'Ela ocupa menos espaço na memória que um `int` padrão.',
        'Ela pode armazenar apenas valores positivos, dobrando o limite máximo positivo.',
        'A compilação do código se torna significativamente mais rápida.'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exato! O modificador `unsigned` remove o bit de sinal, permitindo que a variável represente apenas valores não-negativos. Isso efetivamente dobra o intervalo de valores positivos que o tipo pode armazenar, em detrimento dos negativos.',
      feedbackIncorrect:
          'Pense no significado da palavra "unsigned" (sem sinal). Como a ausência de um sinal negativo afeta o intervalo de números que a variável pode representar?',
    ),
    CodeCompletionTask(
      id: '3_2',
      description:
          'O que a expressão retorna na maioria das arquiteturas de sistema?',
      code: 'sizeof(char)',
      options: [
        'O valor ASCII do caractere.',
        'O tamanho em bytes do tipo `char` (que é sempre 1).',
        'O número de bits em um caractere (geralmente 8).',
        'Um ponteiro para o endereço da variável.'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! O operador `sizeof` retorna o tamanho de um tipo de dado ou variável em bytes. Por definição na linguagem C, `sizeof(char)` é sempre 1, servindo como a unidade base para a medição de memória no sistema.',
      feedbackIncorrect:
          'Não confunda o valor de uma variável com o espaço que ela ocupa. O operador `sizeof` está interessado no tamanho em memória, e a unidade padrão para isso em C são os bytes.',
    ),
    CodeCompletionTask(
      id: '3_3',
      description:
          'O que a palavra-chave `const` faz na declaração?',
      code: 'const float PI = 3.14;',
      options: [
        'Torna a variável `PI` global para todo o programa.',
        'Aloca `PI` em um tipo especial de memória mais rápida.',
        'Indica que o valor de `PI` não pode ser alterado após a inicialização.',
        'Converte `PI` para um tipo de dupla precisão (`double`).'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! A palavra-chave `const` é um qualificador de tipo que define a variável como "somente leitura". Qualquer tentativa de modificar seu valor após a inicialização resultará em um erro de compilação.',
      feedbackIncorrect:
          'A palavra `const` é uma abreviação de "constant". Pense no que significa algo ser constante no mundo real. Como isso se aplicaria a uma variável em programação?',
    ),
    CodeCompletionTask(
      id: '3_4',
      description:
          'No código, qual valor será armazenado na variável `x`?',
      code: 'int x = (int)9.9;',
      options: [
        '10 (arredondamento para o inteiro mais próximo)',
        '9 (a parte fracionária é truncada)',
        'Um erro de compilação, pois `int` não armazena decimais.',
        '0 (a conversão falha e retorna um valor padrão)'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Isso mesmo! Ao fazer um type cast explícito de um tipo de ponto flutuante (`double` ou `float`) para um `int`, a parte fracionária do número é simplesmente descartada (truncada), não arredondada. Portanto, `9.9` se torna `9`.',
      feedbackIncorrect:
          'A conversão de um número decimal para um inteiro em C segue uma regra específica. A linguagem arredonda o valor para cima ou simplesmente ignora a parte fracionária? Revise o conceito de truncamento.',
    ),
    CodeCompletionTask(
      id: '3_5',
      description:'Qual será o valor impresso de `contador` no código abaixo?' ,
      code: '''
#include <stdio.h>

int main() {
    static int contador = 0; 
    
    contador++;
    printf("Primeira vez: %d\\n", contador);
    
    {
        contador++;
        printf("Segunda vez: %d\\n", contador);
    }
    
    return 0;
}
''',
      options: [
          'Primeira vez: 1 / Segunda vez: 1 (reinicializa a cada bloco)',
          'Primeira vez: 1 / Segunda vez: 2 (valor persiste no mesmo programa)',
          'Primeira vez: 0 / Segunda vez: 1 (a inicialização acontece duas vezes)',
          'O compilador gera erro, pois static não pode ser usado dentro de main'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Excelente! A palavra-chave `static`, quando usada em uma variável local, altera sua "duração de armazenamento". A variável passa a existir durante toda a execução do programa, mantendo seu valor entre as chamadas da função, embora seu escopo de visibilidade permaneça local à função.',
      feedbackIncorrect:
          'A palavra `static` aqui altera o "tempo de vida" da variável, mas não seu "escopo" (onde ela pode ser vista). Pense em como uma variável poderia "lembrar" seu valor da última vez que a função foi executada.',
    ),
  ],
),

CodeCompletionLevel(
  id: 4,
  title: '+ Variáveis em C ',
  description:
      'Domine os conceitos!!!',
  difficulty: Difficulty.avancado,
  theme: 'Revisão',
  content:
      'Aprenda a diferença entre escopo local e global, o propósito das classes de armazenamento e o uso de qualificadores como `volatile`.',
  isLocked: false,
  feedbackSuccess:
      "Parabéns! Você demonstrou um ótimo entendimento sobre como o C gerencia o escopo e o armazenamento de variáveis!",
  feedbackFailure:
      "Calma! Estes são alguns dos conceitos mais teóricos de C. Revise os materiais sobre escopo e classes de armazenamento e tente de novo!",
  tasks: [
    CodeCompletionTask(
      id: '4_1',
      description:
          'Qual será o valor impresso de `contador` no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    static int contador = 5; 
    
    printf("Primeira vez: %d\\n", contador);
    
    {
        contador++;
        printf("Segunda vez: %d\\n", contador);
    }

    {
        contador += 2;
        printf("Terceira vez: %d\\n", contador);
    }
    
    return 0;
}
''',
      options: [
        'Primeira vez: 5 / Segunda vez: 6 / Terceira vez: 8 (valor persiste dentro de main)',
        'Primeira vez: 5 / Segunda vez: 5 / Terceira vez: 5 (reinicializa a cada bloco)',
        'Primeira vez: 0 / Segunda vez: 1 / Terceira vez: 3 (a inicialização acontece duas vezes)',
        'Erro de compilação, static não pode ser usado dentro de main'
        ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Mandando bem!!',
      feedbackIncorrect:
          'Quase lá!!',
    ),
    CodeCompletionTask(
      id: '4_2',
      description:
          'Observe o código abaixo. Qual será o valor de `x` impresso?',
      code: '''
#include <stdio.h>

int x = 10; // variável global

int main() {
    extern int x;
    x += 5;
    printf("%d\\n", x);
    return 0;
}
''',
      options: [
        '10',
        '5',
        '15',
        'Erro de compilação'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! `extern int x;` informa que a variável global `x` já foi definida em outro lugar. O valor é atualizado para 15.',
      feedbackIncorrect:
          'Lembre-se que `extern` apenas declara a existência de uma variável global definida fora do escopo da função.',
    ),
    CodeCompletionTask(
      id: '4_3',
      description:
          'Qual será o valor de `global` se nenhuma inicialização for feita?',
      code: '''
#include <stdio.h>

int global; // variável global sem inicialização

int main() {
    printf("%d\\n", global);
    return 0;
}
''',
      options: [
        'Valor indefinido',
        '0',
        '-1',
        'Erro de compilação'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Perfeito! Variáveis globais sem inicialização explícita são inicializadas com 0.',
      feedbackIncorrect:
          'Variáveis globais têm duração de armazenamento estática, então o compilador inicializa elas automaticamente com 0.',
    ),
    CodeCompletionTask(
      id: '4_4',
      description:
          'Analise o código abaixo. Qual é a intenção da palavra-chave `register`?',
      code: '''
#include <stdio.h>

int main() {
    register int contador = 5;
    contador++;
    printf("%d\\n", contador);
    return 0;
}
''',
      options: [
        'Armazenar a variável em RAM',
        'Sugerir ao compilador que a variável seja armazenada em registrador para acesso rápido',
        'Variável será compartilhada entre arquivos',
        'Variável terá valor aleatório para segurança'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! `register` sugere ao compilador armazenar a variável em um registrador da CPU para otimizar o acesso.',
      feedbackIncorrect:
          'Pense em onde a CPU pode acessar dados mais rapidamente que a RAM. Isso é o que `register` sugere.',
    ),
    CodeCompletionTask(
      id: '4_5',
      description:
          'Qual será o comportamento do código abaixo e por que usamos `volatile`?',
      code: '''
#include <stdio.h>

int main() {
    volatile int sensor = 0;

    // Imagine que o valor de sensor muda externamente
    sensor = 100;
    printf("%d\\n", sensor);

    return 0;
}
''',
      options: [
        'Valor nunca muda',
        'Valor pode mudar externamente e o compilador não deve otimizar o acesso',
        'Valor é armazenado em registrador',
        'Variável será removida da memória rapidamente'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exatamente! `volatile` indica que a variável pode mudar fora do controle do programa, evitando otimizações perigosas.',
      feedbackIncorrect:
          'Pense em hardware ou interrupções que mudam a variável sem que o compilador perceba.',
    ),
  ],
),


 CodeCompletionLevel(
  id: 5,
  title: 'Lógica e Veracidade em C',
  description:
      'Entenda como a linguagem C representa valores lógicos e aprenda a usar os operadores relacionais e lógicos.',
  difficulty: Difficulty.iniciante,
  theme: 'Operadores Lógicos, Veracidade (Truthiness), Operadores Relacionais',
  content:
      'C trata o inteiro 0 como falso e qualquer outro valor como verdadeiro. Aprenda a usar os operadores && (E), || (OU), ! (NÃO) e operadores de comparação para criar expressões lógicas.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você compreendeu como a lógica e as comparações funcionam em C!",
  feedbackFailure:
      "Não foi dessa vez! Revise como C interpreta verdadeiro/falso e o papel dos operadores lógicos.",
  tasks: [
    CodeCompletionTask(
      id: '5_1',
      description:
          'Qual valor será considerado "falso" no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int a = 0;
    if (a) {
        printf("Verdadeiro\\n");
    } else {
        printf("Falso\\n");
    }
    return 0;
}
''',
      options: [
        '0 (zero)',
        '1',
        '-1',
        'NULL'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Exato! Em C, o valor inteiro 0 é tratado como falso em expressões lógicas.',
      feedbackIncorrect:
          'Lembre-se: C considera 0 como falso e qualquer outro valor como verdadeiro.',
    ),
    CodeCompletionTask(
      id: '5_2',
      description:
          'Qual será o resultado da expressão `(5 > 3) && (0)` no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int resultado = (5 > 3) && (0);
    printf("%d\\n", resultado);
    return 0;
}
''',
      options: [
        '1 (verdadeiro)',
        '0 (falso)',
        'true',
        'Erro de compilação'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! `(5 > 3)` é 1, mas o operador && exige que ambos os lados sejam verdadeiros. Como o segundo lado é 0 (falso), o resultado final é 0.',
      feedbackIncorrect:
          'Analise cada parte. O operador && (E lógico) só retorna verdadeiro se ambos os lados forem verdadeiros.',
    ),
    CodeCompletionTask(
      id: '5_3',
      description:
          'Qual operador em C retorna 1 se **pelo menos uma** das expressões for verdadeira?',
      code: '''
#include <stdio.h>

int main() {
    int x = 1;
    int y = 0;
    int resultado = x || y;
    printf("%d\\n", resultado);
    return 0;
}
''',
      options: [
        '&',
        '&&',
        '||',
        '|'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! O operador || (OU lógico) retorna verdadeiro (1) se pelo menos uma das expressões for diferente de zero.',
      feedbackIncorrect:
          'Não confunda com operadores bit a bit (&, |). Procure pelo operador lógico que representa "OU".',
    ),
    CodeCompletionTask(
      id: '5_4',
      description:
          'Qual será o valor de `resultado` ao usar o operador de negação `!`?',
      code: '''
#include <stdio.h>

int main() {
    int x = 0;
    int resultado = !x;
    printf("%d\\n", resultado);
    return 0;
}
''',
      options: [
        '-1',
        '0',
        '1',
        'NULL'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! x é 0 (falso), e !x inverte o valor lógico. A negação de falso é verdadeiro, que em C é 1.',
      feedbackIncorrect:
          'O operador ! inverte o valor lógico. Se x é falso, !x será verdadeiro, representado por qual inteiro?',
    ),
    CodeCompletionTask(
      id: '5_5',
      description:
          'Qual será o valor inteiro da expressão `(10 == 10)` em C?',
      code: '''
#include <stdio.h>

int main() {
    int resultado = (10 == 10);
    printf("%d\\n", resultado);
    return 0;
}
''',
      options: [
        '10',
        '0',
        'true',
        '1'
      ],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Excelente! Operadores relacionais retornam 1 se a comparação for verdadeira, e 0 se for falsa.',
      feedbackIncorrect:
          'O resultado de uma comparação não é o valor comparado, mas sim um valor que representa verdadeiro (1) ou falso (0).',
    ),
  ],
),


// 6 

 CodeCompletionLevel(
  id: 6,
  title: 'Strings em C',
  description:
      'Aprenda como a linguagem C manipula strings, que são arrays de caracteres terminados por um caractere nulo (`\\0`).',
  difficulty: Difficulty.intermediario,
  theme: 'Arrays de Caracteres, Caractere Nulo, Funções de String',
  content:
      'Descubra a representação de strings em C, como declará-las, a importância do terminador nulo `\\0` e como usar funções básicas para manipulá-las.',
  isLocked: false,
  feedbackSuccess:
      "Perfeito! Você dominou os conceitos fundamentais sobre strings em C!",
  feedbackFailure:
      "Não se preocupe! Strings em C são um conceito novo. Revise como elas funcionam e tente novamente.",
  tasks: [
    CodeCompletionTask(
      id: '6_1',
      description: 'Como o C representa uma string na memória?',
      code: '''
#include <stdio.h>

int main() {
    char texto[] = "Olá";
    printf("%c %c %c\\n", texto[0], texto[1], texto[2]);
    return 0;
}
''',
      options: [
        'Como um tipo primitivo chamado string',
        'Como um objeto da biblioteca padrão',
        'Como um array de caracteres (`char`) terminado pelo caractere nulo `\\0`',
        'Como uma lista ligada de caracteres'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exatamente! C não possui um tipo string nativo; strings são arrays de char com terminador nulo.',
      feedbackIncorrect:
          'Lembre-se que cada caractere ocupa uma posição no array e que o fim da string é indicado pelo `\\0`.',
    ),
    CodeCompletionTask(
      id: '6_2',
      description: 'Qual é o papel do caractere nulo `\\0`?',
      code: '''
#include <stdio.h>

int main() {
    char texto[] = {'O', 'l', 'á', '\\0'};
    printf("%s\\n", texto);
    return 0;
}
''',
      options: [
        'Faz a string ser impressa em negrito',
        'Indica onde a string termina na memória',
        'Conta o número de caracteres da string',
        'Não tem importância e é opcional'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Perfeito! O `\\0` sinaliza o fim da string para funções como printf.',
      feedbackIncorrect:
          'Sem o terminador nulo, printf não saberia onde parar de ler na memória, podendo ler lixo.',
    ),
    CodeCompletionTask(
      id: '6_3',
      description: 'Qual declaração inicializa corretamente uma string?',
      code: '''
#include <stdio.h>

int main() {
    char saudacao[] = "Olá";
    printf("%s\\n", saudacao);
    return 0;
}
''',
      options: [
        'string saudacao = "Olá";',
        'char saudacao = "Olá";',
        'char saudacao[] = {\'O\', \'l\', \'á\'};',
        'char saudacao[] = "Olá";'
      ],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Correto! O compilador adiciona automaticamente o `\\0` no final.',
      feedbackIncorrect:
          'Lembre-se que strings em C são arrays de caracteres. A terceira opção não inclui o terminador nulo.',
    ),
    CodeCompletionTask(
      id: '6_4',
      description: 'Qual especificador de formato é usado para imprimir uma string?',
      code: '''
#include <stdio.h>

int main() {
    char texto[] = "Oi";
    printf("%s\\n", texto);
    return 0;
}
''',
      options: ['%c', '%d', '%s', '%f'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exato! `%s` é usado para strings. `%c` seria apenas um caractere.',
      feedbackIncorrect:
          'Lembre-se: `%d` é inteiro, `%f` é float, `%c` é caractere único. Para uma sequência de caracteres, use `%s`.',
    ),
    CodeCompletionTask(
      id: '6_5',
      description: 'Qual função retorna o comprimento de uma string (sem contar `\\0`)?',
      code: '''
#include <stdio.h>
#include <string.h>

int main() {
    char texto[] = "Olá";
    printf("%lu\\n", strlen(texto));
    return 0;
}
''',
      options: ['sizeof()', 'length()', 'strsize()', 'strlen()'],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Correto! `strlen()` percorre a string até o `\\0` e retorna o número de caracteres visíveis.',
      feedbackIncorrect:
          'O operador sizeof() mede o tamanho do array em bytes, incluindo o `\\0`. A função que mede apenas os caracteres é `strlen()`.',
    ),
  ],
),




 CodeCompletionLevel(
  id: 7,
  title: 'Entrada e Saída Padrão em C',
  description:
      'Aprenda a exibir dados com `printf()` e a ler entradas do usuário com `scanf()` em C.',
  difficulty: Difficulty.intermediario,
  theme: 'Saída com printf, Entrada com scanf, Format Specifiers',
  content:
      'Explore as funções da biblioteca `<stdio.h>` para interagir com o usuário, exibindo informações formatadas no console e lendo dados do teclado.',
  isLocked: false,
  feedbackSuccess:
      "Muito bem! Você compreendeu os conceitos básicos de entrada e saída em C!",
  feedbackFailure:
      "Não desanime! Dominar `printf` e `scanf` é um passo fundamental. Revise os conceitos e tente novamente!",
  tasks: [
    CodeCompletionTask(
      id: '7_1',
      description:
          'Qual função imprime informações formatadas no console no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int idade = 20;
    printf("Idade: %d\\n", idade);
    return 0;
}
''',
      options: ['scanf()', 'puts()', 'printf()', 'cout()'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! `printf` envia texto e valores de variáveis formatados para a saída padrão (console).',
      feedbackIncorrect:
          'Lembre-se: `printf` significa "print formatted". Qual função faz isso em C?',
    ),
    CodeCompletionTask(
      id: '7_2',
      description:
          'Qual função lê dados formatados do teclado no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int idade;
    scanf("%d", &idade);
    printf("Você digitou: %d\\n", idade);
    return 0;
}
''',
      options: ['printf()', 'gets()', 'cin()', 'scanf()'],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Exato! `scanf` lê dados da entrada padrão e armazena nas variáveis indicadas.',
      feedbackIncorrect:
          'Enquanto `printf` imprime, a função que lê dados digitados é `scanf`.',
    ),
    CodeCompletionTask(
      id: '7_3',
      description:
          'Por que usamos o operador `&` em `scanf("%d", &idade);`?',
      code: '''
#include <stdio.h>

int main() {
    int idade;
    scanf("%d", &idade);
    printf("%d\\n", idade);
    return 0;
}
''',
      options: [
        'Para indicar que a variável é uma string',
        'É opcional e serve apenas para clareza',
        'Para passar o endereço de memória da variável, permitindo que scanf altere seu valor',
        'Para converter automaticamente para inteiro'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! `scanf` precisa do endereço da variável para armazenar o valor digitado.',
      feedbackIncorrect:
          'Lembre-se que a função precisa saber *onde na memória* guardar o valor digitado.',
    ),
    CodeCompletionTask(
      id: '7_4',
      description:
          'Qual é a forma correta de exibir uma variável com texto no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int idade = 25;
    // Complete a linha para mostrar "Idade: 25"
    return 0;
}
''',
      options: [
        'printf("Idade: " + idade);',
        'printf("Idade: %d", idade);',
        'printf("Idade: {idade}");',
        'puts("Idade: ", idade);'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! `%d` é o marcador para inteiros, e a variável é passada como argumento.',
      feedbackIncorrect:
          'Em C, não usamos "+" para concatenar strings e números. `%d` é o correto para inteiros.',
    ),
    CodeCompletionTask(
      id: '7_5',
      description:
          'Qual cabeçalho deve ser incluído para usar `printf` e `scanf`?',
      code: '''
#include <_____>

int main() {
    int idade;
    scanf("%d", &idade);
    printf("%d\\n", idade);
    return 0;
}
''',
      options: [
        '#include <stdlib.h>',
        '#include <string.h>',
        '#include <stdio.h>',
        '#include <math.h>'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Isso mesmo! `stdio.h` contém as funções de Entrada e Saída Padrão.',
      feedbackIncorrect:
          'Pense na sigla "Standard Input/Output". Qual biblioteca corresponde a isso?',
    ),
  ],
),


CodeCompletionLevel(
  id: 8,
  title: 'Operadores em C',
  description:
      'Aprenda a usar os operadores aritméticos, de atribuição, relacionais e de incremento/decremento em C para manipular dados.',
  difficulty: Difficulty.intermediario,
  theme: 'Aritméticos, Atribuição, Relacionais, Incremento',
  content:
      'Explore como realizar cálculos, atribuir valores, comparar dados e incrementar/decrementar variáveis usando os operadores fundamentais da linguagem C.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você demonstrou um bom domínio sobre os operadores da linguagem C!",
  feedbackFailure:
      "Revise os operadores com atenção! Entendê-los bem é essencial para escrever qualquer programa em C.",
  tasks: [
    CodeCompletionTask(
      id: '8_1',
      description: 'Qual será o resultado da operação módulo (%) no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int resto = 10 % 3;
    printf("%d\\n", resto);
    return 0;
}
''',
      options: ['1', '3', '3.33', '0'],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O operador % retorna o resto da divisão inteira. 10 dividido por 3 tem resto 1.',
      feedbackIncorrect:
          'Lembre-se que % não calcula a divisão, apenas o que sobra. Qual é o resto de 10 dividido por 3?',
    ),
    CodeCompletionTask(
      id: '8_2',
      description:
          'Qual será o valor da variável `resultado` no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    float resultado = 5 / 2;
    printf("%f\\n", resultado);
    return 0;
}
''',
      options: ['2.5', '2.0', '3.0', 'Erro de compilação'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exato! 5 e 2 são inteiros, então 5 / 2 resulta em divisão inteira (2). Depois é convertido para float, tornando 2.0.',
      feedbackIncorrect:
          'Em C, a divisão de dois inteiros descarta a parte decimal, mesmo que o resultado seja armazenado em float.',
    ),
    CodeCompletionTask(
      id: '8_3',
      description:
          'A expressão `x += 5;` é equivalente a qual outra expressão?',
      code: '''
#include <stdio.h>

int main() {
    int x = 10;
    x += 5;
    printf("%d\\n", x);
    return 0;
}
''',
      options: [
        'x = 5;',
        '5 = x + 5;',
        'x = x + 5;',
        'x = x * 5;'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! O operador += soma o valor à direita ao valor atual da variável e armazena de volta em x.',
      feedbackIncorrect:
          'O operador += é um atalho. Pense em como escrever a mesma operação sem o atalho.',
    ),
    CodeCompletionTask(
      id: '8_4',
      description:
          'Qual será o valor da variável `i` após a execução do código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int i = 10;
    i++;
    printf("%d\\n", i);
    return 0;
}
''',
      options: ['10', '11', '9', 'Indefinido'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! i++ incrementa a variável em 1. i passa de 10 para 11.',
      feedbackIncorrect:
          'O operador ++ é o pós-incremento. Ele adiciona 1 à variável. Qual será o novo valor?',
    ),
    CodeCompletionTask(
      id: '8_5',
      description:
          'Qual é a principal diferença entre `=` e `==` em C?',
      code: '',
      options: [
        'Não há diferença, são intercambiáveis',
        '`==` é atribuição e `=` é comparação',
        '`=` atribui valor e `==` compara valores',
        '`==` só pode ser usado em if, `=` fora'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Excelente! `=` é atribuição, `==` é comparação. É uma distinção fundamental em C.',
      feedbackIncorrect:
          'Um operador dá valor a uma variável; o outro verifica se dois valores são iguais. Qual é qual?',
    ),
  ],
),


CodeCompletionLevel(
  id: 9,
  title: 'Exemplos Práticos de Entrada e Saída em C',
  description:
      'Aplique seus conhecimentos de `printf` e `scanf` para criar programas interativos e formatar saídas no console.',
  difficulty: Difficulty.intermediario,
  theme: 'Formatação com printf, Interatividade, Escape Sequences',
  content:
      'Combine `scanf` para ler dados do usuário e `printf` com múltiplos especificadores e sequências de escape (`\\n`, `\\t`) para criar saídas bem formatadas.',
  isLocked: false,
  feedbackSuccess:
      "Muito bem! Você demonstrou habilidade em criar programas interativos simples em C.",
  feedbackFailure:
      "Revise os exemplos com atenção! A prática com `printf` e `scanf` é a chave para a interatividade em C.",
  tasks: [
    CodeCompletionTask(
      id: '9_1',
      description:
          'Qual `printf` exibe corretamente o nome e a idade das variáveis abaixo?',
      code: '''
char nome[] = "Ana";
int idade = 30;
''',
      options: [
        'printf(nome, idade);',
        'printf("Nome: %s", nome, " Idade: %d", idade);',
        'printf("Nome: %s | Idade: %d", nome, idade);',
        'printf("Nome: " + nome + " | Idade: " + idade);'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! `printf` usa uma string de formato com múltiplos especificadores (%s, %d), e as variáveis são passadas na mesma ordem.',
      feedbackIncorrect:
          'Lembre-se: primeiro a string de formato, depois as variáveis correspondentes aos marcadores de lugar.',
    ),
    CodeCompletionTask(
      id: '9_2',
      description: 'Qual será a saída exata do código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    printf("Linha 1\\nLinha 2");
    return 0;
}
''',
      options: [
        'Linha 1\\nLinha 2',
        'Linha 1 Linha 2',
        'Linha 1\nLinha 2',
        'Linha 1Linha 2'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exato! A sequência de escape \\n cria uma nova linha no console, imprimindo Linha 1 e Linha 2 em linhas separadas.',
      feedbackIncorrect:
          'Pense que \\n é uma sequência de escape que move o cursor para a próxima linha.',
    ),
    CodeCompletionTask(
      id: '9_3',
      description: 'O que este programa faz?',
      code: '''
#include <stdio.h>

int main() {
    int n1, n2, soma;
    printf("Digite dois numeros: ");
    scanf("%d %d", &n1, &n2);
    soma = n1 + n2;
    printf("A soma e: %d", soma);
    return 0;
}
''',
      options: [
        'Apenas declara variáveis, mas não faz nada',
        'Lê dois números inteiros, calcula a soma e exibe o resultado',
        'Imprime a soma de dois números fixos, sem ler a entrada',
        'Causa erro de compilação por usar scanf com duas variáveis'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Perfeito! O programa solicita a entrada, lê dois números do usuário, soma-os e imprime o resultado.',
      feedbackIncorrect:
          'Analise linha por linha: printf mostra a mensagem, scanf lê a entrada, soma calcula e printf final imprime.',
    ),
    CodeCompletionTask(
      id: '9_4',
      description:
          'Qual sequência de escape é usada para inserir um caractere de tabulação horizontal?',
      code: '',
      options: ['\\n', '\\b', '\\\\', '\\t'],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Correto! \\t insere um tab, útil para alinhar texto em colunas.',
      feedbackIncorrect:
          'Lembre-se: \\n é nova linha, \\t é tabulação. Pense na tecla Tab do teclado.',
    ),
    CodeCompletionTask(
      id: '9_5',
      description:
          'Como usar scanf para ler um caractere e um número float separados por espaço?',
      code: '''
char c;
float f;
''',
      options: [
        'scanf("%c %f", c, f);',
        'scanf("%c%f", &c, &f);',
        'scanf("%s %d", &c, &f);',
        'scanf("%c %f", &c, &f);'
      ],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Exato! "%c %f" lê um caractere seguido de um float, e &c, &f passam os endereços das variáveis.',
      feedbackIncorrect:
          'Lembre-se: scanf sempre precisa do endereço das variáveis (&) e dos especificadores corretos para cada tipo.',
    ),
  ],
),


CodeCompletionLevel(
  id: 10,
  title: 'Operadores Aritméticos em C',
  description:
      'Aprofunde-se nos operadores aritméticos de C, incluindo a divisão de inteiros, o operador módulo e a ordem de precedência.',
  difficulty: Difficulty.intermediario,
  theme: 'Aritmética, Precedência, Divisão Inteira, Incremento',
  content:
      'Realize cálculos com os operadores +, -, *, / e %. Entenda a precedência de operadores e a diferença crucial entre divisão de inteiros e de ponto flutuante.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você compreendeu os detalhes dos operadores aritméticos em C.",
  feedbackFailure:
      "Revise os operadores aritméticos com atenção! Entender suas nuances é crucial para evitar bugs em cálculos.",
  tasks: [
    CodeCompletionTask(
      id: '10_1',
      description:
          'Qual será o resultado da expressão no código abaixo, considerando a precedência de operadores?',
      code: '''
#include <stdio.h>

int main() {
    int resultado = 5 + 2 * 3;
    printf("%d", resultado);
    return 0;
}
''',
      options: ['21', '11', '13', 'Erro de compilação'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exato! Multiplicação tem precedência sobre adição. 2*3=6, 5+6=11.',
      feedbackIncorrect:
          'Lembre-se da ordem de operações (PEMDAS/BODMAS). Multiplicação vem antes da adição.',
    ),
    CodeCompletionTask(
      id: '10_2',
      description:
          'Qual expressão retorna o valor de ponto flutuante 2.5?',
      code: '''
#include <stdio.h>

int main() {
    float resultado = (float)5 / 2;
    printf("%f", resultado);
    return 0;
}
''',
      options: ['5 / 2', '(float)5 / 2', '(int)(5 / 2.0)', '5 % 2'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! Ao converter 5 para float, a divisão resulta em 2.5. Sem o cast, 5/2 seria divisão inteira, resultando em 2.',
      feedbackIncorrect:
          'Para evitar a divisão inteira, pelo menos um número precisa ser float ou double. Use type casting.',
    ),
    CodeCompletionTask(
      id: '10_3',
      description:
          'Qual valor será impresso pelo printf no pós-incremento?',
      code: '''
#include <stdio.h>

int main() {
    int a = 5;
    int b = a++;
    printf("%d", b);
    return 0;
}
''',
      options: ['6', '5', '4', 'Erro de compilação'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Perfeito! a++ retorna o valor original (5) para b, depois incrementa a para 6.',
      feedbackIncorrect:
          'Lembre-se: pós-incremento (a++) usa o valor atual da variável antes de incrementá-la.',
    ),
    CodeCompletionTask(
      id: '10_4',
      description:
          'Qual valor será impresso pelo printf no pré-incremento?',
      code: '''
#include <stdio.h>

int main() {
    int a = 5;
    int b = ++a;
    printf("%d", b);
    return 0;
}
''',
      options: ['5', '7', '6', 'Erro de compilação'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exatamente! ++a incrementa a primeiro (6), e então esse valor é atribuído a b.',
      feedbackIncorrect:
          'Pré-incremento (++a) altera a variável antes de usá-la na expressão.',
    ),
    CodeCompletionTask(
      id: '10_5',
      description:
          'O que será armazenado na variável resultado_int no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    double dividendo = 7.0;
    int divisor = 2;
    int resultado_int = dividendo / divisor;
    printf("%d", resultado_int);
    return 0;
}
''',
      options: ['3.5', '3', '4', 'Erro de compilação'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! 7.0/2 = 3.5 (double). Ao armazenar em int, a parte decimal é truncada, ficando 3.',
      feedbackIncorrect:
          'Analise: a divisão gera um double, mas resultado_int é int. O que acontece com a parte decimal ao armazenar em int?',
    ),
  ],
),



CodeCompletionLevel(
  id: 11,
  title: 'Operadores de Comparação e Lógicos em C',
  description:
      'Aprenda a comparar valores e combinar condições lógicas usando os operadores de C.',
  difficulty: Difficulty.intermediario,
  theme: 'Comparação, Lógica, Curto-Circuito',
  content:
      'Operadores de comparação (`==`, `!=`, `>`, etc.) resultam em `1` (verdadeiro) ou `0` (falso). Operadores lógicos (`&&`, `||`, `!`) combinam essas condições.',
  isLocked: false,
  feedbackSuccess:
      "Muito bem! Você compreendeu como usar operadores de comparação e lógicos em C.",
  feedbackFailure:
      "Revise os operadores com atenção! Eles são a base para a tomada de decisões em qualquer programa C.",
  tasks: [
    CodeCompletionTask(
      id: '11_1',
      description:
          'Qual será o valor inteiro resultante da expressão no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int resultado = 10 > 5;
    printf("%d", resultado);
    return 0;
}
''',
      options: ['10', '5', '0', '1'],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Correto! 10 > 5 é verdadeiro e em C verdadeiro é representado pelo inteiro 1.',
      feedbackIncorrect:
          'Em C, uma comparação verdadeira retorna 1 e uma falsa retorna 0.',
    ),
    CodeCompletionTask(
      id: '11_2',
      description:
          'Qual operador lógico retorna 1 apenas se *ambas* as condições forem verdadeiras?',
      code: '''
#include <stdio.h>

int main() {
    int a = 3, b = 4;
    int res = (a < 5) && (b > 0);
    printf("%d", res);
    return 0;
}
''',
      options: ['||', '&', 'AND', '&&'],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Exatamente! && (E lógico) retorna 1 somente se ambos os lados forem verdadeiros.',
      feedbackIncorrect:
          'Não confunda && (E lógico) com & (E bit-a-bit). && é usado para lógica booleana.',
    ),
    CodeCompletionTask(
      id: '11_3',
      description:
          'Qual valor será armazenado em `resultado` após executar este código?',
      code: '''
#include <stdio.h>

int main() {
    int x = 5;
    int resultado = !x;
    printf("%d", resultado);
    return 0;
}
''',
      options: ['1', '-5', '0', '5'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! x é não-zero (verdadeiro). !x inverte para falso, que é representado pelo inteiro 0.',
      feedbackIncorrect:
          'Avalie: x é verdadeiro? O operador ! inverte o valor lógico. Qual inteiro representa falso em C?',
    ),
    CodeCompletionTask(
      id: '11_4',
      description:
          'Qual será o resultado final da expressão no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int res = (10 > 5) && (3 == 4);
    printf("%d", res);
    return 0;
}
''',
      options: ['1', '0', 'true', 'Erro de compilação'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! 10>5 é 1 (verdadeiro), 3==4 é 0 (falso). 1 && 0 resulta em 0.',
      feedbackIncorrect:
          'Avalie cada comparação separadamente. O operador && só retorna verdadeiro se ambas as partes forem verdadeiras.',
    ),
    CodeCompletionTask(
      id: '11_5',
      description:
          'Qual será o valor da variável `y` após a execução do código, considerando avaliação de curto-circuito?',
      code: '''
#include <stdio.h>

int main() {
    int x = 5;
    int y = 10;
    int res = (x == 5) || (y++);
    printf("%d", y);
    return 0;
}
''',
      options: ['11', '10', '9', '5'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exato! O operador || avalia curto-circuito: como (x==5) já é verdadeiro, y++ não é executado. y permanece 10.',
      feedbackIncorrect:
          'Lembre-se: no operador ||, se a primeira condição for verdadeira, a segunda não é avaliada. O que acontece com y nesse caso?',
    ),
  ],
),


 CodeCompletionLevel(
  id: 12,
  title: 'Estruturas Condicionais em C',
  description:
      'Aprenda a controlar o fluxo do seu programa com as estruturas `if`, `else` e `else if` em C.',
  difficulty: Difficulty.iniciante,
  theme: 'if, else, else if, Bloco de Código',
  content:
      'Use a instrução `if` para executar código apenas se uma condição for verdadeira. Combine-a com `else` e `else if` para criar lógicas de decisão complexas.',
  isLocked: false,
  feedbackSuccess:
      "Parabéns! Você compreendeu como controlar o fluxo de um programa com condicionais em C.",
  feedbackFailure:
      "Revise as estruturas condicionais. Dominar o `if` e `else` é essencial para criar programas inteligentes.",
  tasks: [
    CodeCompletionTask(
      id: '12_1',
      description:
          'Qual é a forma correta de executar um bloco de código apenas se a variável `x` for maior que 10?',
      code: '''
#include <stdio.h>

int main() {
    int x = 12;
    /* Qual a forma correta de escrever o if? */
}
''',
      options: [
        'if x > 10:',
        'if (x > 10) { /* código aqui */ }',
        'if {x > 10} /* código aqui */',
        'if x > 10 then { /* código aqui */ }'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exato! Em C, a condição do `if` deve estar entre parênteses, e o bloco a ser executado deve estar entre chaves `{}`.',
      feedbackIncorrect:
          'A sintaxe em C é rigorosa: condição em parênteses e bloco de código entre chaves.',
    ),
    CodeCompletionTask(
      id: '12_2',
      description:
          'Qual palavra-chave permite executar um bloco alternativo caso a condição do `if` seja falsa?',
      code: '''
#include <stdio.h>

int main() {
    int x = 5;
    if (x > 10) {
        printf("Maior que 10");
    } /* Qual palavra usar aqui para o caso contrário? */
}
''',
      options: ['otherwise', 'elseif', 'else', 'default'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! `else` fornece um bloco de código alternativo que será executado se a condição do `if` for falsa.',
      feedbackIncorrect:
          'Quando a condição do `if` não é atendida, usamos uma palavra-chave específica para tratar o caso contrário. Qual é?',
    ),
    CodeCompletionTask(
      id: '12_3',
      description:
          'Quando a mensagem "Fim" será impressa no código abaixo?',
      code: '''
#include <stdio.h>

int main() {
    int x = -3;
    if (x > 0)
        printf("Positivo");
    printf("Fim");
    return 0;
}
''',
      options: [
        'Apenas se x > 0',
        'Apenas se x <= 0',
        'Sempre, independente do valor de x',
        'O código não compila sem chaves'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! Sem chaves, o `if` controla apenas a primeira instrução. `printf("Fim");` será executado sempre.',
      feedbackIncorrect:
          'Lembre-se: sem `{}`, o `if` afeta apenas uma instrução imediatamente após ele.',
    ),
    CodeCompletionTask(
      id: '12_4',
      description:
          'Qual é a melhor estrutura para testar se um número é positivo, negativo ou zero?',
      code: '''
#include <stdio.h>

int main() {
    int n = 0;
    /* Qual estrutura usar? */
}
''',
      options: [
        'Vários if separados: if(...) {} if(...) {} if(...) {}',
        'Cadeia if-else if-else: if(...) {} else if(...) {} else {}',
        'If dentro de if: if(...) { if(...) {} }',
        'Somente switch pode fazer isso'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! if-else if-else é ideal para condições mutuamente exclusivas, garantindo que apenas um bloco seja executado.',
      feedbackIncorrect:
          'Para múltiplas condições onde apenas uma deve ser verdadeira, qual estrutura evita que as outras sejam avaliadas após encontrar uma verdadeira?',
    ),
    CodeCompletionTask(
      id: '12_5',
      description:
          'Dado o código abaixo, o que será impresso?',
      code: '''
#include <stdio.h>

int main() {
    int moedas = 0;
    if (moedas) {
        printf("Ganhou!");
    }
    return 0;
}
''',
      options: [
        'Ganhou!',
        '0',
        'Nada será impresso.',
        'Erro de compilação'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exatamente! Em C, if considera zero como falso. Como moedas vale 0, o bloco não é executado.',
      feedbackIncorrect:
          'Lembre-se: em C, 0 é falso e qualquer valor não-zero é verdadeiro. O que acontece quando a condição é falsa?',
    ),
  ],
),


CodeCompletionLevel(
  id: 13,
  title: '+ Estruturas Condicionais em C',
  description:
      'Explore alternativas ao `if-else`, como a instrução `switch` e o operador ternário, para tomar decisões em seu código.',
  difficulty: Difficulty.avancado,
  theme: 'switch, case, break, Operador Ternário',
  content:
      'Aprenda a usar a instrução `switch` para selecionar um entre muitos blocos de código e o operador ternário para criar condicionais concisas em uma única linha.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você está dominando as diferentes formas de controle de fluxo em C.",
  feedbackFailure:
      "Não desanime! `switch` e o operador ternário são ferramentas poderosas. Revise sua sintaxe e tente novamente.",
  tasks: [
    CodeCompletionTask(
      id: '13_1',
      description:
          'Qual estrutura condicional é mais adequada para comparar uma variável contra múltiplos valores constantes?',
      code: '''
#include <stdio.h>

int main() {
    int opcao = 2;
    /* Qual estrutura usar para testar valores 1, 2, 3, ...? */
}
''',
      options: ['if-else if-else', 'for', 'while', 'switch'],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Exato! `switch` é ideal para testar uma variável contra múltiplos valores constantes de forma limpa e eficiente.',
      feedbackIncorrect:
          'Um `if-else if` funciona, mas há uma estrutura mais específica para múltiplos casos de uma mesma variável. Qual é?',
    ),
    CodeCompletionTask(
      id: '13_2',
      description:
          'Qual é a função da palavra-chave `break` dentro de um `case` em um `switch`?',
      code: '',
      options: [
        'Encerrar o programa',
        'Pular para o próximo case',
        'Evitar execução dos cases seguintes e sair do switch',
        'É opcional e não faz nada'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! `break` evita o "fall-through", saindo do switch após executar o case correspondente.',
      feedbackIncorrect:
          'Sem `break`, o fluxo continua para os cases seguintes. Qual palavra-chave impede isso?',
    ),
    CodeCompletionTask(
      id: '13_3',
      description:
          'Qual palavra-chave define o bloco que executa se nenhum case corresponder em um switch?',
      code: '',
      options: ['else', 'otherwise', 'default', 'case all'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! `default` captura todos os valores não tratados pelos outros cases.',
      feedbackIncorrect:
          'Pense no equivalente de `else` em um switch. Qual palavra usamos para tratar todos os outros casos?',
    ),
    CodeCompletionTask(
      id: '13_4',
      description:
          'Qual das opções usa o operador ternário para substituir o código `if (nota >= 7) sit = "Aprovado"; else sit = "Reprovado";`?',
      code: 'char *sit;',
      options: [
        'sit = (nota >= 7) ? "Aprovado" : "Reprovado";',
        'sit = (nota >= 7) : "Aprovado" ? "Reprovado";',
        'sit = if (nota >= 7) "Aprovado" else "Reprovado";',
        'sit = ternario(nota >= 7, "Aprovado", "Reprovado");'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Exatamente! A sintaxe correta do operador ternário é `condição ? valor_verdadeiro : valor_falso`.',
      feedbackIncorrect:
          'O operador ternário tem formato específico: três partes, com os símbolos `?` e `:`. Qual opção segue esse padrão?',
    ),
    CodeCompletionTask(
      id: '13_5',
      description:
          'Quando a mensagem será impressa neste código aninhado?',
      code: 'if (a > 0) { if (b > 0) { printf("Ambos positivos"); } }',
      options: [
        'Quando `a` OU `b` forem positivos',
        'Apenas quando `a` E `b` forem positivos',
        'Apenas quando `a` for positivo, independentemente de `b`',
        'O código não compila, pois ifs não podem ser aninhados'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! Ambos os ifs devem ser verdadeiros. Isso equivale a `(a > 0) && (b > 0)`.',
      feedbackIncorrect:
          'O fluxo precisa passar por duas condições para chegar ao printf. Quais são elas?',
    ),
  ],
),


 CodeCompletionLevel(
  id: 14,
  title: 'Aplicações Práticas de Condicionais em C',
  description:
      'Resolva problemas práticos e analise o fluxo de código em C usando múltiplas condições e operadores lógicos.',
  difficulty: Difficulty.intermediario,
  theme: 'Lógica Combinada, Análise de Fluxo, Resolução de Problemas',
  content:
      'Combine `if`, `else if`, `else` com operadores lógicos (`&&`, `||`) para criar lógicas de decisão robustas e resolver problemas comuns de programação.',
  isLocked: false,
  feedbackSuccess:
      "Muito bem! Você sabe aplicar estruturas condicionais para resolver problemas em C.",
  feedbackFailure:
      "Revise os exemplos com calma, seguindo o fluxo de execução passo a passo. A prática leva à perfeição!",
  tasks: [
    CodeCompletionTask(
      id: '14_1',
      description: 'Qual será a saída deste código em C?',
      code: '''
int idade = 18;
if (idade >= 18) {
    printf("Maior de idade");
} else {
    printf("Menor de idade");
}''',
      options: [
        'Maior de idade',
        'Menor de idade',
        'Nada será impresso',
        'O código não compila'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! A condição `idade >= 18` é verdadeira, então o bloco do `if` é executado.',
      feedbackIncorrect:
          'Verifique se a condição `idade >= 18` é verdadeira ou falsa. Qual bloco será executado em cada caso?',
    ),
    CodeCompletionTask(
      id: '14_2',
      description: 'Se `nota = 85`, qual será a saída do programa?',
      code: '''
int nota = 85;
if (nota >= 90) {
    printf("A");
} else if (nota >= 80) {
    printf("B");
} else {
    printf("C");
}''',
      options: ['A', 'B', 'C', 'A e B'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exato! `nota >= 90` é falso, `nota >= 80` é verdadeiro, então "B" é impresso.',
      feedbackIncorrect:
          'Analise a cadeia `if-else if`. A primeira condição verdadeira determina qual bloco será executado.',
    ),
    CodeCompletionTask(
      id: '14_3',
      description:
          'Para que a mensagem "Acesso Concedido" seja impressa, o que é necessário?',
      code: '''
if (eh_admin && tem_senha_correta) {
    printf("Acesso Concedido");
}''',
      options: [
        'Que `eh_admin` OU `tem_senha_correta` seja verdadeiro.',
        'Que `eh_admin` E `tem_senha_correta` sejam verdadeiros.',
        'Que `eh_admin` seja falso.',
        'Que apenas `tem_senha_correta` seja verdadeiro.'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Perfeito! O operador `&&` exige que ambas as condições sejam verdadeiras.',
      feedbackIncorrect:
          'O operador `&&` representa a lógica "E". Ambas as condições devem ser verdadeiras para o bloco ser executado.',
    ),
    CodeCompletionTask(
      id: '14_4',
      description: 'O que este código imprimirá no console?',
      code: '''
int numero = 7;
if (numero > 0) {
    if (numero % 2 == 0) {
        printf("Positivo e par");
    } else {
        printf("Positivo e impar");
    }
} else {
    printf("Negativo ou zero");
}''',
      options: [
        'Positivo e par',
        'Positivo e impar',
        'Negativo ou zero',
        'Erro de compilação'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! `numero > 0` é verdadeiro, mas `numero % 2 == 0` é falso, então o bloco `else` interno é executado.',
      feedbackIncorrect:
          'Siga o fluxo: o número é positivo? Se sim, dentro desse bloco, ele é par ou ímpar?',
    ),
    CodeCompletionTask(
      id: '14_5',
      description: 'Qual será a saída se `char dia = \'S\';`?',
      code: '''
char dia = 'S';
if (dia == 'S' || dia == 'D') {
    printf("Fim de semana!");
} else {
    printf("Dia de semana.");
}''',
      options: [
        'Fim de semana!',
        'Dia de semana.',
        'Nada será impresso.',
        'Ocorrerá um erro.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Exatamente! `||` precisa que apenas uma condição seja verdadeira. Como `dia == \'S\'` é verdadeiro, imprime "Fim de semana!".',
      feedbackIncorrect:
          'O operador `||` representa "OU". Basta que uma das condições seja verdadeira para executar o primeiro bloco.',
    ),
  ],
),


CodeCompletionLevel(
  id: 15,
  title: 'Laços de Repetição `for` em C',
  description:
      'Aprenda a sintaxe e a lógica do laço `for` em C para executar blocos de código repetidamente.',
  difficulty: Difficulty.intermediario,
  theme: 'Sintaxe do for, Iteração, Controle de Repetição',
  content:
      'O laço `for` em C é ideal para repetir uma ação um número conhecido de vezes. Entenda suas três partes: inicialização, condição e incremento.',
  isLocked: false,
  feedbackSuccess:
      "Muito bem! Você compreendeu a estrutura e o funcionamento do laço `for` em C.",
  feedbackFailure:
      "Revise a estrutura do `for`. Entender suas três partes é a chave para dominar a repetição em C.",
  tasks: [
    CodeCompletionTask(
      id: '15_1',
      description:
          'Um laço `for` em C é composto por três partes dentro dos parênteses. Qual é a ordem correta dessas partes?',
      code: '',
      options: [
        'condição; incremento; inicialização',
        'inicialização; incremento; condição',
        'inicialização; condição; incremento',
        'condição; inicialização; incremento'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exato! A estrutura é `for (inicialização; condição; incremento)`. A inicialização ocorre uma vez, a condição é verificada antes de cada iteração, e o incremento ocorre ao final de cada iteração.',
      feedbackIncorrect:
          'A ordem é lógica: primeiro você prepara a variável (inicializa), depois define a regra para continuar (condição) e, por fim, diz como avançar para o próximo passo (incremento).',
    ),
    CodeCompletionTask(
      id: '15_2',
      description:
          'Quantas vezes a mensagem "Ola" será impressa pelo código?',
      code: 'for (i = 0; i < 5; i++) { printf("Ola"); }',
      options: ['4 vezes', '6 vezes', 'Infinitas vezes', '5 vezes'],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Correto! O laço executa para `i` igual a 0, 1, 2, 3 e 4. Quando `i` se torna 5, a condição `i < 5` se torna falsa e o laço termina. Portanto, ele executa 5 vezes.',
      feedbackIncorrect:
          'Acompanhe o valor de `i` a cada passo. O laço continua enquanto `i < 5`. Quais são os valores de `i` que satisfazem essa condição, começando do zero?',
    ),
    CodeCompletionTask(
      id: '15_3',
      description:
          'Na estrutura, quando a parte `i++` é executada?',
      code: 'for (i = 0; i < 10; i++)',
      options: [
        'Apenas uma vez, antes do laço começar.',
        'No início de cada iteração, antes da condição ser checada.',
        'No final de cada iteração, após o bloco de código ser executado.',
        'Apenas quando a condição do laço se torna falsa.'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! O fluxo do `for` é: (1) checar a condição, (2) se for verdadeira, executar o bloco de código, (3) executar a parte de incremento (`i++`), e então voltar ao passo (1) para uma nova checagem.',
      feedbackIncorrect:
          'Pense no ciclo do laço. A variável de controle precisa ser atualizada para que o laço possa eventualmente terminar. Essa atualização acontece antes ou depois de o trabalho daquela iteração ser feito?',
    ),
    CodeCompletionTask(
      id: '15_4',
      description:
          'Qual laço `for` é o mais apropriado para percorrer todos os elementos do array `int numeros[10];`?',
      code: '',
      options: [
        'for (int i = 1; i <= 10; i++)',
        'for (int i = 0; i < 10; i++)',
        'for (int i = 0; i <= 10; i++)',
        'for (int i = 10; i > 0; i++)'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Isso mesmo! Como os índices de um array de tamanho 10 vão de 0 a 9, este laço inicia em 0 e continua enquanto `i` for menor que 10 (ou seja, até `i` ser 9), percorrendo todos os índices válidos.',
      feedbackIncorrect:
          'Lembre-se que os índices de um array em C sempre começam em 0. Se um array tem 10 elementos, qual é o índice do primeiro e qual é o do último elemento?',
    ),
    CodeCompletionTask(
      id: '15_5',
      description:
          'O que o código a seguir calcula e armazena na variável `soma`?',
      code: '''
int soma = 0;
for (int i = 1; i <= 3; i++) {
    soma += i;
}''',
      options: [
        'A soma dos números de 1 a 2 (resultado 3).',
        'A soma dos números de 1 a 3 (resultado 6).',
        'O produto dos números de 1 a 3 (resultado 6).',
        'Apenas o último valor de `i` (resultado 3).'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exatamente! O laço executa para i=1, i=2 e i=3. A variável `soma` acumula esses valores: 0+1=1, 1+2=3, 3+3=6.',
      feedbackIncorrect:
          'Siga o laço passo a passo. Qual o valor de `soma` após cada iteração? Lembre-se que `+=` soma e atribui.',
    ),
  ],
),



CodeCompletionLevel(
  id: 16,
  title: 'Controle de Fluxo em Laços `for` em C',
  description:
      'Aprenda a usar `break` e `continue` para alterar a execução de laços `for` e explore o conceito de laços aninhados.',
  difficulty: Difficulty.intermediario,
  theme: 'break, continue, Laços Aninhados',
  content:
      'Use a instrução `break` para sair de um laço `for` a qualquer momento, e `continue` para pular para a próxima iteração. Aprenda a aninhar laços para criar repetições mais complexas.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você domina o controle de fluxo avançado em laços `for`.",
  feedbackFailure:
      "Revise `break`, `continue` e laços aninhados. São ferramentas poderosas para controlar repetições complexas.",
  tasks: [
    CodeCompletionTask(
      id: '16_1',
      description:
          'O que a instrução `break` faz quando encontrada dentro de um laço?',
      code: '''
for (int i = 0; i < 10; i++) {
    if (i == 5) {
        break;
    }
    printf("%d ", i);
}''',
      options: [
        'Encerra a iteração atual e pula para a próxima.',
        'Termina a execução do laço imediatamente.',
        'Reinicia o laço a partir da inicialização.',
        'Encerra o programa inteiro.'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exato! A instrução `break` interrompe a execução do laço mais interno em que se encontra, e o controle do programa passa para a primeira instrução após o laço.',
      feedbackIncorrect:
          'A palavra `break` significa "quebrar". O que ela quebra no contexto de um laço de repetição? A iteração atual ou o laço inteiro?',
    ),
    CodeCompletionTask(
      id: '16_2',
      description: 'O que a instrução `continue` faz dentro de um laço `for`?',
      code: '''
for (int i = 0; i < 5; i++) {
    if (i == 2) {
        continue;
    }
    printf("%d ", i);
}''',
      options: [
        'Interrompe o laço `for` completamente.',
        'Ignora o restante do código da iteração atual e avança para a próxima iteração.',
        'Retorna ao início da iteração atual, executando-a novamente.',
        'Causa um erro de compilação.'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! `continue` força o laço a pular para sua próxima iteração. O código restante no bloco da iteração atual não é executado, e o laço prossegue com a parte de incremento e a próxima verificação de condição.',
      feedbackIncorrect:
          'A palavra `continue` significa "continuar". No contexto de um laço, ela para o que está fazendo na iteração atual para *continuar* com a próxima iteração do ciclo.',
    ),
    CodeCompletionTask(
      id: '16_3',
      description: 'Qual será a saída do código a seguir?',
      code: '''
for (int i = 1; i <= 5; i++) {
    if (i == 3) {
        continue;
    }
    printf("%d ", i);
}''',
      options: ['1 2 3 4 5', '1 2 4 5', '1 2', '1 2 3'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Isso mesmo! O laço imprime 1 e 2. Quando `i` é 3, o `continue` é executado, pulando o `printf`. O laço então continua normalmente para as iterações 4 e 5, imprimindo seus valores.',
      feedbackIncorrect:
          'Siga o fluxo. O `printf` é executado para cada valor de `i`, *exceto* quando `i` é igual a 3, pois o `continue` pula essa parte específica. Qual será o resultado final?',
    ),
    CodeCompletionTask(
      id: '16_4',
      description: 'Qual será a saída deste laço `for`?',
      code: '''
int soma = 0;
for (int i = 1; i <= 10; i++) {
    if (soma > 5) {
        break;
    }
    soma += i;
}
printf("%d", soma);''',
      options: ['55', '10', '6', '5'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! O laço acumula a soma: i=1 -> soma=1; i=2 -> soma=3; i=3 -> soma=6. No início da próxima iteração (i=4), a condição `soma > 5` é verdadeira, o `break` é executado e o laço termina. O valor final de `soma`, que é 6, é impresso.',
      feedbackIncorrect:
          'Acompanhe o valor da `soma` a cada iteração. O laço irá parar *imediatamente* assim que a condição `soma > 5` for verdadeira. Qual será o valor da `soma` nesse exato momento?',
    ),
    CodeCompletionTask(
      id: '16_5',
      description: 'Quantas vezes o `printf` interno será executado no total?',
      code: '''
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 2; j++) {
        printf("X ");
    }
}''',
      options: ['5 vezes', '6 vezes', '3 vezes', '2 vezes'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exatamente! O laço externo executa 3 vezes (i = 0, 1, 2). Para cada uma dessas 3 execuções, o laço interno executa 2 vezes (j = 0, 1). Portanto, o `printf` é executado um total de 3 * 2 = 6 vezes.',
      feedbackIncorrect:
          'Pense na lógica: o laço de fora controla quantas vezes o laço de dentro vai rodar *por completo*. Para encontrar o total, multiplique as repetições do laço externo pelas repetições do laço interno.',
    ),
  ],
),

CodeCompletionLevel(
  id: 17,
  title: 'Laços `while` e `do-while` em C',
  description:
      'Aprenda a criar laços baseados em condições com `while` e garanta a execução ao menos uma vez com `do-while`.',
  difficulty: Difficulty.intermediario,
  theme: 'while, do-while, Condição de Parada, Loop Infinito',
  content:
      'Use o laço `while` para repetir um bloco de código enquanto uma condição for verdadeira. Entenda a diferença para o `do-while`, que executa o bloco antes de testar a condição.',
  isLocked: false,
  feedbackSuccess:
      "Ótimo! Você entende a diferença e a aplicação dos laços `while` e `do-while` em C.",
  feedbackFailure:
      "Revise os laços condicionais. Entender quando usar `while` ou `do-while` é muito importante!",
  tasks: [
    CodeCompletionTask(
      id: '17_1',
      description:
          'Qual laço de repetição em C é mais apropriado quando o número de iterações é *desconhecido* e depende de uma condição?',
      code: '',
      options: ['for', 'if', 'while', 'switch'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! O laço `while` é ideal para situações onde a repetição continua *enquanto* uma determinada condição for verdadeira, sem um contador pré-definido como no laço `for`.',
      feedbackIncorrect:
          'O laço `for` é geralmente usado para um número conhecido de repetições. Qual laço é mais flexível e se baseia apenas em uma condição ser verdadeira para continuar?',
    ),
    CodeCompletionTask(
      id: '17_2',
      description:
          'O que é essencial fazer dentro de um laço `while` para evitar que ele se torne um laço infinito?',
      code: '''
int i = 0;
while (i < 10) {
    printf("Loop...");
    // O que falta aqui para o laço terminar?
}''',
      options: [
        'Usar uma instrução `if`.',
        'Declarar a variável `i` novamente.',
        'Nada, o laço terminará sozinho.',
        'Atualizar a variável de controle da condição (ex: `i++`).'
      ],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Exatamente! A condição `i < 10` nunca se tornará falsa se o valor de `i` não for alterado. É crucial que o corpo do laço contenha uma lógica que, eventualmente, faça a condição de parada ser atingida.',
      feedbackIncorrect:
          'A condição `i < 10` é verificada a cada iteração. Se o valor de `i` nunca muda, a condição continuará sendo verdadeira para sempre. O que precisa acontecer com `i` para que o laço pare?',
    ),
    CodeCompletionTask(
      id: '17_3',
      description:
          'Qual é a principal diferença entre um laço `while` e um laço `do-while` em C?',
      code: '',
      options: [
        'O `do-while` não precisa de uma condição.',
        'O `while` sempre executa o bloco de código ao menos uma vez.',
        'O `do-while` sempre executa o bloco de código ao menos uma vez, pois a condição é testada no final.',
        'Não há diferença, são apenas sintaxes alternativas para a mesma coisa.'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! No `while`, a condição é testada *antes* da primeira execução. No `do-while`, o bloco de código é executado primeiro e a condição é testada *depois*. Isso garante que o bloco do `do-while` rode pelo menos uma vez.',
      feedbackIncorrect:
          'Observe a posição da palavra `while` e da condição em cada estrutura. Em qual delas a verificação acontece no final, depois de o código já ter rodado pelo menos uma vez?',
    ),
    CodeCompletionTask(
      id: '17_4',
      description: 'Qual será a saída do código a seguir?',
      code: '''
int i = 1;
while (i <= 3) {
    printf("%d ", i);
    i++;
}''',
      options: ['1 2 3', '1 2', '0 1 2', '1 2 3 4'],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O laço inicia com i=1. Ele imprime 1 e i vira 2. A condição é verdadeira. Imprime 2 e i vira 3. A condição é verdadeira. Imprime 3 e i vira 4. A condição `4 <= 3` se torna falsa e o laço termina.',
      feedbackIncorrect:
          'Siga o fluxo passo a passo. Acompanhe o valor de `i` e verifique a condição `i <= 3` antes de cada impressão. Não se esqueça que `i++` acontece depois da impressão.',
    ),
    CodeCompletionTask(
      id: '17_5',
      description: 'Qual será a saída deste laço `do-while`?',
      code: '''
int i = 5;
do {
    printf("%d ", i);
    i++;
} while (i < 5);''',
      options: ['5', 'Nada será impresso', '5 6 7 8 ... (laço infinito)', '6'],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Exatamente! Mesmo que a condição `i < 5` seja falsa desde o início, o laço `do-while` executa seu bloco *uma vez* antes de checar a condição. Ele imprime 5, incrementa `i` para 6, e só então testa a condição `6 < 5`, terminando o laço.',
      feedbackIncorrect:
          'Lembre-se da principal característica do `do-while`: ele sempre roda o bloco de código pelo menos uma vez, não importa qual seja a condição inicial. O que será impresso nessa primeira (e única) execução?',
    ),
  ],
),

 CodeCompletionLevel(
  id: 18,
  title: 'Manipulação de Vetores em C',
  description:
      'Aprenda a percorrer vetores, calcular seu tamanho e a trabalhar com vetores multidimensionais (matrizes) em C.',
  difficulty: Difficulty.avancado,
  theme: 'Iteração, sizeof, Vetores Multidimensionais',
  content:
      'Use laços `for` para manipular dados em vetores, o operador `sizeof` para obter o tamanho de um vetor e explore a sintaxe e o uso de vetores de duas dimensões (matrizes).',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você demonstrou um bom conhecimento sobre a manipulação de vetores e matrizes em C.",
  feedbackFailure:
      "Revise os conceitos com atenção. Dominar vetores é um passo crucial para se tornar um bom programador C.",
  tasks: [
    CodeCompletionTask(
      id: '18_1',
      description:
          'Qual será a saída do código, que imprime o terceiro elemento do vetor?',
      code: '''
int numeros[] = {10, 20, 30, 40};
printf("%d", numeros[2]);''',
      options: ['20', '30', '40', 'O código causa um erro.'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! Os índices de vetores em C começam em 0. Portanto, o índice 0 é o primeiro elemento (10), o índice 1 é o segundo (20) e o índice 2 é o terceiro (30).',
      feedbackIncorrect:
          'Lembre-se da regra de ouro em C: a indexação de vetores começa em zero. Qual é a posição que o índice `[2]` realmente representa na sequência?',
    ),
    CodeCompletionTask(
      id: '18_2',
      description:
          'Qual expressão em C é usada para calcular o número de elementos em um vetor `vet`, independentemente do seu tipo de dado?',
      code: 'int vet[] = {1, 2, 3, 4, 5};',
      options: [
        'sizeof(vet)',
        'strlen(vet)',
        'sizeof(vet) / sizeof(vet[0])',
        'vet.length'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exato! `sizeof(vet)` retorna o tamanho total do vetor em bytes, e `sizeof(vet[0])` retorna o tamanho em bytes de um único elemento. A divisão de um pelo outro resulta no número exato de elementos.',
      feedbackIncorrect:
          '`sizeof(vet)` sozinho não é suficiente, pois ele mede o espaço em memória (bytes), não a contagem de itens. Como você usaria o tamanho total e o tamanho de um único item para descobrir quantos itens cabem no total?',
    ),
    CodeCompletionTask(
      id: '18_3',
      description:
          'Qual é a sintaxe correta para declarar um vetor de duas dimensões (matriz) com 2 linhas e 3 colunas de inteiros?',
      code: '',
      options: [
        'int matriz[2, 3];',
        'int matriz[2][3];',
        'int matriz(2, 3);',
        'int matriz[2*3];'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Perfeito! A sintaxe para vetores multidimensionais em C usa colchetes separados para cada dimensão. `[2]` representa as linhas e `[3]` representa as colunas.',
      feedbackIncorrect:
          'Em C, cada dimensão de um vetor multidimensional precisa de seu próprio par de colchetes. A sintaxe `[linhas][colunas]` é o padrão a ser seguido.',
    ),
    CodeCompletionTask(
      id: '18_4',
      description:
          'Dada a matriz `int m[2][3] = {{1,2,3}, {4,5,6}};`, como você acessa o elemento com o valor 6?',
      code: '',
      options: ['m[2][3]', 'm[1][2]', 'm[6]', 'm[2][1]'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! A contagem de índices começa em 0 para ambas as dimensões. O valor 6 está na segunda linha (índice 1) e na terceira coluna (índice 2).',
      feedbackIncorrect:
          'Lembre-se que a indexação começa em 0 tanto para as linhas quanto para as colunas. O valor 6 está em qual linha (índice 0 ou 1) e em qual coluna (índice 0, 1 ou 2)?',
    ),
    CodeCompletionTask(
      id: '18_5',
      description: 'O que este código com laços aninhados faz?',
      code: '''
int matriz[2][2] = {{1,2},{3,4}};
int soma = 0;
for(int i=0; i<2; i++){
    for(int j=0; j<2; j++){
        soma += matriz[i][j];
    }
}''',
      options: [
        'Calcula a soma dos elementos da primeira linha (resultado 3).',
        'Calcula a soma de todos os elementos da matriz (resultado 10).',
        'Calcula a soma dos elementos da diagonal (resultado 5).',
        'Causa um erro, pois não se pode somar elementos de matriz assim.'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exatamente! O laço externo (`i`) itera sobre as linhas, e o laço interno (`j`) itera sobre as colunas de cada linha. A expressão `soma += matriz[i][j]` acumula o valor de cada elemento na variável `soma`, resultando na soma total (1+2+3+4 = 10).',
      feedbackIncorrect:
          'Laços aninhados são a forma padrão de percorrer uma matriz. O laço de fora percorre as linhas e o de dentro percorre as colunas. A cada passo, um elemento é adicionado à `soma`. Siga o fluxo até o final.',
    ),
  ],
),

CodeCompletionLevel(
  id: 19,
  title: '+ Tópicos de Vetores em C',
  description:
      'Explore a relação entre vetores e ponteiros, a passagem de vetores para funções e os erros mais comuns em C.',
  difficulty: Difficulty.avancado,
  theme: 'Vetores e Funções, Vetores e Ponteiros, Erros Comuns',
  content:
      'Aprenda a passar vetores como parâmetros para funções, entenda como o nome de um vetor se comporta como um ponteiro e reconheça os perigos de acessar memória fora dos limites do vetor.',
  isLocked: false,
  feedbackSuccess:
      "Ótimo! Você está aprofundando seu conhecimento em vetores e na filosofia da linguagem C.",
  feedbackFailure:
      "Revise estes conceitos com calma. Entendê-los é o que diferencia um programador C iniciante de um intermediário.",
  tasks: [
    CodeCompletionTask(
      id: '19_1',
      description:
          'Qual é a forma correta de declarar uma função `soma_vetor` que recebe um vetor de inteiros e seu tamanho?',
      code: '',
      options: [
        'int soma_vetor(int vetor, int tamanho)',
        'int soma_vetor(int vetor[], int tamanho)',
        'int soma_vetor(vetor[], tamanho)',
        'void soma_vetor(int vetor[tamanho])'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! A sintaxe padrão para receber um vetor em uma função é especificar o tipo dos elementos, o nome do parâmetro e colchetes vazios (`[]`). Como o tamanho do vetor não é passado junto, é uma convenção passá-lo como um parâmetro separado.',
      feedbackIncorrect:
          'Ao passar um vetor para uma função, você não especifica o tamanho nos colchetes do parâmetro. Você indica que é um vetor com `[]` e, por boa prática, passa o tamanho como um argumento adicional.',
    ),
    CodeCompletionTask(
      id: '19_2',
      description:
          'No código, a que a expressão `vet` é equivalente na maioria dos contextos (como ao ser passada para `printf`)?',
      code: 'int vet[10];',
      options: [
        'Ao valor do primeiro elemento, `vet[0]`.',
        'Ao tamanho do vetor, `10`.',
        'Ao endereço de memória do primeiro elemento, `&vet[0]`.',
        'Ao endereço de memória do último elemento, `&vet[9]`.'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exato! Este é um conceito fundamental em C. O nome de um vetor, na maioria das expressões, "decai" para um ponteiro para seu primeiro elemento. É por isso que `printf("%p", vet);` e `printf("%p", &vet[0]);` imprimem o mesmo endereço.',
      feedbackIncorrect:
          'Pense em como uma função "encontra" o vetor na memória. O que é passado para ela não é uma cópia de todos os elementos, mas sim a *localização* do início do vetor. Qual expressão representa essa localização?',
    ),
    CodeCompletionTask(
      id: '19_3',
      description: 'O que o código a seguir imprimirá no console?',
      code: '''
char str[] = "Casa";
str[0] = 'L';
printf("%s", str);''',
      options: [
        'Casa',
        'L',
        'Lasa',
        'O código causa um erro, pois strings são imutáveis.'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! Em C, strings declaradas como `char str[] = "..."` são vetores de caracteres mutáveis armazenados na pilha. Acessar `str[0]` permite modificar o primeiro caractere de \'C\' para \'L\', resultando na impressão de "Lasa".',
      feedbackIncorrect:
          'Lembre-se que strings em C são, fundamentalmente, vetores de `char`. Vetores em C são mutáveis. O que acontece quando você modifica o caractere na posição 0 do vetor `str`?',
    ),
    CodeCompletionTask(
      id: '19_4',
      description:
          'Após a execução do código, qual será o valor de `vet[3]`?',
      code: 'int vet[5] = {10, 20};',
      options: [
        '10',
        '20',
        'Um valor indefinido (lixo de memória).',
        '0'
      ],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Correto! Quando um vetor com duração de armazenamento estática ou automática é inicializado com menos elementos do que seu tamanho declarado, o compilador C garante que os elementos restantes sejam preenchidos com zero.',
      feedbackIncorrect:
          'A linguagem C tem uma regra específica para inicialização parcial de vetores. Se você não fornecer todos os valores, o que o compilador faz com os "espaços" restantes? Ele os deixa com lixo ou usa um valor padrão seguro?',
    ),
    CodeCompletionTask(
      id: '19_5',
      description:
          'O que acontece ao tentar executar no vetor `int vet[5];`?',
      code: 'printf("%d", vet[5]);',
      options: [
        'O programa imprime o último elemento do vetor.',
        'O programa sempre para com um erro "Index out of bounds".',
        'Ocorre um Comportamento Indefinido (Undefined Behavior), podendo ler lixo de memória, travar o programa ou parecer funcionar.',
        'O programa imprime `0` por padrão, pois é um acesso inválido.'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exatamente! Os índices válidos para `vet[5]` são de 0 a 4. Acessar o índice 5 está fora dos limites. C não verifica limites de vetores por padrão, então isso leva a um Comportamento Indefinido, um dos erros mais perigosos da linguagem.',
      feedbackIncorrect:
          'Se um vetor tem 5 elementos, qual é o último índice *válido* que ele possui? Acessar um índice além desse limite é um erro grave. A linguagem C te impede ou ela confia que você não fará isso?',
    ),
  ],
),



CodeCompletionLevel(
  id: 20,
  title: 'Funções em C',
  description:
      'Aprenda a criar e usar funções em C para organizar seu código, reutilizar lógica e tornar seus programas mais modulares.',
  difficulty: Difficulty.iniciante,
  theme: 'Definição, Chamada, Retorno, Parâmetros, Protótipos',
  content:
      'Funções são blocos de código que realizam tarefas específicas. Aprenda a definir funções com tipos de retorno e parâmetros, e a chamá-las para executar sua lógica.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você domina os conceitos fundamentais de criação e uso de funções em C.",
  feedbackFailure:
      "Revise os conceitos de funções. Elas são a base para escrever código limpo e organizado em C.",
  tasks: [
    CodeCompletionTask(
      id: '20_1',
      description:
          'Qual é a sintaxe correta para definir uma função chamada `soma` que recebe dois inteiros (`a` e `b`) e retorna a soma deles?',
      code: '',
      options: [
        'function soma(int a, int b) { return a + b; }',
        'soma(int a, int b) int { return a + b; }',
        'int soma(int a, int b) { return a + b; }',
        'def soma(a, b): return a + b'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exato! A definição de uma função em C segue a ordem: `tipo_de_retorno nome_da_funcao(lista_de_parametros) { corpo_da_funcao }`.',
      feedbackIncorrect:
          'A sintaxe em C é estrita. Lembre-se que você deve especificar o tipo de dado que a função retorna *antes* do nome da função, e os tipos de cada parâmetro.',
    ),
    CodeCompletionTask(
      id: '20_2',
      description:
          'Qual tipo de retorno uma função deve ter se ela não retorna nenhum valor (apenas executa uma ação, como imprimir na tela)?',
      code: '',
      options: ['int', 'null', 'none', 'void'],
      correctOptionIndex: 3,
      feedbackCorrect:
          'Correto! A palavra-chave `void` é usada para indicar que a função não tem um valor de retorno. Essas funções são chamadas de procedimentos.',
      feedbackIncorrect:
          'Em C, existe uma palavra-chave específica para indicar a ausência de um valor de retorno. Não é `null` nem `none`. Qual é a palavra usada para significar "vazio"?',
    ),
    CodeCompletionTask(
      id: '20_3',
      description:
          'Como você chamaria a função para executá-la?',
      code: 'void imprimir_mensagem(void)',
      options: [
        'imprimir_mensagem',
        'call imprimir_mensagem()',
        'imprimir_mensagem()',
        'exec imprimir_mensagem'
      ],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Perfeito! Para chamar (invocar) uma função em C, você simplesmente usa o nome dela seguido por parênteses `()`, passando quaisquer argumentos necessários dentro deles.',
      feedbackIncorrect:
          'A sintaxe para executar uma função é direta. Você precisa do nome dela e de um par de parênteses, mesmo que não haja argumentos para passar.',
    ),
    CodeCompletionTask(
      id: '20_4',
      description:
          'Por que é uma boa prática declarar um protótipo de função (ex: `int soma(int, int);`) no início do arquivo, antes da função `main`?',
      code: '',
      options: [
        'Para tornar a função mais rápida.',
        'Para informar ao compilador sobre a existência e a "assinatura" da função antes que ela seja usada.',
        'Não é necessário, o C encontra as funções automaticamente.',
        'Para que a função seja executada duas vezes.'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exatamente! O compilador C lê o código de cima para baixo. Um protótipo "avisa" ao compilador sobre a assinatura da função, permitindo que você a chame em `main`, mesmo que sua definição completa esteja mais abaixo no arquivo.',
      feedbackIncorrect:
          'O compilador C precisa "conhecer" uma função antes de você poder usá-la. O que você pode colocar no topo do seu código para "apresentar" a função ao compilador?',
    ),
    CodeCompletionTask(
      id: '20_5',
      description: 'Qual será a saída do programa a seguir?',
      code: '''
#include <stdio.h>

int multiplicar(int x) {
    return x * 2;
}

int main() {
    int resultado = multiplicar(5);
    printf("%d", resultado);
    return 0;
}''',
      options: ['5', '2', '10', 'A saída será "x * 2"'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! A função `main` chama `multiplicar` com o argumento 5. A função `multiplicar` recebe 5, calcula `5 * 2`, e retorna `10`. Esse valor é armazenado na variável `resultado` e depois impresso.',
      feedbackIncorrect:
          'Siga o fluxo do programa. O valor `5` é passado para a função `multiplicar`. Qual valor a função retorna? Esse valor retornado é o que será armazenado e, consequentemente, impresso.',
    ),
  ],
),
];
