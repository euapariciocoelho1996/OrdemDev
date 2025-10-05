import 'package:flutter/material.dart';

const String bubbleSortCode = '''
0  void bubbleSort(int v[], int n) {
1      int i, j, aux;
2      int trocou;
3      for(i = n-1; i > 0; i--) {
4          trocou = 0;
5          for(j = 0; j < i; j++) {
6              if(v[j] > v[j+1]) {
7                  aux = v[j];
8                  v[j] = v[j+1];
9                  v[j+1] = aux;
10                 trocou = 1;
11             }
12         }
13         if(!trocou) break; 
14     }
15 }
''';

 const String selectionSortCode = '''
0  #include <stdio.h>
1
2  void selecao(int vet[], int tam) {
3      int i, j, min_idx, temp;
4
5      for (i = 0; i < tam - 1; i++) {
6          min_idx = i;
7
8          for (j = i + 1; j < tam; j++) {
9              if (vet[j] < vet[min_idx]) {
10                 min_idx = j; // Encontrou um novo menor, atualiza o índice
11             }
12         }
13
14         temp = vet[min_idx];
15         vet[min_idx] = vet[i];
16         vet[i] = temp;
17     }
18 }
''';

const String insertionSortCode = '''
0  void insercao(int vet[], int tam) {
1      int i, j, x;
2
3      for (i = 1; i < tam; i++) {
4          x = vet[i];
5          j = i - 1;
6
7          while (j >= 0 && vet[j] > x) {
8              vet[j + 1] = vet[j];
9              j--;
10         }
11
12         vet[j + 1] = x;
13     }
14 }
''';

const String quickSortCode = '''
0  
1  void swap(int* a, int* b) {
2      int temp = *a;
3      *a = *b;
4      *b = temp;
5  }
6
7  // Função de particionamento (Lomuto)
8  // Posiciona o pivô no lugar certo e move os menores para a esquerda
9  int particionar(int vet[], int esq, int dir) {
10     int pivo = vet[dir]; 
11     int i = (esq - 1);   
12
13     for (int j = esq; j <= dir - 1; j++) {
14         // Se o elemento atual é menor ou igual ao pivô
15         if (vet[j] <= pivo) {
16             i++; 
17             swap(&vet[i], &vet[j]);
18         }
19     }
20     swap(&vet[i + 1], &vet[dir]);
21     return (i + 1);
22 }
23
24 
25 void quicksort(int vet[], int esq, int dir) {
26     if (esq < dir) {
27         // pi é o índice de particionamento, vet[pi] está no lugar certo
28         int pi = particionar(vet, esq, dir);
29
30         
31         quicksort(vet, esq, pi - 1);
32         quicksort(vet, pi + 1, dir);
33     }
34 }
''';

const String mergeSortCode = '''
0  void mergeSort(int *vetor, int posicaoInicio, int posicaoFim) {
1      int i, j, k, metadeTamanho, *vetorTemp;
2      if(posicaoInicio == posicaoFim) return;
3      metadeTamanho = (posicaoInicio + posicaoFim) / 2;
4
5      mergeSort(vetor, posicaoInicio, metadeTamanho);
6      mergeSort(vetor, metadeTamanho + 1, posicaoFim);
7
8      i = posicaoInicio;
9      j = metadeTamanho + 1;
10     k = 0;
11     vetorTemp = (int *) malloc(sizeof(int) * (posicaoFim - posicaoInicio + 1));
12
13     while(i < metadeTamanho + 1 || j < posicaoFim + 1) {
14         if (i == metadeTamanho + 1 ) { 
15             vetorTemp[k] = vetor[j];
16             j++;
17             k++;
18         }
19         else {
20             if (j == posicaoFim + 1) {
21                 vetorTemp[k] = vetor[i];
22                 i++;
23                 k++;
24             }
25             else {
26                 if (vetor[i] < vetor[j]) {
27                     vetorTemp[k] = vetor[i];
28                     i++;
29                     k++;
30                 }
31                 else {
32                     vetorTemp[k] = vetor[j];
33                     j++;
34                     k++;
35                 }
36             }
37         }
38
39     }
40     for(i = posicaoInicio; i <= posicaoFim; i++) {
41         vetor[i] = vetorTemp[i - posicaoInicio];
42     }
43     free(vetorTemp);
44 }
''';


const String heapSortCode = '''
0  void heapify(int arr[], int n, int i) {
1      int temp, maximum, left_index, right_index;
2      maximum = i;
3      right_index = 2 * i + 2;
4      left_index = 2 * i + 1;
5
6      if (left_index < n && arr[left_index] > arr[maximum])
7          maximum = left_index;
8
9      if (right_index < n && arr[right_index] > arr[maximum])
10         maximum = right_index;
11
12     if (maximum != i) {
13         temp = arr[i];
14         arr[i] = arr[maximum];
15         arr[maximum] = temp;
16         heapify(arr, n, maximum);
17     }
18 }
19
20 void heapsort(int arr[], int n) {
21     int i, temp;
22
23     for (i = n / 2 - 1; i >= 0; i--) {
24         heapify(arr, n, i);
25     }
26
27     for (i = n - 1; i > 0; i--) {
28         temp = arr[0];
29         arr[0] = arr[i];
30         arr[i] = temp;
31         heapify(arr, i, 0);
32     }
33 }
''';

enum NewContentDifficulty { iniciante, basico, intermediario, avancado }

class NewContentTask {
  final String id;
  final String title;
  final String description;
  final String content;
  final List<String> options;
  final int correctOptionIndex;
  final String feedbackCorrect;
  final String feedbackIncorrect;
  late List<String> shuffledOptions;
  late int shuffledCorrectIndex;

  NewContentTask({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.options,
    required this.correctOptionIndex,
    required this.feedbackCorrect,
    required this.feedbackIncorrect,
  }) {
    _shuffleOptions();
  }

  void _shuffleOptions() {
    List<int> indices = List.generate(options.length, (i) => i);
    indices.shuffle();
    shuffledOptions = List.generate(options.length, (i) => options[indices[i]]);
    shuffledCorrectIndex = indices.indexOf(correctOptionIndex);
  }

  void reshuffle() {
    _shuffleOptions();
  }
}

class NewContentLevel {
  final int id;
  final String title;
  final String description;
  final NewContentDifficulty difficulty;
  final List<NewContentTask> tasks;
  final bool isLocked;
  final String theme;
  final String content;
  final String feedbackSuccess;
  final String feedbackFailure;

  const NewContentLevel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.tasks,
    this.isLocked = true,
    required this.theme,
    required this.content,
    this.feedbackSuccess =
        "Parabéns! Você completou todas as tarefas com sucesso! Continue praticando!",
    this.feedbackFailure =
        "Ops! Você ainda não acertou todas as tarefas. Não desanime, tente novamente!",
  });
}

final List<NewContentLevel> newContentLevels = [
NewContentLevel(
  id: 1,
  title: 'Bubble Sort em C',
  description: 'Aprenda o funcionamento do algoritmo Bubble Sort em linguagem C',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content:
      'O Bubble Sort em C compara elementos adjacentes e os troca de posição se estiverem fora de ordem, repetindo esse processo até a lista estar ordenada. Possui uma otimização que interrompe o loop se nenhuma troca for feita durante uma passagem.',
  isLocked: false,
  feedbackSuccess:
      "Parabéns! Você dominou o Bubble Sort em C! Continue praticando com diferentes vetores.",
  feedbackFailure: "Revise o Bubble Sort em C e tente novamente!",
  tasks: [
    NewContentTask(
      id: '1_1',
      title: '',
      description: 'Analise a linha 6: `if(v[j] > v[j+1])`. O que essa linha faz?',
      content: bubbleSortCode,
      options: [
        'Compara elementos adjacentes e verifica se precisam ser trocados.',
        'Inicia o loop externo do Bubble Sort.',
        'Armazena temporariamente um valor do vetor.',
        'Finaliza a execução do Bubble Sort.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Essa linha verifica se o elemento atual é maior que o próximo e precisa ser trocado.',
      feedbackIncorrect:
          'A resposta correta é: Compara elementos adjacentes e verifica se precisam ser trocados.',
    ),
    NewContentTask(
      id: '1_2',
      title: '',
      description: 'Analise a linha 10: `trocou = 1;`. Qual é a função desta linha?',
      content: bubbleSortCode,
      options: [
        'Indicar que uma troca ocorreu durante a passagem.',
        'Parar imediatamente o loop externo.',
        'Incrementar o valor do vetor.',
        'Redefinir a variável auxiliar.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Essa linha serve para sinalizar que houve pelo menos uma troca nesta passagem.',
      feedbackIncorrect:
          'A resposta correta é: Indicar que uma troca ocorreu durante a passagem.',
    ),
    NewContentTask(
      id: '1_3',
      title: '',
      description: 'Analise a linha 13: `if(!trocou) break;`. O que acontece aqui?',
      content: bubbleSortCode,
      options: [
        'Interrompe o loop externo se nenhuma troca ocorreu.',
        'Reinicia o loop interno.',
        'Troca novamente os elementos do vetor.',
        'Calcula o próximo índice para comparação.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Se nenhuma troca foi feita, significa que o vetor já está ordenado e o loop externo é interrompido.',
      feedbackIncorrect:
          'A resposta correta é: Interrompe o loop externo se nenhuma troca ocorreu.',
    ),
    NewContentTask(
      id: '1_4',
      title: '',
      description: 'Analise o loop externo (linha 3: `for(i = n-1; i > 0; i--)`). Qual é o propósito desse loop?',
      content: bubbleSortCode,
      options: [
        'Garantir que o maior elemento de cada passagem vá para o final do vetor.',
        'Ordenar apenas os primeiros elementos do vetor.',
        'Comparar elementos não adjacentes.',
        'Inicializar a variável auxiliar.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O loop externo controla cada passagem, garantindo que o maior elemento "borbulhe" até o final.',
      feedbackIncorrect:
          'A resposta correta é: Garantir que o maior elemento de cada passagem vá para o final do vetor.',
    ),
    NewContentTask(
      id: '1_5',
      title: '',
      description: 'Analise a linha 2: `int trocou;`. Por que declaramos essa variável?',
      content: bubbleSortCode,
      options: [
        'Para verificar se houve alguma troca e otimizar o algoritmo.',
        'Para contar o número de elementos do vetor.',
        'Para armazenar temporariamente valores durante a troca.',
        'Para inicializar o loop interno.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! A variável `trocou` serve como flag para interromper o algoritmo mais cedo se o vetor já estiver ordenado.',
      feedbackIncorrect:
          'A resposta correta é: Para verificar se houve alguma troca e otimizar o algoritmo.',
    ),
  ],
),



  // 2 

NewContentLevel(
  id: 2,
  title: 'Bubble Sort em C – Complexidade e Casos',
  description:
      'Entenda os casos de complexidade, cenários favoráveis e limitações do Bubble Sort em C.',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content:
      'Aprenda como o Bubble Sort em C se comporta em diferentes situações e compreenda suas limitações, como desempenho em vetores já ordenados ou inversamente ordenados.',
  isLocked: false,
  feedbackSuccess:
      "Ótimo! Você entendeu a complexidade e os casos do Bubble Sort em C.",
  feedbackFailure:
      "Revise os conceitos de casos e complexidade do Bubble Sort em C.",
  tasks: [
    NewContentTask(
      id: '2_1',
      title: '',
      description:
          'Analise o loop interno (linha 5: `for(j = 0; j < i; j++)`). Quantas comparações são realizadas em cada passagem?',
      content: bubbleSortCode,
      options: [
        'Exatamente n comparações sempre',
        'Comparações decrescentes a cada passagem',
        'Apenas uma comparação por passagem',
        'Comparações crescentes a cada passagem'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! O loop interno diminui a quantidade de comparações a cada passagem, porque os elementos finais já estão ordenados.',
      feedbackIncorrect:
          'A resposta correta é: Comparações decrescentes a cada passagem.',
    ),
    NewContentTask(
      id: '2_2',
      title: '',
      description:
          'Analise a linha 4: `trocou = 0;`. Qual impacto desta inicialização na eficiência do Bubble Sort?',
      content: bubbleSortCode,
      options: [
        'Permite que o algoritmo identifique rapidamente vetores já ordenados',
        'Reduz o número de elementos no vetor',
        'Aumenta a complexidade para O(n³)',
        'Evita que o loop interno seja executado'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Inicializar `trocou` permite que o algoritmo pare cedo se o vetor já estiver ordenado, melhorando o desempenho no melhor caso.',
      feedbackIncorrect:
          'A resposta correta é: Permite que o algoritmo identifique rapidamente vetores já ordenados.',
    ),
    NewContentTask(
      id: '2_3',
      title: '',
      description:
          'Analise a linha 7: `aux = v[j];`. Qual é a função desta linha no contexto da complexidade de memória?',
      content: bubbleSortCode,
      options: [
        'Armazenar temporariamente um valor sem criar memória extra significativa',
        'Duplicar todo o vetor',
        'Criar uma nova lista para ordenação',
        'Aumentar a complexidade espacial para O(n²)'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! `aux` é uma variável temporária, mantendo o algoritmo in-place e com complexidade espacial O(1).',
      feedbackIncorrect:
          'A resposta correta é: Armazenar temporariamente um valor sem criar memória extra significativa.',
    ),
    NewContentTask(
      id: '2_4',
      title: '',
      description:
          'Analise o loop externo (linha 3: `for(i = n-1; i > 0; i--)`). Como ele influencia o pior caso de tempo?',
      content: bubbleSortCode,
      options: [
        'Executa n-1 passagens, contribuindo para O(n²) no pior caso',
        'Reduz o número de comparações a O(log n)',
        'Evita que o vetor seja ordenado',
        'Altera a memória usada pelo algoritmo'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Cada passagem do loop externo realiza várias comparações, resultando em complexidade O(n²) no pior caso.',
      feedbackIncorrect:
          'A resposta correta é: Executa n-1 passagens, contribuindo para O(n²) no pior caso.',
    ),
    NewContentTask(
      id: '2_5',
      title: '',
      description:
          'Analise a linha 13: `if(!trocou) break;`. Qual cenário de entrada se beneficia diretamente desta verificação?',
      content: bubbleSortCode,
      options: [
        'Vetor já ordenado',
        'Vetor completamente invertido',
        'Vetor com números aleatórios',
        'Vetor com apenas um elemento'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Quando o vetor já está ordenado, o `break` permite que o Bubble Sort termine após uma única passagem, otimizando o desempenho.',
      feedbackIncorrect:
          'A resposta correta é: Vetor já ordenado.',
    ),
  ],
),

NewContentLevel(
  id: 3,
  title: 'Bubble Sort em C – Exemplos e Vantagens',
  description:
      'Revise as vantagens, desvantagens e exemplos práticos do Bubble Sort em C.',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content:
      'Analise casos práticos de vetores em C e compreenda os pontos fortes e fracos do algoritmo Bubble Sort.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Agora você domina os exemplos e vantagens do Bubble Sort em C!",
  feedbackFailure:
      "Revise os exemplos práticos do Bubble Sort em C e tente novamente!",
  tasks: [
    NewContentTask(
      id: '3_1',
      title: '',
      description:
          'Analise a linha 1: `int i, j, aux;`. Qual é a função da variável `aux` neste exemplo prático?',
      content: bubbleSortCode,
      options: [
        'Armazenar temporariamente valores durante a troca de elementos',
        'Controlar o número de passagens do loop externo',
        'Marcar se houve troca de elementos',
        'Determinar o tamanho do vetor'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! `aux` serve para guardar temporariamente um valor enquanto os elementos são trocados.',
      feedbackIncorrect:
          'A resposta correta é: Armazenar temporariamente valores durante a troca de elementos.',
    ),
    NewContentTask(
      id: '3_2',
      title: '',
      description:
          'Analise a linha 3: `for(i = n-1; i > 0; i--)`. Qual efeito isso tem sobre os exemplos práticos?',
      content: bubbleSortCode,
      options: [
        'Determina quantas passagens completas o vetor terá, garantindo que cada maior elemento vá para o final',
        'Compara elementos aleatoriamente',
        'Interrompe o vetor no meio',
        'Inicializa todos os elementos com zero'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Cada passagem do loop externo garante que o maior elemento da passagem vá para a posição correta no final.',
      feedbackIncorrect:
          'A resposta correta é: Determina quantas passagens completas o vetor terá, garantindo que cada maior elemento vá para o final.',
    ),
    NewContentTask(
      id: '3_3',
      title: '',
      description:
          'Analise a linha 6: `if(v[j] > v[j+1])`. Em um vetor {4, 2, 7, 1}, qual par seria trocado primeiro?',
      content: bubbleSortCode,
      options: [
        '4 e 2',
        '2 e 7',
        '7 e 1',
        '2 e 1'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Na primeira comparação do loop interno, 4 é maior que 2 e será trocado primeiro.',
      feedbackIncorrect:
          'A resposta correta é: 4 e 2.',
    ),
    NewContentTask(
      id: '3_4',
      title: '',
      description:
          'Analise a linha 13: `if(!trocou) break;`. Qual é a vantagem dessa verificação em exemplos de vetores quase ordenados?',
      content: bubbleSortCode,
      options: [
        'Permite que o algoritmo termine mais cedo, evitando passagens desnecessárias',
        'Garante que todos os elementos sejam sempre comparados',
        'Aumenta o número de trocas para garantir precisão',
        'Cria uma cópia do vetor antes de ordenar'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Em vetores quase ordenados, essa verificação permite que o Bubble Sort pare cedo, tornando-o mais eficiente.',
      feedbackIncorrect:
          'A resposta correta é: Permite que o algoritmo termine mais cedo, evitando passagens desnecessárias.',
    ),
    NewContentTask(
      id: '3_5',
      title: '',
      description:
          'Analise a linha 9: `v[j+1] = aux;`. Por que isso é importante em exemplos práticos de troca de elementos?',
      content: bubbleSortCode,
      options: [
        'Para completar a troca de posição corretamente, movendo o valor armazenado em `aux`',
        'Para inicializar o vetor com valores aleatórios',
        'Para contar o número de comparações',
        'Para interromper o loop interno'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Sem esta linha, o valor guardado em `aux` não seria colocado na posição correta após a troca.',
      feedbackIncorrect:
          'A resposta correta é: Para completar a troca de posição corretamente, movendo o valor armazenado em `aux`.',
    ),
  ],
),



// SELECTION SORT

NewContentLevel(
  id: 4,
  title: 'Selection Sort em C – Conceito e Funcionamento',
  description:
      'Aprenda o que é o Selection Sort e como ele funciona passo a passo em linguagem C.',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content:
      'O Selection Sort em C seleciona repetidamente o menor elemento do vetor não ordenado e o coloca na posição correta, até ordenar todo o vetor.',
  isLocked: false,
  feedbackSuccess:
      "Parabéns! Você entendeu o conceito e funcionamento do Selection Sort em C.",
  feedbackFailure: "Revise o Selection Sort em C e tente novamente!",
  tasks: [
    NewContentTask(
      id: '4_1',
      title: '',
      description: 'Analise a linha 6: `min_idx = i;`. Qual é o objetivo desta linha?',
      content: selectionSortCode,
      options: [
        'Definir o índice inicial do menor elemento na parte não ordenada', // correta
        'Trocar elementos adjacentes',
        'Incrementar o contador do loop externo',
        'Inicializar o vetor com zeros'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! `min_idx` começa assumindo que o menor elemento da passagem é o primeiro da parte não ordenada.',
      feedbackIncorrect:
          'A resposta correta é: Definir o índice inicial do menor elemento na parte não ordenada.',
    ),
    NewContentTask(
      id: '4_2',
      title: '',
      description:
          'Analise a linha 9: `if (vet[j] < vet[min_idx])`. O que essa condição verifica?',
      content: selectionSortCode,
      options: [
        'Se o elemento atual é menor que o menor encontrado até agora', // correta
        'Se os elementos adjacentes precisam ser trocados',
        'Se o vetor está ordenado',
        'Se o loop externo deve ser interrompido'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Essa condição encontra o menor elemento na parte não ordenada do vetor.',
      feedbackIncorrect:
          'A resposta correta é: Se o elemento atual é menor que o menor encontrado até agora.',
    ),
    NewContentTask(
      id: '4_3',
      title: '',
      description:
          'Analise a linha 10: `min_idx = j;`. Qual função ela cumpre no algoritmo?',
      content: selectionSortCode,
      options: [
        'Atualiza o índice do menor elemento encontrado na passagem', // correta
        'Troca imediatamente os elementos no vetor',
        'Finaliza a execução do loop interno',
        'Conta o número de comparações realizadas'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Quando um elemento menor é encontrado, `min_idx` é atualizado para o índice desse elemento.',
      feedbackIncorrect:
          'A resposta correta é: Atualiza o índice do menor elemento encontrado na passagem.',
    ),
    NewContentTask(
      id: '4_4',
      title: '',
      description:
          'Analise as linhas 14 a 16: troca dos elementos. Qual é o propósito dessa sequência?',
      content: selectionSortCode,
      options: [
        'Colocar o menor elemento da passagem na posição correta da parte ordenada', // correta
        'Trocar todos os elementos adjacentes',
        'Incrementar o índice do loop externo',
        'Reiniciar a ordenação do vetor'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O menor elemento encontrado é trocado com o elemento da posição inicial da parte não ordenada.',
      feedbackIncorrect:
          'A resposta correta é: Colocar o menor elemento da passagem na posição correta da parte ordenada.',
    ),
    NewContentTask(
      id: '4_5',
      title: '',
      description:
          'Analise o loop interno (linha 8: `for (j = i + 1; j < tam; j++)`). Qual é sua função principal?',
      content: selectionSortCode,
      options: [
        'Percorrer a parte não ordenada do vetor para encontrar o menor elemento', // correta
        'Comparar apenas elementos adjacentes',
        'Trocar elementos do início do vetor',
        'Reduzir a complexidade do algoritmo para O(n)'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O loop interno examina todos os elementos restantes da parte não ordenada para localizar o menor valor.',
      feedbackIncorrect:
          'A resposta correta é: Percorrer a parte não ordenada do vetor para encontrar o menor elemento.',
    ),
  ],
),


NewContentLevel(
  id: 5,
  title: 'Selection Sort em C – Complexidade e Casos',
  description:
      'Entenda a complexidade, melhores e piores casos do Selection Sort em C.',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content:
      'O Selection Sort em C tem complexidade O(n²) em todos os casos, pois percorre o vetor inteiro repetidamente para encontrar o menor elemento.',
  isLocked: false,
  feedbackSuccess:
      "Ótimo! Você compreendeu os casos e complexidade do Selection Sort em C.",
  feedbackFailure: "Revise os conceitos de complexidade do Selection Sort em C.",
  tasks: [
    NewContentTask(
      id: '5_1',
      title: '',
      description:
          'Analise a linha 8: `for (j = i + 1; j < tam; j++)`. Como esse loop contribui para a complexidade do algoritmo?',
      content: selectionSortCode,
      options: [
        'Ele percorre toda a parte não ordenada do vetor a cada passagem, contribuindo para O(n²).', // correta
        'Ele reduz a complexidade para O(n log n).',
        'Ele percorre apenas o primeiro elemento, contribuindo pouco para a complexidade.',
        'Ele inicializa a memória do vetor.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Cada passagem do loop interno percorre a parte não ordenada do vetor, garantindo complexidade O(n²).',
      feedbackIncorrect:
          'A resposta correta é: Ele percorre toda a parte não ordenada do vetor a cada passagem, contribuindo para O(n²).',
    ),
    NewContentTask(
      id: '5_2',
      title: '',
      description:
          'Analise a linha 10: `min_idx = j;`. Qual impacto desta atualização em vetores já ordenados?',
      content: selectionSortCode,
      options: [
        'Mesmo em vetores já ordenados, o algoritmo continua verificando todos os elementos, mantendo O(n²).', // correta
        'O algoritmo para imediatamente, reduzindo a complexidade.',
        'A ordem dos elementos é alterada aleatoriamente.',
        'Ele otimiza a memória usada pelo algoritmo.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Mesmo que o vetor esteja ordenado, `min_idx` pode ser atualizado, mas todas as comparações ainda ocorrem.',
      feedbackIncorrect:
          'A resposta correta é: Mesmo em vetores já ordenados, o algoritmo continua verificando todos os elementos, mantendo O(n²).',
    ),
    NewContentTask(
      id: '5_3',
      title: '',
      description:
          'Analise as linhas 14 a 16: troca de elementos. Como essas trocas afetam a estabilidade do Selection Sort?',
      content: selectionSortCode,
      options: [
        'Podem alterar a ordem relativa de elementos iguais, tornando o algoritmo não estável.', // correta
        'Mantêm sempre a ordem original dos elementos iguais.',
        'Eliminam elementos duplicados do vetor.',
        'Otimizam a complexidade do algoritmo.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Ao trocar o menor elemento encontrado com a posição inicial da passagem, elementos iguais podem mudar de ordem, tornando o algoritmo não estável.',
      feedbackIncorrect:
          'A resposta correta é: Podem alterar a ordem relativa de elementos iguais, tornando o algoritmo não estável.',
    ),
    NewContentTask(
      id: '5_4',
      title: '',
      description:
          'Considerando um vetor de tamanho n, quantas iterações o loop externo (linha 5: `for (i = 0; i < tam - 1; i++)`) realiza?',
      content: selectionSortCode,
      options: [
        'n', 
        'n-1', // correta
        'n/2', 
        'log₂(n)'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! O loop externo realiza n-1 passagens para posicionar corretamente todos os elementos, contribuindo para O(n²).',
      feedbackIncorrect:
          'A resposta correta é: n-1.',
    ),
    NewContentTask(
      id: '5_5',
      title: '',
      description:
          'Por que o Selection Sort em C não se beneficia de vetores parcialmente ordenados?',
      content: selectionSortCode,
      options: [
        'Porque ele ainda percorre toda a parte não ordenada em cada passagem, mantendo O(n²).', // correta
        'Porque o algoritmo só funciona com vetores invertidos.',
        'Porque ele ignora elementos repetidos.',
        'Porque o loop interno é interrompido prematuramente.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! A vantagem de vetores parcialmente ordenados não é explorada, pois o algoritmo verifica todos os elementos da parte não ordenada a cada passagem.',
      feedbackIncorrect:
          'A resposta correta é: Porque ele ainda percorre toda a parte não ordenada em cada passagem, mantendo O(n²).',
    ),
  ],
),

NewContentLevel(
  id: 6,
  title: 'Selection Sort em C – Exemplos e Comparações',
  description:
      'Veja exemplos práticos de execução do Selection Sort em C e comparações com outros algoritmos.',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content:
      'Analise exemplos de vetores em C e como o Selection Sort se comporta em comparação com o Bubble Sort, destacando menos trocas e execução passo a passo.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você agora domina exemplos e comparações do Selection Sort em C.",
  feedbackFailure:
      "Revise os exemplos e comparações para melhorar seu entendimento do Selection Sort em C.",
  tasks: [
    NewContentTask(
      id: '6_1',
      title: '',
      description:
          'Analise a linha 6: `min_idx = i;`. Por que definimos `min_idx` assim no início de cada iteração?',
      content: selectionSortCode,
      options: [
        'Para assumir inicialmente que o primeiro elemento da parte não ordenada é o menor.', // correta
        'Para comparar elementos adjacentes.',
        'Para reduzir a complexidade para O(n log n).',
        'Para armazenar o último elemento do vetor.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! `min_idx` começa assumindo que o primeiro elemento da parte não ordenada é o menor.',
      feedbackIncorrect:
          'A resposta correta é: Para assumir inicialmente que o primeiro elemento da parte não ordenada é o menor.',
    ),
    NewContentTask(
      id: '6_2',
      title: '',
      description:
          'Selection Sort: Dado o vetor {8, 2, 4, 1}, qual elemento será trocado na primeira iteração e com qual posição?',
      content: '[OPCAO]',
      options: [
        '8 e 1', // correta
        '2 e 4',
        '8 e 2',
        '1 e 4'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O menor elemento 1 é trocado com o primeiro elemento 8.',
      feedbackIncorrect:
          'A resposta correta é: 8 e 1.',
    ),
    NewContentTask(
      id: '6_3',
      title: '',
      description:
          'Comparando com o Bubble Sort, qual é a principal vantagem do Selection Sort em termos de trocas?',
      content: '[OPCAO]',
      options: [
        'Faz menos trocas, pois só troca uma vez por passagem.', // correta
        'Faz mais trocas para garantir ordenação.',
        'Troca apenas elementos adjacentes.',
        'Não realiza trocas, apenas compara.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O Selection Sort realiza apenas uma troca por iteração do loop externo, enquanto o Bubble Sort pode trocar múltiplas vezes.',
      feedbackIncorrect:
          'A resposta correta é: Faz menos trocas, pois só troca uma vez por passagem.',
    ),
    NewContentTask(
      id: '6_4',
      title: '',
      description:
          'Analise a linha 9: `if(vet[j] < vet[min_idx])`. O que acontece se dois elementos forem iguais?',
      content: selectionSortCode,
      options: [
        'O índice do menor é atualizado, podendo alterar a ordem relativa (não estável).', // correta
        'O índice não é atualizado, mantendo a ordem original.',
        'O algoritmo interrompe a execução.',
        'Todos os elementos iguais são agrupados automaticamente.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Se dois elementos forem iguais, a ordem relativa pode mudar, tornando o Selection Sort não estável.',
      feedbackIncorrect:
          'A resposta correta é: O índice do menor é atualizado, podendo alterar a ordem relativa (não estável).',
    ),
    NewContentTask(
      id: '6_5',
      title: '',
      description:
          'Imagine um vetor quase ordenado: {1, 2, 3, 5, 4}. Quantas trocas o Selection Sort realizará?',
      content: '[OPCAO]',
      options: [
        'Uma única troca', // correta
        'Duas trocas',
        'Quatro trocas',
        'Nenhuma troca'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Ele troca apenas o menor elemento fora de posição por cada passagem, resultando em apenas uma troca para corrigir o 4 e o 5.',
      feedbackIncorrect:
          'A resposta correta é: Uma única troca.',
    ),
  ],
),

 NewContentLevel(
  id: 7,
  title: 'Insertion Sort em C – Conceito e Funcionamento',
  description:
      'Aprenda o que é o Insertion Sort em C e como ele funciona passo a passo.',
  difficulty: NewContentDifficulty.intermediario,
  theme: 'Algoritmos de Ordenação',
  content:
      'O Insertion Sort em C organiza elementos de um vetor inserindo cada elemento na posição correta da parte já ordenada do vetor, deslocando os elementos maiores para a direita.',
  isLocked: false,
  feedbackSuccess:
      "Parabéns! Você entendeu o conceito e funcionamento do Insertion Sort em C.",
  feedbackFailure: "Revise o Insertion Sort em C e tente novamente!",
  tasks: [
    NewContentTask(
      id: '7_1',
      title: '',
      description:
          'Analise a linha 4: `x = vet[i];`. Qual é a função da variável `x`?',
      content: insertionSortCode,
      options: [
        'Armazenar temporariamente o elemento a ser inserido na parte ordenada.', // correta
        'Contar o número de comparações realizadas.',
        'Armazenar o índice do menor elemento.',
        'Marcar se houve troca no vetor.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! A variável `x` guarda o elemento que será inserido na posição correta da parte ordenada.',
      feedbackIncorrect:
          'A resposta correta é: Armazenar temporariamente o elemento a ser inserido na parte ordenada.',
    ),
    NewContentTask(
      id: '7_2',
      title: '',
      description:
          'Analise a linha 7: `while (j >= 0 && vet[j] > x)`. Qual é o papel deste loop?',
      content: insertionSortCode,
      options: [
        'Deslocar elementos maiores para a direita até encontrar a posição correta do `x`.', // correta
        'Encontrar o menor elemento do vetor.',
        'Trocar elementos adjacentes até o vetor estar ordenado.',
        'Finalizar a execução do loop externo prematuramente.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Este loop garante que todos os elementos maiores que `x` sejam deslocados para abrir espaço para inserção.',
      feedbackIncorrect:
          'A resposta correta é: Deslocar elementos maiores para a direita até encontrar a posição correta do `x`.',
    ),
    NewContentTask(
      id: '7_3',
      title: '',
      description:
          'Analise a linha 12: `vet[j + 1] = x;`. O que esta linha realiza no algoritmo?',
      content: insertionSortCode,
      options: [
        'Insere o elemento `x` na posição correta da parte ordenada.', // correta
        'Troca `x` com o elemento imediatamente anterior.',
        'Reinicia o loop externo.',
        'Marca que o vetor está ordenado.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Depois de deslocar os elementos maiores, `x` é colocado na posição correta.',
      feedbackIncorrect:
          'A resposta correta é: Insere o elemento `x` na posição correta da parte ordenada.',
    ),
    NewContentTask(
      id: '7_4',
      title: '',
      description:
          'Dado o vetor {5, 2, 4, 6, 1}, após a primeira iteração do loop externo (linha 3), qual será o estado do vetor?',
      content: insertionSortCode,
      options: [
        '{2, 5, 4, 6, 1}', // correta
        '{5, 2, 4, 6, 1}',
        '{2, 4, 5, 6, 1}',
        '{1, 5, 2, 4, 6}'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O segundo elemento 2 é inserido antes do 5, deslocando o 5 para a direita.',
      feedbackIncorrect:
          'A resposta correta é: {2, 5, 4, 6, 1}.',
    ),
    NewContentTask(
      id: '7_5',
      title: '',
      description:
          'O Insertion Sort em C é um algoritmo in-place (linhas 0-14)?',
      content: insertionSortCode,
      options: [
        'Sim, altera diretamente o vetor sem criar cópias.', // correta
        'Não, precisa criar várias listas temporárias.',
        'Sim, mas apenas no melhor caso.',
        'Não, só funciona com vetores pequenos.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O Insertion Sort em C é in-place e utiliza apenas variáveis auxiliares (`i, j, x`).',
      feedbackIncorrect:
          'A resposta correta é: Sim, altera diretamente o vetor sem criar cópias.',
    ),
  ],
),


// 8

NewContentLevel(
  id: 8,
  title: 'Insertion Sort em C – Complexidade e Casos',
  description:
      'Entenda a complexidade, melhores e piores casos do Insertion Sort aplicado a vetores em C.',
  difficulty: NewContentDifficulty.intermediario,
  theme: 'Algoritmos de Ordenação',
  content:
      'O Insertion Sort em C tem complexidade O(n) no melhor caso (vetor já ordenado) e O(n²) no médio e pior caso, realizando comparações e deslocamentos para posicionar elementos corretamente.',
  isLocked: false,
  feedbackSuccess:
      "Ótimo! Você compreendeu os casos e complexidade do Insertion Sort em C.",
  feedbackFailure: "Revise os conceitos de complexidade do Insertion Sort em C.",
  tasks: [
    NewContentTask(
      id: '8_1',
      title: '',
      description:
          'Analise o loop externo (linha 3: `for (i = 1; i < tam; i++)`). Qual é a complexidade no melhor caso para um vetor em C?',
      content: insertionSortCode,
      options: [
        'O(n)', // correta
        'O(n²)',
        'O(log n)',
        'O(1)'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! No melhor caso, quando o vetor já está ordenado, cada elemento é apenas comparado uma vez, resultando em O(n).',
      feedbackIncorrect: 'A resposta correta é: O(n).',
    ),
    NewContentTask(
      id: '8_2',
      title: '',
      description:
          'Considerando o loop interno (linha 7: `while (j >= 0 && vet[j] > x)`), qual é a complexidade no pior caso?',
      content: insertionSortCode,
      options: [
        'O(n)',
        'O(n²)', // correta
        'O(n log n)',
        'O(1)'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! No pior caso, todos os elementos maiores precisam ser deslocados a cada iteração, resultando em O(n²).',
      feedbackIncorrect: 'A resposta correta é: O(n²).',
    ),
    NewContentTask(
      id: '8_3',
      title: '',
      description:
          'Qual situação representa o pior caso do Insertion Sort (linhas 3-12)?',
      content: insertionSortCode,
      options: [
        'Vetor já ordenado',
        'Vetor em ordem inversa', // correta
        'Vetor de tamanho 1',
        'Vetor com elementos repetidos'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! O pior caso ocorre quando o vetor está completamente invertido, exigindo deslocamentos máximos.',
      feedbackIncorrect: 'A resposta correta é: Vetor em ordem inversa.',
    ),
    NewContentTask(
      id: '8_4',
      title: '',
      description:
          'No melhor caso, o loop interno (linha 7) realiza quantas comparações por elemento?',
      content: insertionSortCode,
      options: [
        'Uma única comparação por elemento', // correta
        'Todas as comparações possíveis',
        'Nenhuma comparação',
        'Comparações variáveis de acordo com o valor do vetor'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Quando o vetor já está ordenado, o loop interno compara apenas uma vez para cada elemento.',
      feedbackIncorrect:
          'A resposta correta é: Uma única comparação por elemento.',
    ),
    NewContentTask(
      id: '8_5',
      title: '',
      description:
          'O Insertion Sort (linhas 0-14) é indicado para vetores grandes?',
      content: insertionSortCode,
      options: [
        'Sim, sempre é rápido.',
        'Não, ele é ineficiente para vetores grandes.', // correta
        'Sim, mas só se forem quase ordenados.',
        'Não, apenas funciona com vetores pequenos.'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! Para vetores grandes, o Insertion Sort se torna ineficiente devido à complexidade O(n²).',
      feedbackIncorrect:
          'A resposta correta é: Não, ele é ineficiente para vetores grandes.',
    ),
  ],
),


// 9

 NewContentLevel(
  id: 9,
  title: 'Insertion Sort em C – Exemplos e Passo a Passo',
  description:
      'Analise exemplos práticos e visualize cada iteração do Insertion Sort aplicado a vetores em C.',
  difficulty: NewContentDifficulty.intermediario,
  theme: 'Algoritmos de Ordenação',
  content:
      'Veja passo a passo como o Insertion Sort em C ordena vetores, compreendendo deslocamentos e inserções de elementos.',
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você agora domina exemplos e passo a passo do Insertion Sort em C.",
  feedbackFailure:
      "Revise os exemplos e passo a passo do Insertion Sort em C para melhorar seu entendimento.",
  tasks: [
    NewContentTask(
      id: '9_1',
      title: '',
      description:
          'Analise a linha 4 (`x = vet[i];`) e a linha 7 (`while (j >= 0 && vet[j] > x)`): Dado o vetor {5, 3, 8, 4}, qual será o resultado após a 1ª iteração?',
      content: insertionSortCode,
      options: [
        '{3, 5, 8, 4}', // correta
        '{5, 3, 8, 4}',
        '{3, 8, 5, 4}',
        '{5, 8, 3, 4}'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O 3 é armazenado em `x` e inserido antes do 5, deslocando o 5 para a direita.',
      feedbackIncorrect: 'A resposta correta é: {3, 5, 8, 4}.',
    ),
    NewContentTask(
      id: '9_2',
      title: '',
      description:
          'Após a 2ª iteração (linha 3-12) no vetor {3, 5, 8, 4}, qual será o estado do vetor?',
      content: insertionSortCode,
      options: [
        '{3, 5, 8, 4}', // correta
        '{3, 8, 5, 4}',
        '{5, 3, 8, 4}',
        '{3, 4, 5, 8}'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O 8 permanece na posição correta, não havendo deslocamentos nesta iteração.',
      feedbackIncorrect: 'A resposta correta é: {3, 5, 8, 4}.',
    ),
    NewContentTask(
      id: '9_3',
      title: '',
      description:
          'Na 3ª iteração (linha 3-12), qual será o estado do vetor {3, 5, 8, 4} considerando as comparações e deslocamentos?',
      content: insertionSortCode,
      options: [
        '{3, 4, 5, 8}', // correta
        '{3, 5, 4, 8}',
        '{4, 3, 5, 8}',
        '{3, 5, 8, 4}'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O 4 é armazenado em `x`, desloca 5 e 8 para a direita, e é inserido entre 3 e 5.',
      feedbackIncorrect: 'A resposta correta é: {3, 4, 5, 8}.',
    ),
    NewContentTask(
      id: '9_4',
      title: '',
      description:
          'Considerando o loop interno (linha 7: `while (j >= 0 && vet[j] > x)`), quantos elementos o Insertion Sort compara no pior caso?',
      content: insertionSortCode,
      options: [
        'Todos os elementos anteriores do vetor', // correta
        'Apenas o próximo elemento',
        'Nenhum elemento',
        'Apenas metade dos elementos'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! No pior caso, cada elemento novo é comparado com todos os elementos da parte ordenada anterior.',
      feedbackIncorrect: 'A resposta correta é: Todos os elementos anteriores do vetor.',
    ),
    NewContentTask(
      id: '9_5',
      title: '',
      description:
          'Após cada iteração (linhas 3-12), o Insertion Sort mantém a parte ordenada do vetor?',
      content: insertionSortCode,
      options: [
        'Sim, cada elemento inserido mantém a parte já ordenada.', // correta
        'Não, o vetor só fica ordenado ao final.',
        'Depende do tamanho do vetor.',
        'Depende do algoritmo usado junto.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Cada inserção garante que a parte do vetor processada permaneça ordenada.',
      feedbackIncorrect:
          'A resposta correta é: Sim, cada elemento inserido mantém a parte já ordenada.',
    ),
  ],
),



NewContentLevel(
  id: 10,
  title: 'QuickSort em C – Conceito e Funcionamento',
  description: 'Aprenda o que é QuickSort em C e como funciona passo a passo.',
  difficulty: NewContentDifficulty.avancado,
  theme: 'Algoritmos de Ordenação',
  content:
      'O QuickSort em C é um algoritmo eficiente de ordenação baseado na estratégia de "dividir e conquistar". Ele escolhe um pivô, particiona o vetor em elementos menores e maiores que o pivô, e aplica recursivamente o mesmo processo até o vetor estar completamente ordenado.',
  isLocked: false,
  feedbackSuccess:
      "Parabéns! Você entendeu o conceito e funcionamento do QuickSort em C.",
  feedbackFailure: "Revise o QuickSort em C e tente novamente!",
  tasks: [
    NewContentTask(
      id: '10_1',
      title: '',
      description: 'Qual é a função da função swap nas linhas 1–4?',
      content: quickSortCode,
      options: [
        'Trocar o conteúdo de dois elementos de um vetor.', // correta
        'Comparar dois elementos e retornar o maior.',
        'Ordenar dois elementos de forma crescente.',
        'Inicializar elementos de um vetor.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! A função swap troca o conteúdo de dois elementos usando ponteiros.',
      feedbackIncorrect:
          'A resposta correta é: Trocar o conteúdo de dois elementos de um vetor.',
    ),
    NewContentTask(
      id: '10_2',
      title: '',
      description: 'O que acontece na linha 10?',
      content: quickSortCode,
      options: [
        'Seleciona o último elemento do vetor como pivô.', // correta
        'Ordena o vetor até o índice dir.',
        'Cria um novo vetor temporário.',
        'Ignora o último elemento do vetor.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! A linha define o pivô como o último elemento.',
      feedbackIncorrect: 'A resposta correta é: Seleciona o último elemento do vetor como pivô.',
    ),
    NewContentTask(
      id: '10_3',
      title: '',
      description: 'Qual é o propósito do for nas linhas 13–19?',
      content: quickSortCode,
      options: [
        'Mover elementos menores ou iguais ao pivô para a esquerda.', // correta
        'Mover todos os elementos para a direita do vetor.',
        'Somar todos os elementos menores que o pivô.',
        'Deletar elementos iguais ao pivô.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O for percorre o vetor e coloca elementos menores ou iguais ao pivô à esquerda.',
      feedbackIncorrect:
          'A resposta correta é: Mover elementos menores ou iguais ao pivô para a esquerda.',
    ),
    NewContentTask(
      id: '10_4',
      title: '',
      description: 'Qual é a função da linha 20?',
      content: quickSortCode,
      options: [
        'Colocar o pivô na posição correta.', // correta
        'Trocar o primeiro e o último elemento do vetor.',
        'Reinicializar o vetor para ordenar novamente.',
        'Remover elementos duplicados.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Essa linha coloca o pivô na posição final correta do vetor.',
      feedbackIncorrect:
          'A resposta correta é: Colocar o pivô na posição correta.',
    ),
    NewContentTask(
      id: '10_5',
      title: '',
      description: 'O que acontece na função quicksort nas linhas 25–34?',
      content: quickSortCode,
      options: [
        'Aplica recursivamente o QuickSort aos subvetores criados pelo pivô.', // correta
        'Ordena apenas o primeiro e último elementos do vetor.',
        'Compara todos os elementos e troca adjacentes.',
        'Conta quantos elementos estão fora de ordem.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! A função quicksort aplica recursivamente o algoritmo aos subvetores.',
      feedbackIncorrect:
          'A resposta correta é: Aplica recursivamente o QuickSort aos subvetores criados pelo pivô.',
    ),
  ],
),

NewContentLevel(
  id: 11,
  title: 'QuickSort em C – Complexidade e Casos',
  description:
      'Entenda a complexidade, melhores e piores casos do QuickSort em C.',
  difficulty: NewContentDifficulty.avancado,
  theme: 'Algoritmos de Ordenação',
  content:
      'O QuickSort em C tem complexidade média O(n log n), mas no pior caso pode chegar a O(n²) se o pivô for mal escolhido. Implementações in-place usam a pilha de chamadas recursiva, evitando listas temporárias.',
  isLocked: false,
  feedbackSuccess:
      "Ótimo! Você compreendeu os casos e complexidade do QuickSort em C.",
  feedbackFailure: "Revise os conceitos de complexidade do QuickSort em C.",
  tasks: [
    NewContentTask(
      id: '11_1',
      title: '',
      description: 'Qual é a complexidade média do QuickSort?',
      content: '[OPCAO]',
      options: [
        'O(n log n)', // correta
        'O(n²)',
        'O(n)',
        'O(1)'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! A complexidade média do QuickSort é O(n log n).',
      feedbackIncorrect: 'A resposta correta é: O(n log n).',
    ),
    NewContentTask(
      id: '11_2',
      title: '',
      description: 'Qual é o pior caso do QuickSort?',
      content: '[OPCAO]',
      options: [
        'Vetor aleatório',
        'Vetor já ordenado com pivô mal escolhido', // correta
        'Vetor pequeno',
        'Vetor com elementos repetidos'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! O pior caso ocorre quando o pivô não divide o vetor de forma equilibrada.',
      feedbackIncorrect:
          'A resposta correta é: Vetor já ordenado com pivô mal escolhido.',
    ),
    NewContentTask(
      id: '11_3',
      title: '',
      description: 'O QuickSort é in-place?',
      content: '[OPCAO]',
      options: [
        'Sim, mas a versão recursiva usa memória para a pilha de chamadas.', // correta
        'Não, sempre cria vetores temporários.',
        'Sim, sem uso de memória extra.',
        'Não, só funciona com cópias do vetor.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! QuickSort é in-place, mas a recursão consome memória de pilha.',
      feedbackIncorrect:
          'A resposta correta é: Sim, mas a versão recursiva usa memória para a pilha de chamadas.',
    ),
    NewContentTask(
      id: '11_4',
      title: '',
      description: 'O QuickSort é recomendado para vetores pequenos?',
      content: '[OPCAO]',
      options: [
        'Sim, é sempre a melhor escolha.',
        'Não, para vetores pequenos o Insertion Sort pode ser mais eficiente.', // correta
        'Depende da linguagem.',
        'Não, apenas para vetores muito grandes.'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! Para vetores pequenos, algoritmos simples como Insertion Sort podem ser mais rápidos.',
      feedbackIncorrect:
          'A resposta correta é: Não, para vetores pequenos o Insertion Sort pode ser mais eficiente.',
    ),
    NewContentTask(
      id: '11_5',
      title: '',
      description: 'O QuickSort é estável?',
      content: '[OPCAO]',
      options: [
        'Sim',
        'Não', // correta
        'Depende do pivô',
        'Depende do tamanho do vetor'
      ],
      correctOptionIndex: 1,
      feedbackCorrect: 'Correto! QuickSort não é estável.',
      feedbackIncorrect: 'A resposta correta é: Não.',
    ),
  ],
),

// 12

 NewContentLevel(
  id: 12,
  title: 'MergeSort – Conceito e Funcionamento',
  description: 'Aprenda o que é MergeSort e como funciona passo a passo.',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content:
      'O MergeSort é um algoritmo eficiente baseado na estratégia de "dividir e conquistar". Ele divide a lista em duas metades, ordena cada metade recursivamente e combina as duas sublistas em uma lista ordenada.',
  isLocked: false,
  feedbackSuccess:
      "Parabéns! Você entendeu o conceito e funcionamento do MergeSort.",
  feedbackFailure: "Revise o MergeSort e tente novamente!",
  tasks: [
    NewContentTask(
      id: '12_1',
      title: '',
      description: 'O que é MergeSort?',
      content: '[OPCAO]',
      options: [
        'Um algoritmo que divide a lista, ordena as partes e as combina.', // correta
        'Um algoritmo que compara apenas elementos adjacentes.',
        'Um algoritmo que seleciona sempre o menor elemento.',
        'Um algoritmo que ordena apenas listas pequenas.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! MergeSort utiliza divisão recursiva e combinação para ordenar a lista.',
      feedbackIncorrect:
          'A resposta correta é: Um algoritmo que divide a lista, ordena as partes e as combina.',
    ),
    NewContentTask(
      id: '12_2',
      title: '',
      description: 'Qual a estratégia usada pelo MergeSort?',
      content: '[OPCAO]',
      options: [
        'Dividir e conquistar', // correta
        'Comparação adjacente',
        'Seleção do menor elemento',
        'Ordenação por inserção'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! MergeSort segue a estratégia dividir e conquistar.',
      feedbackIncorrect: 'A resposta correta é: Dividir e conquistar.',
    ),
    NewContentTask(
      id: '12_3',
      title: '',
      description: 'O MergeSort é estável?',
      content: '[OPCAO]',
      options: [
        'Sim, mantém a ordem de elementos iguais.', // correta
        'Não, a ordem pode mudar.',
        'Depende do tamanho da lista.',
        'Só é estável para listas pequenas.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! MergeSort é um algoritmo estável.',
      feedbackIncorrect:
          'A resposta correta é: Sim, mantém a ordem de elementos iguais.',
    ),
    NewContentTask(
      id: '12_4',
      title: '',
      description: 'Quando é recomendado usar MergeSort?',
      content: '[OPCAO]',
      options: [
        'Para grandes volumes de dados, devido à sua complexidade garantida O(n log n).', // correta
        'Somente para listas pequenas.',
        'Apenas para listas já ordenadas.',
        'Nunca é recomendado, é lento.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! MergeSort é confiável para grandes listas.',
      feedbackIncorrect:
          'A resposta correta é: Para grandes volumes de dados, devido à sua complexidade garantida O(n log n).',
    ),
    NewContentTask(
      id: '12_5',
      title: '',
      description: 'Quais são as etapas principais do MergeSort?',
      content: '[OPCAO]',
      options: [
        'Dividir lista → Ordenar sublistas → Combinar sublistas', // correta
        'Comparar elementos adjacentes → Trocar → Repetir',
        'Selecionar menor elemento → Mover para início → Repetir',
        'Dividir em duas listas → Juntar sem ordenação'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Estas são as etapas fundamentais do MergeSort.',
      feedbackIncorrect:
          'A resposta correta é: Dividir lista → Ordenar sublistas → Combinar sublistas.',
    ),
  ],
),

// 13

 NewContentLevel(
  id: 13,
  title: 'MergeSort – Complexidade e Casos',
  description:
      'Entenda a complexidade, melhores e piores casos do MergeSort.',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content:
      'O MergeSort tem complexidade garantida O(n log n) em todos os casos, independentemente da ordem inicial do vetor.',
  isLocked: false,
  feedbackSuccess: "Ótimo! Você compreendeu a complexidade do MergeSort.",
  feedbackFailure: "Revise os conceitos de complexidade do MergeSort.",
  tasks: [
    NewContentTask(
      id: '13_1',
      title: '',
      description: 'Qual a complexidade do MergeSort no melhor caso?',
      content: '[OPCAO]',
      options: [
        'O(n log n)', // correta
        'O(n²)',
        'O(n)',
        'O(1)'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! Melhor caso é O(n log n).',
      feedbackIncorrect: 'A resposta correta é: O(n log n).',
    ),
    NewContentTask(
      id: '13_2',
      title: '',
      description: 'Qual a complexidade do MergeSort no pior caso?',
      content: '[OPCAO]',
      options: [
        'O(n log n)', // correta
        'O(n²)',
        'O(n)',
        'O(1)'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! Pior caso também é O(n log n).',
      feedbackIncorrect: 'A resposta correta é: O(n log n).',
    ),
    NewContentTask(
      id: '13_3',
      title: '',
      description: 'O MergeSort exige memória extra para vetores temporários?',
      content: '[OPCAO]',
      options: [
        'Sim, para vetores temporários durante o merge.', // correta
        'Não, sempre é in-place.',
        'Depende do tamanho do vetor.',
        'Não, apenas para vetores pequenos.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! MergeSort requer memória proporcional ao tamanho do vetor.',
      feedbackIncorrect:
          'A resposta correta é: Sim, para vetores temporários durante o merge.',
    ),
    NewContentTask(
      id: '13_4',
      title: '',
      description:
          'O MergeSort é mais eficiente que o Insertion Sort para vetores grandes?',
      content: '[OPCAO]',
      options: [
        'Sim, devido à complexidade garantida O(n log n).', // correta
        'Não, Insertion Sort é melhor.',
        'Depende da ordem inicial do vetor.',
        'Só se o vetor tiver menos de 10 elementos.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! MergeSort é muito eficiente para vetores grandes.',
      feedbackIncorrect:
          'A resposta correta é: Sim, devido à complexidade garantida O(n log n).',
    ),
    NewContentTask(
      id: '13_5',
      title: '',
      description: 'O MergeSort calcula sempre o meio do vetor?',
      content: '[OPCAO]',
      options: [
        'Sim, usando divisão inteira, mesmo para vetores ímpares.', // correta
        'Não, escolhe o pivô aleatoriamente.',
        'Só se o vetor for par.',
        'Só se o vetor for grande.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! MergeSort calcula o meio usando divisão inteira para todos os vetores.',
      feedbackIncorrect:
          'A resposta correta é: Sim, usando divisão inteira, mesmo para vetores ímpares.',
    ),
  ],
),

// 14

NewContentLevel(
  id: 15,
  title: 'MergeSort – Entendendo o Código em C',
  description:
    'Aprenda a interpretar a execução do MergeSort analisando o código linha a linha.',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content:
    'O MergeSort divide o vetor recursivamente, ordena subvetores unitários e combina os resultados usando memória temporária.',
  isLocked: false,
  feedbackSuccess:
    "Excelente! Você consegue interpretar a execução do MergeSort diretamente do código em C.",
  feedbackFailure:
    "Revise o passo a passo do MergeSort no código e tente novamente.",
  tasks: [
    NewContentTask(
      id: '15_1',
      title: '',
      description:
        'Analise a linha 2: qual é a função dessa linha no MergeSort?',
      content: mergeSortCode,
      options: [
        'Verifica se o subvetor tem apenas um elemento e encerra a recursão.', // correta
        'Calcula o índice do meio do vetor.',
        'Aloca memória para o vetor temporário.',
        'Realiza a combinação dos subvetores.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
        'Correto! A linha 2 é a condição base: se o subvetor tem apenas um elemento, ele já está ordenado.',
      feedbackIncorrect:
        'Resposta correta: Verifica se o subvetor tem apenas um elemento e encerra a recursão.',
    ),
    NewContentTask(
      id: '15_2',
      title: '',
      description:
        'Na linha 3, metadeTamanho é calculado. Por que usamos essa expressão?',
      content: mergeSortCode,
      options: [
        'Para encontrar o índice do meio do subvetor e dividir em duas metades.', // correta
        'Para determinar o tamanho total do vetor.',
        'Para inicializar o índice do vetor temporário.',
        'Para verificar se o vetor já está ordenado.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
        'Correto! A linha 3 calcula o índice do meio, usado para dividir o vetor em duas metades.',
      feedbackIncorrect:
        'Resposta correta: Para encontrar o índice do meio do subvetor e dividir em duas metades.',
    ),
    NewContentTask(
      id: '15_3',
      title: '',
      description:
        'Observe as linhas 5 e 6. Qual é o propósito dessas chamadas recursivas?',
      content: mergeSortCode,
      options: [
        'Ordenar recursivamente a metade esquerda e a metade direita do vetor.', // correta
        'Combinar os subvetores em um vetor temporário.',
        'Liberar memória alocada anteriormente.',
        'Comparar elementos para decidir a ordem final.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
        'Correto! Essas linhas chamam o MergeSort para ordenar cada metade do vetor.',
      feedbackIncorrect:
        'Resposta correta: Ordenar recursivamente a metade esquerda e a metade direita do vetor.',
    ),
    NewContentTask(
      id: '15_4',
      title: '',
      description:
        'Linhas 13 a 39 fazem a combinação dos subvetores. Como o código garante que todos os elementos serão copiados corretamente para vetorTemp?',
      content: mergeSortCode,
      options: [
        'Usando índices i e j para percorrer as duas metades e k para vetorTemp, copiando elemento por elemento.', // correta
        'Copiando diretamente o vetor original sem verificar as metades.',
        'Apenas copiando os elementos da metade esquerda.',
        'Misturando os elementos aleatoriamente.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
        'Correto! O código percorre ambos os subvetores com i e j, inserindo o menor elemento em vetorTemp a cada passo.',
      feedbackIncorrect:
        'Resposta correta: Usando índices i e j para percorrer as duas metades e k para vetorTemp, copiando elemento por elemento.',
    ),
    NewContentTask(
      id: '15_5',
      title: '',
      description:
        'Na linha 41, vetorTemp é copiado de volta para vetor. Por que usamos "i - posicaoInicio" como índice?',
      content: mergeSortCode,
      options: [
        'Para ajustar o índice do vetor temporário à posição correta no vetor original.', // correta
        'Para reiniciar o índice do vetor temporário do zero.',
        'Para pular elementos já ordenados.',
        'Para evitar o uso do índice k.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
        'Correto! vetorTemp começa em 0, então subtraímos posicaoInicio para mapear corretamente para vetor.',
      feedbackIncorrect:
        'Resposta correta: Para ajustar o índice do vetor temporário à posição correta no vetor original.',
    ),
    
  ],
),




// Bloco 15 – Conceitos de Heap e Max-Heap
NewContentLevel(
  id: 15,
  title: 'Heap e Max-Heap em C',
  description:
    'Entenda como a estrutura Heap pode ser representada usando vetores em C e como isso é aplicado no HeapSort.',
  difficulty: NewContentDifficulty.avancado,
  theme: 'Algoritmos de Ordenação',
  content:
    'Em C, um Heap é uma estrutura de dados conceitualmente baseada em uma árvore binária completa, mas normalmente implementada com um vetor (array) para maior eficiência. Em um Max-Heap, o valor de qualquer índice `i` no vetor é sempre maior ou igual ao dos seus filhos, que ficam nos índices `2*i + 1` e `2*i + 2`.',
  isLocked: false,
  feedbackSuccess: "Excelente! Você entendeu como um Max-Heap funciona e como é implementado em C.",
  feedbackFailure:
    "Revise como um Heap é representado por vetores e a relação entre índices pai e filhos.",
  tasks: [
    NewContentTask(
      id: '15_1',
      title: '',
      description: 'Observando o trecho `heapify` (linhas 0–18), qual é a principal propriedade de qualquer nó em um Max-Heap?',
      content: heapSortCode,
      options: [
        'Ele deve ser maior ou igual a seus filhos.', // correta
        'Ele deve ser menor que seu nó pai.',
        'Ele deve estar na posição correta do vetor ordenado.',
        'Ele deve ser maior que o elemento à sua direita no vetor.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! No Max-Heap (linhas 6–10), o valor do nó pai é sempre maior ou igual ao dos seus filhos.',
      feedbackIncorrect: 'Resposta correta: Ele deve ser maior ou igual a seus filhos.',
    ),
    NewContentTask(
      id: '15_2',
      title: '',
      description: 'Observando o código completo (linhas 0–33), qual é a forma mais comum e eficiente de se implementar um Heap em C?',
      content: heapSortCode,
      options: [
        'Usando um vetor (array).', // correta
        'Usando uma lista duplamente encadeada.',
        'Usando alocação dinâmica com ponteiros para cada nó (structs).',
        'Usando uma matriz bidimensional.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! Em C, os Heaps são implementados com vetores (linhas 3–4) por eficiência e simplicidade.',
      feedbackIncorrect: 'Resposta correta: Usando um vetor (array).',
    ),
    NewContentTask(
      id: '15_3',
      title: '',
      description: 'No trecho `heapify` (linha 4), se um nó está no índice `i`, qual é o índice do seu filho esquerdo?',
      content: heapSortCode,
      options: [
        '2 * i + 1', // correta
        'i / 2',
        'i - 1',
        '2 * i'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O filho esquerdo é acessado com `2*i + 1` (linha 4).',
      feedbackIncorrect: 'Resposta correta: 2 * i + 1.',
    ),
    NewContentTask(
      id: '15_4',
      title: '',
      description: 'No `heapsort` (linhas 20–33), por que o algoritmo constrói um Max-Heap antes de ordenar?',
      content: heapSortCode,
      options: [
        'Para que o maior elemento (a raiz) possa ser facilmente movido para a última posição do vetor a cada passo.', // correta
        'Para garantir que o menor elemento fique sempre na primeira posição.',
        'Porque é a única implementação possível em C.',
        'Para que o vetor seja ordenado em ordem decrescente primeiro.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O HeapSort usa a raiz do Max-Heap (linha 28) para extrair o maior elemento e movê-lo à sua posição final.',
      feedbackIncorrect: 'Resposta correta: Para que o maior elemento (a raiz) possa ser facilmente movido para a última posição do vetor a cada passo.',
    ),
    NewContentTask(
      id: '15_5',
      title: '',
      description: 'No `heapify` (linha 0–18), se um nó está no índice `i` (i > 0), como encontramos o índice do seu nó pai no vetor?',
      content: heapSortCode,
      options: [
        '(i - 1) / 2', // correta
        'i / 2 + 1',
        'i + 1',
        'Não é possível calcular sem ponteiros.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O índice do pai é `(i - 1) / 2`, usado implicitamente para manter a relação pai-filho (linhas 6–10).',
      feedbackIncorrect: 'Resposta correta: (i - 1) / 2.',
    ),
  ],
),



// Bloco 16 – Heapify, Swap e Passo a passo
NewContentLevel(
  id: 16,
  title: 'Heapify e Swap em C – O Coração do HeapSort',
  description:
    'Entenda como as funções `heapify` e `swap` manipulam um vetor em C para construir e ordenar um Max-Heap.',
  difficulty: NewContentDifficulty.intermediario,
  theme: 'Algoritmos de Ordenação',
  content:
    'Em C, o HeapSort se baseia em duas operações principais sobre um vetor: `heapify`, uma função que corrige a propriedade de Max-Heap a partir de um índice (linhas 0–18), e `swap`, que troca o elemento da raiz (linha 28) com o último elemento da porção não ordenada do vetor (linha 30).',
  isLocked: false,
  feedbackSuccess:
    "Excelente! Você entende como as funções `heapify` e `swap` operam em um vetor em C.",
  feedbackFailure:
    "Revise como `heapify` e `swap` são implementados em C.",
  tasks: [
    NewContentTask(
      id: '16_1',
      title: '',
      description: 'Observando o trecho `heapify` (linhas 0–18), qual é o objetivo da função `heapify(int arr[], int n, int i)`?',
      content: heapSortCode,
      options: [
        'Garantir que a subárvore com raiz no índice `i` satisfaça a propriedade de Max-Heap.', // correta
        'Trocar os valores dos índices `n` e `i` no vetor.',
        'Dividir o vetor em duas metades a partir do índice `i`.',
        'Ordenar completamente o vetor de `n` elementos.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! A função `heapify` (linhas 12–16) "afunda" o elemento `i` até que a propriedade de Max-Heap seja restaurada naquela subárvore.',
      feedbackIncorrect:
        'Resposta correta: Garantir que a subárvore com raiz no índice `i` satisfaça a propriedade de Max-Heap.',
    ),
    NewContentTask(
      id: '16_2',
      title: '',
      description: 'No trecho de troca dentro do `heapsort` (linhas 28–30), como uma função `swap` deve receber seus argumentos em C para trocar dois elementos do vetor?',
      content: heapSortCode,
      options: [
        'Como ponteiros para os elementos, para alterar os valores originais.', // correta
        'Como cópias dos valores dos elementos, realizando a troca localmente.',
        'Como índices do vetor, retornando um novo vetor com a troca.',
        'A linguagem C não permite criar uma função para isso.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! Em C, a troca (swap) precisa receber ponteiros para que os elementos originais do vetor sejam modificados (linhas 28–30).',
      feedbackIncorrect:
        'Resposta correta: Como ponteiros para os elementos, para alterar os valores originais.',
    ),
    NewContentTask(
      id: '16_3',
      title: '',
      description: 'Dentro do laço principal de ordenação do HeapSort (linhas 27–31), quando a função `heapify` é chamada?',
      content: heapSortCode,
      options: [
        'Após a troca (swap) da raiz com o último elemento, para corrigir a propriedade de Max-Heap na raiz (índice 0).', // correta
        'Apenas uma vez, antes de qualquer troca, para construir o heap inicial.',
        'Em todos os elementos do vetor, da esquerda para a direita, a cada iteração.',
        'A função `heapify` não é chamada dentro do laço de ordenação.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
        'Correto! Após o swap (linhas 28–30), o `heapify` (linha 31) corrige a raiz para manter o Max-Heap.',
      feedbackIncorrect:
        'Resposta correta: Após a troca (swap) da raiz com o último elemento, para corrigir a propriedade de Max-Heap na raiz (índice 0).',
    ),
    NewContentTask(
      id: '16_4',
      title: '',
      description: 'Qual representa o fluxo correto do HeapSort em C, considerando as linhas do código 20–33?',
      content: heapSortCode,
      options: [
        '1. Construir o Max-Heap inicial (linhas 23–25). 2. Em um laço, trocar `arr[0]` com o último elemento não ordenado (linhas 28–30) e chamar `heapify` na raiz (linha 31).', // correta
        '1. Chamar `heapify` para cada elemento. 2. Trocar `arr[0]` com o menor elemento do vetor.',
        '1. Trocar elementos aleatoriamente. 2. Chamar `heapify` no vetor inteiro até ordenar.',
        '1. Construir um Min-Heap. 2. Inverter o vetor resultante com um laço.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
        'Correto! Primeiro o vetor inteiro é transformado em um Max-Heap (linhas 23–25), depois os elementos são extraídos um a um (linhas 27–31).',
      feedbackIncorrect:
        'Resposta correta: 1. Construir o Max-Heap inicial (linhas 23–25). 2. Em um laço, trocar `arr[0]` com o último elemento não ordenado (linhas 28–30) e chamar `heapify` na raiz (linha 31).',
    ),
    NewContentTask(
      id: '16_5',
      title: '',
      description: 'Considerando todo o código de HeapSort (linhas 0–33), qual é a complexidade de tempo no pior caso?',
      content: heapSortCode,
      options: [
        'O(n log n)', // correta
        'O(n²)',
        'O(n)',
        'O(log n)'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O HeapSort (linhas 20–33) tem complexidade garantida de O(n log n), eficiente para grandes vetores.',
      feedbackIncorrect:
        'Resposta correta: O(n log n).',
    ),
  ],
),

// Bloco 17 – Exemplo de execução e código
NewContentLevel(
  id: 17,
  title: 'HeapSort em C – Exemplo Prático e Código',
  description:
    'Analise o passo a passo do HeapSort em um vetor de exemplo e interprete o código C fornecido.',
  difficulty: NewContentDifficulty.avancado,
  theme: 'Algoritmos de Ordenação',
  content:
    'O HeapSort em C primeiro transforma o vetor em um Max-Heap (linhas 23–25). Em seguida, ele repetidamente troca o elemento da raiz (linha 28) com o último elemento da parte não ordenada (linha 30) e chama `heapify` (linha 31) para restaurar a propriedade do heap.',
  isLocked: false,
  feedbackSuccess: "Ótimo! Você consegue interpretar o HeapSort e seu código em C.",
  feedbackFailure:
    "Revise o passo a passo do HeapSort e a função do código em C.",
  tasks: [
    NewContentTask(
      id: '17_1',
      title: '',
      description: 'Dado o vetor `int arr[] = {9, 4, 3, 8, 10, 2, 5};`, qual valor estará em `arr[0]` após a construção inicial do Max-Heap (linhas 23–25)?',
      content: heapSortCode,
      options: [
        '10', // correta
        '9',
        '5',
        '8'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! Após o laço de construção do Max-Heap (linhas 23–25), o maior elemento (10) vai para a raiz (índice 0).',
      feedbackIncorrect: 'Resposta correta: 10.',
    ),
    NewContentTask(
      id: '17_2',
      title: '',
      description: 'Após a construção do Max-Heap e a primeira troca (linhas 28–30), qual elemento é movido para a última posição do vetor?',
      content: heapSortCode,
      options: [
        '10', // correta
        '9',
        '5',
        '2'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O maior elemento da raiz é movido para a última posição do vetor, começando a ordenação.',
      feedbackIncorrect: 'Resposta correta: 10.',
    ),
    NewContentTask(
      id: '17_3',
      title: 'Analise o código do laço principal do HeapSort:',
      description: 'Qual linha do código é responsável por mover a raiz do heap para a posição final ordenada?',
      content: heapSortCode,
      options: [
        '`arr[i] = temp;`', // correta
        '`heapify(arr, i, 0);`',
        '`for (i = n - 1; i > 0; i--)`',
        '`temp = arr[0];`'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! A troca (linhas 28–30) move a raiz do Max-Heap para a posição final do vetor.',
      feedbackIncorrect: 'Resposta correta: `arr[i] = temp;`.',
    ),
    NewContentTask(
      id: '17_4',
      title: 'Ainda analisando o código:',
      description: 'Qual é o propósito da chamada `heapify(arr, i, 0);` (linha 31) dentro do laço?',
      content: heapSortCode,
      options: [
        'Restaurar a propriedade de Max-Heap na raiz (índice 0), considerando o novo tamanho do heap.', // correta
        'Construir o Max-Heap pela primeira vez.',
        'Verificar se o vetor já está ordenado.',
        'Trocar o menor e maior elemento do heap restante.'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! Após o swap, a raiz pode violar a propriedade de Max-Heap, e `heapify` corrige isso (linha 31).',
      feedbackIncorrect: 'Resposta correta: Restaurar a propriedade de Max-Heap na raiz (índice 0), considerando o novo tamanho do heap.',
    ),
    NewContentTask(
      id: '17_5',
      title: '',
      description: 'Qual será o vetor final `{9, 4, 3, 8, 10, 2, 5}` após a execução completa do HeapSort (linhas 20–33)?',
      content: heapSortCode,
      options: [
        '{2, 3, 4, 5, 8, 9, 10}', // correta
        '{10, 9, 8, 5, 4, 3, 2}',
        '{9, 8, 5, 4, 3, 2, 10}',
        '{2, 3, 4, 5, 9, 8, 10}'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! Após todas as iterações e chamadas a `heapify`, o vetor fica completamente ordenado em ordem crescente.',
      feedbackIncorrect: 'Resposta correta: {2, 3, 4, 5, 8, 9, 10}.',
    ),
  ],
),

// 18

NewContentLevel(
  id: 18,
  title: 'Bubble Sort - Conceitos Básicos',
  description: 'Aprenda os conceitos fundamentais do algoritmo Bubble Sort',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content: bubbleSortCode,
  isLocked: false,
  feedbackSuccess:
      "Parabéns! Você dominou os conceitos iniciais do Bubble Sort!",
  feedbackFailure: "Revise os conceitos iniciais e tente novamente!",
  tasks: [
    NewContentTask(
      id: '18_1',
      title: 'Pergunta 1',
      description: 'Qual é a principal função do algoritmo implementado neste código? (linha 0-15)',
      content: bubbleSortCode,
      options: [
        'Ordenar elementos em ordem crescente',
        'Ordenar elementos em ordem decrescente',
        'Buscar um elemento no vetor',
        'Remover elementos duplicados'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O objetivo do algoritmo é ordenar o vetor em ordem crescente.',
      feedbackIncorrect: 'A resposta correta é: Ordenar elementos em ordem crescente.',
    ),
    NewContentTask(
      id: '18_2',
      title: 'Pergunta 2',
      description: 'Na linha 2, qual é o papel da variável "trocou"?',
      content: bubbleSortCode,
      options: [
        'Contar quantas trocas foram realizadas',
        'Indicar se houve trocas na iteração atual',
        'Armazenar o valor máximo encontrado',
        'Definir o tamanho do vetor'
      ],
      correctOptionIndex: 1,
      feedbackCorrect: 'Correto! A variável "trocou" indica se houve trocas na iteração atual.',
      feedbackIncorrect: 'A resposta correta é: Indicar se houve trocas na iteração atual.',
    ),
    NewContentTask(
      id: '18_3',
      title: 'Pergunta 3',
      description: 'Na linha 3, qual é o papel do loop externo "for"?',
      content: bubbleSortCode,
      options: [
        'Percorrer todos os elementos do vetor',
        'Comparar elementos adjacentes diretamente',
        'Executar apenas uma passagem para ordenar',
        'Finalizar o algoritmo automaticamente'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O loop externo controla o número de passagens necessárias para ordenar o vetor.',
      feedbackIncorrect: 'A resposta correta é: Percorrer todos os elementos do vetor.',
    ),
    NewContentTask(
      id: '18_4',
      title: 'Pergunta 4',
      description: 'Na linha 6, qual condição determina quando uma troca deve ocorrer?',
      content: bubbleSortCode,
      options: [
        'if(v[j] < v[j+1])',
        'if(v[j] > v[j+1])',
        'if(v[j] == v[j+1])',
        'if(v[j] != v[j+1])'
      ],
      correctOptionIndex: 1,
      feedbackCorrect: 'Correto! A condição "if(v[j] > v[j+1])" identifica quando os elementos estão fora de ordem.',
      feedbackIncorrect: 'A resposta correta é: if(v[j] > v[j+1]).',
    ),
    NewContentTask(
      id: '18_5',
      title: 'Pergunta 5',
      description: 'Na linha 13, por que usamos "if(!trocou) break;"?',
      content: bubbleSortCode,
      options: [
        'Para reiniciar o algoritmo quando não há trocas',
        'Para encerrar a execução do algoritmo mais cedo',
        'Para inverter a ordem dos elementos',
        'Para garantir que todos os elementos foram percorridos'
      ],
      correctOptionIndex: 1,
      feedbackCorrect: 'Correto! Esse comando encerra o algoritmo quando não há mais trocas, otimizando a execução.',
      feedbackIncorrect: 'A resposta correta é: Para encerrar a execução do algoritmo mais cedo.',
    ),
  ],
),




NewContentLevel(
  id: 19,
  title: 'Bubble Sort - Funcionamento Detalhado',
  description:
      'Aprofunde seus conhecimentos sobre como o Bubble Sort organiza os elementos',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content: bubbleSortCode,
  isLocked: false,
  feedbackSuccess:
      "Você entendeu a lógica interna do Bubble Sort! Continue avançando!",
  feedbackFailure: "Revise a lógica de funcionamento e tente novamente!",
  tasks: [
    NewContentTask(
      id: '19_1',
      title: 'Pergunta 6',
      description:
          'O que acontece se a condição "if(v[j] > v[j+1])" (linha 6) for verdadeira?',
      content: bubbleSortCode,
      options: [
        'Nada, o algoritmo continua normalmente',
        'Os elementos são ignorados',
        'Os elementos são trocados de posição',
        'O algoritmo é interrompido'
      ],
      correctOptionIndex: 2,
      feedbackCorrect: 'Correto! Quando a condição é verdadeira, os elementos são trocados.',
      feedbackIncorrect: 'Ops!!! Quase lá! A resposta correta é: Os elementos são trocados de posição.',
    ),
    NewContentTask(
      id: '19_2',
      title: 'Pergunta 7',
      description:
          'Qual será o resultado final do código se o vetor inicial for [5, 3, 8, 1]?',
      content: bubbleSortCode,
      options: [
        '[1, 3, 5, 8]',
        '[8, 5, 3, 1]',
        '[5, 1, 8, 3]',
        '[3, 1, 5, 8]'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O vetor será ordenado em ordem crescente.',
      feedbackIncorrect: 'A resposta correta é: [1, 3, 5, 8].',
    ),
    NewContentTask(
      id: '19_3',
      title: 'Pergunta 8',
      description:
          'Em qual parte do código (linha 5-9) o maior elemento vai sendo deslocado para o final do vetor?',
      content: bubbleSortCode,
      options: [
        'Durante a definição de n',
        'No loop externo (linha 3)',
        'No loop interno e na troca de elementos (linhas 5-9)',
        'Após o algoritmo terminar'
      ],
      correctOptionIndex: 2,
      feedbackCorrect: 'Correto! O deslocamento ocorre no loop interno, onde as trocas são feitas.',
      feedbackIncorrect: 'A resposta correta é: No loop interno e na troca de elementos (linhas 5-9).',
    ),
    NewContentTask(
      id: '19_4',
      title: 'Pergunta 9',
      description:
          'Qual é a complexidade de tempo do Bubble Sort no pior caso?',
      content: bubbleSortCode,
      options: ['O(n)', 'O(log n)', 'O(n²)', 'O(2ⁿ)'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Correto! No pior caso, o Bubble Sort precisa comparar todos os elementos várias vezes.',
      feedbackIncorrect: 'A resposta correta é: O(n²).',
    ),
    NewContentTask(
      id: '19_5',
      title: 'Pergunta 10',
      description:
          'O algoritmo funciona corretamente para quais tipos de vetor?',
      content: bubbleSortCode,
      options: [
        'Vetores com números positivos',
        'Vetores com números negativos',
        'Vetores com números positivos e negativos',
        'Todas as opções acima'
      ],
      correctOptionIndex: 3,
      feedbackCorrect: 'Correto! O Bubble Sort funciona para qualquer tipo de número.',
      feedbackIncorrect: 'A resposta correta é: Todas as opções acima.',
    ),
  ],
),

// 20
 NewContentLevel(
  id: 20,
  title: 'Bubble Sort - Casos Especiais e Alterações',
  description:
      'Explore casos específicos, estabilidade e modificações no Bubble Sort',
  difficulty: NewContentDifficulty.avancado,
  theme: 'Algoritmos de Ordenação',
  content: bubbleSortCode,
  isLocked: false,
  feedbackSuccess: "Excelente! Você domina os detalhes do Bubble Sort!",
  feedbackFailure: "Revise os conceitos avançados e tente novamente!",
  tasks: [
    NewContentTask(
      id: '20_1',
      title: 'Pergunta 11',
      description:
          'O que aconteceria se removêssemos a linha de troca de elementos (linhas 7-9)?',
      content: bubbleSortCode,
      options: [
        'A lista ainda seria ordenada, mas mais devagar',
        'O algoritmo deixaria de ordenar corretamente',
        'O algoritmo se tornaria mais eficiente',
        'Nada mudaria no resultado'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! Sem a linha de troca, o algoritmo não ordena a lista.',
      feedbackIncorrect:
          'A resposta correta é: O algoritmo deixaria de ordenar corretamente.',
    ),
    NewContentTask(
      id: '20_2',
      title: 'Pergunta 12',
      description: 'O Bubble Sort é considerado um algoritmo:',
      content: bubbleSortCode,
      options: [
        'Estável, pois não troca elementos iguais de posição',
        'Instável, pois sempre troca elementos iguais',
        'Recursivo por natureza',
        'Não determinístico'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O Bubble Sort preserva a ordem de elementos iguais, por isso é estável.',
      feedbackIncorrect:
          'A resposta correta é: Estável, pois não troca elementos iguais de posição.',
    ),
    NewContentTask(
      id: '20_3',
      title: 'Pergunta 13',
      description:
          'Se o vetor tiver apenas 1 elemento, quantas vezes o loop externo (linha 3) será executado?',
      content: bubbleSortCode,
      options: ['0 vezes', '1 vez', 'n - 1 vezes', 'Não é possível saber'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! Mesmo com 1 elemento, o loop externo roda 1 vez, mas não realiza nenhuma troca.',
      feedbackIncorrect: 'A resposta correta é: 1 vez.',
    ),
    NewContentTask(
      id: '20_4',
      title: 'Pergunta 14',
      description: 'Qual seria o melhor caso para o Bubble Sort?',
      content: bubbleSortCode,
      options: [
        'Quando o vetor está completamente desordenado',
        'Quando o vetor já está ordenado',
        'Quando o vetor possui muitos elementos iguais',
        'Quando o vetor contém apenas números negativos'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! O melhor caso ocorre quando o vetor já está ordenado.',
      feedbackIncorrect:
          'A resposta correta é: Quando o vetor já está ordenado.',
    ),
    NewContentTask(
      id: '20_5',
      title: 'Pergunta 15',
      description:
          'Se quisermos modificar o código para ordenar em ordem decrescente, o que precisamos alterar (linha 6)?',
      content: bubbleSortCode,
      options: [
        'Trocar o ">" por "<" na condição',
        'Alterar "n - i - 1" para "n + i + 1"',
        'Inverter o loop externo',
        'Nada precisa ser alterado'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Alterando o sinal para "<", o algoritmo passa a ordenar em ordem decrescente.',
      feedbackIncorrect:
          'A resposta correta é: Trocar o ">" por "<" na condição.',
    ),
  ],
),

// 21

NewContentLevel(
  id: 21,
  title: 'Selection Sort - Conceitos Básicos',
  description: 'Aprenda os conceitos fundamentais do algoritmo Selection Sort',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content: selectionSortCode,
  isLocked: false,
  feedbackSuccess: "Parabéns! Você dominou os conceitos iniciais do Selection Sort!",
  feedbackFailure: "Revise os conceitos iniciais e tente novamente!",
  tasks: [
    NewContentTask(
      id: '21_6',
      title: 'Pergunta 6',
      description: 'O que acontece se "min_idx" nunca for alterado durante o loop interno (linhas 8-12)?',
      content: selectionSortCode,
      options: [
        'O elemento atual já é o menor do restante e será trocado consigo mesmo',
        'O vetor ficará desordenado',
        'O algoritmo entrará em loop infinito',
        'O loop externo será interrompido'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! Se min_idx não muda, o elemento atual já está na posição correta.',
      feedbackIncorrect: 'A resposta correta é: O elemento atual já é o menor do restante e será trocado consigo mesmo.',
    ),
    NewContentTask(
      id: '21_7',
      title: 'Pergunta 7',
      description: 'Qual linha efetivamente realiza a troca dos elementos?',
      content: selectionSortCode,
      options: [
        'Linha 6',
        'Linha 10',
        'Linhas 14-16',
        'Linha 9'
      ],
      correctOptionIndex: 2,
      feedbackCorrect: 'Correto! As linhas 14-16 realizam a troca do menor elemento encontrado.',
      feedbackIncorrect: 'A resposta correta é: Linhas 14-16.',
    ),
    NewContentTask(
      id: '21_8',
      title: 'Pergunta 8',
      description: 'O que a linha 5 controla no algoritmo?',
      content: selectionSortCode,
      options: [
        'O loop externo que percorre cada posição do vetor',
        'O loop interno que busca o menor elemento',
        'A inicialização de min_idx',
        'A troca final dos elementos'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O loop externo percorre cada posição do vetor para ordenar.',
      feedbackIncorrect: 'A resposta correta é: O loop externo que percorre cada posição do vetor.',
    ),
    NewContentTask(
      id: '21_9',
      title: 'Pergunta 9',
      description: 'Se o vetor já estiver ordenado, qual será o comportamento do algoritmo?',
      content: selectionSortCode,
      options: [
        'Ele ainda fará todas as comparações e trocas',
        'Ele detectará que está ordenado e sairá antecipadamente',
        'Ele fará apenas o loop externo',
        'Não funcionará corretamente'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! O Selection Sort não possui otimização para detectar vetor já ordenado e realizará todas as comparações.',
      feedbackIncorrect: 'A resposta correta é: Ele ainda fará todas as comparações e trocas.',
    ),
    NewContentTask(
      id: '21_10',
      title: 'Pergunta 10',
      description: 'Qual é a complexidade de tempo do Selection Sort no pior caso?',
      content: selectionSortCode,
      options: [
        'O(n)',
        'O(n log n)',
        'O(n²)',
        'O(2ⁿ)'
      ],
      correctOptionIndex: 2,
      feedbackCorrect: 'Correto! O Selection Sort sempre percorre o vetor inteiro em dois loops, resultando em O(n²).',
      feedbackIncorrect: 'A resposta correta é: O(n²).',
    ),
  ],
),



NewContentLevel(
  id: 22,
  title: 'Selection Sort - Funcionamento Detalhado',
  description:
      'Aprofunde seus conhecimentos sobre como o Selection Sort organiza os elementos',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content: selectionSortCode,
  isLocked: false,
  feedbackSuccess: "Você entendeu a lógica interna do Selection Sort! Continue avançando!",
  feedbackFailure: "Revise a lógica de funcionamento e tente novamente!",
  tasks: [
    NewContentTask(
      id: '22_1',
      title: 'Pergunta 6',
      description:
          'O que a linha 6 (min_idx = i) realiza no algoritmo?',
      content: selectionSortCode,
      options: [
        'Inicializa o índice do menor elemento encontrado até agora',
        'Define o tamanho do vetor',
        'Troca o elemento atual com outro',
        'Controla o loop interno'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! min_idx é inicializado com a posição atual do loop externo.',
      feedbackIncorrect: 'A resposta correta é: Inicializa o índice do menor elemento encontrado até agora.',
    ),
    NewContentTask(
      id: '22_2',
      title: 'Pergunta 7',
      description:
          'Qual é a função do loop interno (linhas 8-12)?',
      content: selectionSortCode,
      options: [
        'Percorrer o vetor inteiro novamente a cada iteração',
        'Encontrar o menor elemento restante do vetor',
        'Ordenar diretamente os elementos adjacentes',
        'Inicializar min_idx'
      ],
      correctOptionIndex: 1,
      feedbackCorrect: 'Correto! O loop interno localiza o menor elemento no restante do vetor.',
      feedbackIncorrect: 'A resposta correta é: Encontrar o menor elemento restante do vetor.',
    ),
    NewContentTask(
      id: '22_3',
      title: 'Pergunta 8',
      description:
          'O que a linha 9 (if(vet[j] < vet[min_idx])) verifica?',
      content: selectionSortCode,
      options: [
        'Se o vetor está vazio',
        'Se o elemento atual é menor que o menor encontrado até agora',
        'Se os elementos precisam ser trocados',
        'Se min_idx é válido'
      ],
      correctOptionIndex: 1,
      feedbackCorrect: 'Correto! A comparação identifica se há um elemento menor que o atual menor.',
      feedbackIncorrect: 'A resposta correta é: Se o elemento atual é menor que o menor encontrado até agora.',
    ),
    NewContentTask(
      id: '22_4',
      title: 'Pergunta 9',
      description:
          'Qual é o propósito das linhas 14-16?',
      content: selectionSortCode,
      options: [
        'Colocar o menor elemento encontrado na posição correta',
        'Inverter todo o vetor',
        'Eliminar elementos duplicados',
        'Incrementar min_idx'
      ],
      correctOptionIndex: 0,
      feedbackCorrect: 'Correto! Essas linhas realizam a troca para posicionar corretamente o menor elemento.',
      feedbackIncorrect: 'A resposta correta é: Colocar o menor elemento encontrado na posição correta.',
    ),
    NewContentTask(
      id: '22_5',
      title: 'Pergunta 10',
      description:
          'O que aconteceria se removêssemos a troca de elementos (linhas 14-16)?',
      content: selectionSortCode,
      options: [
        'O algoritmo ainda ordenaria corretamente',
        'O algoritmo deixaria de ordenar corretamente',
        'O algoritmo ficaria mais eficiente',
        'Nada mudaria'
      ],
      correctOptionIndex: 1,
      feedbackCorrect: 'Correto! Sem a troca, os elementos não seriam posicionados corretamente.',
      feedbackIncorrect: 'A resposta correta é: O algoritmo deixaria de ordenar corretamente.',
    ),
  ],
),

// 23

 NewContentLevel(
  id: 23,
  title: 'Selection Sort - Casos Especiais e Alterações',
  description:
      'Explore casos específicos e possíveis modificações no Selection Sort',
  difficulty: NewContentDifficulty.iniciante,
  theme: 'Algoritmos de Ordenação',
  content: selectionSortCode,
  isLocked: false,
  feedbackSuccess: "Excelente! Você domina os detalhes do Selection Sort!",
  feedbackFailure: "Revise os conceitos avançados e tente novamente!",
  tasks: [
    NewContentTask(
      id: '23_1',
      title: 'Pergunta 11',
      description:
          'Se o vetor já estiver ordenado, qual será o comportamento do algoritmo?',
      content: selectionSortCode,
      options: [
        'O algoritmo será mais rápido e fará menos comparações',
        'O algoritmo ainda fará todas as comparações, mas fará apenas trocas redundantes (um elemento com ele mesmo)',
        'O algoritmo vai inverter o vetor',
        'O algoritmo parará imediatamente'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! Mesmo com o vetor ordenado, todas as comparações ainda são realizadas, mas nenhuma troca ocorre.',
      feedbackIncorrect:
          'A resposta correta é: O algoritmo ainda fará todas as comparações, mas não fará trocas.',
    ),
    NewContentTask(
      id: '23_2',
      title: 'Pergunta 12',
      description: 'Qual seria o melhor caso para o Selection Sort?',
      content: selectionSortCode,
      options: [
        'Quando o vetor está completamente desordenado',
        'Quando o vetor já está ordenado',
        'Quando o vetor possui apenas números negativos',
        'Quando o vetor contém números duplicados'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! O melhor caso ocorre quando o vetor já está ordenado, pois não haverá trocas desnecessárias.',
      feedbackIncorrect: 'A resposta correta é: Quando o vetor já está ordenado.',
    ),
    NewContentTask(
      id: '23_3',
      title: 'Pergunta 13',
      description:
          'Se quisermos modificar o código para ordenar em ordem decrescente, o que precisamos alterar?',
      content: selectionSortCode,
      options: [
        'Trocar o sinal "<" por ">" na comparação',
        'Alterar o limite do loop interno',
        'Inverter o loop externo',
        'Nenhuma alteração é necessária'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! Alterando o operador para ">", o algoritmo passa a ordenar do maior para o menor.',
      feedbackIncorrect:
          'A resposta correta é: Trocar o sinal "<" por ">" na comparação.',
    ),
    NewContentTask(
      id: '23_4',
      title: 'Pergunta 14',
      description: 'Qual é o critério de parada do Selection Sort?',
      content: selectionSortCode,
      options: [
        'Quando encontra o maior elemento',
        'Quando percorre todo o vetor',
        'Quando não há mais trocas possíveis',
        'Quando o primeiro elemento está correto'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! O algoritmo só termina após percorrer todas as posições do vetor.',
      feedbackIncorrect: 'A resposta correta é: Quando percorre todo o vetor.',
    ),
    NewContentTask(
      id: '23_5',
      title: 'Pergunta 15',
      description:
          'Qual é a principal diferença entre Bubble Sort e Selection Sort?',
      content: selectionSortCode,
      options: [
        'O Bubble Sort encontra o maior elemento primeiro, e o Selection Sort encontra o menor',
        'O Bubble Sort troca elementos a cada comparação, e o Selection Sort troca apenas uma vez por iteração',
        'O Selection Sort é recursivo, e o Bubble Sort é iterativo',
        'Ambos possuem complexidades diferentes'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! No Selection Sort, a troca ocorre apenas uma vez por iteração, diferente do Bubble Sort.',
      feedbackIncorrect:
          'A resposta correta é: O Bubble Sort troca elementos a cada comparação, e o Selection Sort troca apenas uma vez por iteração.',
    ),
  ],
),

  NewContentLevel(
  id: 24,
  title: 'Insertion Sort - Analisando o Funcionamento',
  description:
      'Aprofunde seus conhecimentos sobre como o Insertion Sort organiza os elementos.',
  difficulty: NewContentDifficulty.intermediario,
  theme: 'Algoritmos de Ordenação',
  content: insertionSortCode,
  isLocked: false,
  feedbackSuccess:
      "Excelente! Você está dominando o funcionamento interno do Insertion Sort.",
  feedbackFailure:
      "Revise o comportamento do algoritmo e tente novamente!",
  tasks: [
    NewContentTask(
      id: '24_1',
      title: 'Pergunta 1',
      description:
          'Em qual situação o Insertion Sort realiza menos movimentações de elementos?',
      content: insertionSortCode,
      options: [
        'Quando o vetor está em ordem crescente',
        'Quando o vetor está totalmente desordenado',
        'Quando todos os elementos são iguais',
        'Quando o vetor contém números negativos'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! No melhor caso, quando o vetor já está ordenado, o while nunca executa.',
      feedbackIncorrect:
          'A resposta correta é: Quando o vetor está em ordem crescente.',
    ),
    NewContentTask(
      id: '24_2',
      title: 'Pergunta 2',
      description: 'O que acontece se o vetor já estiver ordenado no início?',
      content: insertionSortCode,
      options: [
        'O algoritmo ainda realiza trocas desnecessárias',
        'O loop while nunca é executado, tornando o algoritmo mais rápido',
        'O vetor é invertido automaticamente',
        'O algoritmo para imediatamente'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exato! Se o vetor já estiver ordenado, o while não executa e o algoritmo roda em tempo quase linear.',
      feedbackIncorrect:
          'A resposta correta é: O loop while nunca é executado, tornando o algoritmo mais rápido.',
    ),
    NewContentTask(
      id: '24_3',
      title: 'Pergunta 3',
      description:
          'Por que o algoritmo começa armazenando o valor atual em x antes de deslocar os elementos?',
      content: insertionSortCode,
      options: [
        'Para que o valor não seja sobrescrito durante os deslocamentos',
        'Para melhorar o consumo de memória',
        'Para aumentar a velocidade do algoritmo',
        'Para permitir que o C interprete o código corretamente'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! A variável "x" evita que o valor original seja perdido enquanto os elementos são movidos.',
      feedbackIncorrect:
          'A resposta correta é: Para que o valor não seja sobrescrito durante os deslocamentos.',
    ),
    NewContentTask(
      id: '24_4',
      title: 'Pergunta 4',
      description:
          'No pior caso, quantas comparações o Insertion Sort pode fazer em um vetor de tamanho n?',
      content: insertionSortCode,
      options: ['O(n)', 'O(n log n)', 'O(n²)', 'O(log n)'],
      correctOptionIndex: 2,
      feedbackCorrect:
          'Exato! No pior caso, cada elemento precisa ser comparado com todos os anteriores, resultando em O(n²).',
      feedbackIncorrect: 'A resposta correta é: O(n²).',
    ),
    NewContentTask(
      id: '24_5',
      title: 'Pergunta 5',
      description:
          'Por que o Insertion Sort é considerado mais eficiente que o Bubble Sort para vetores pequenos?',
      content: insertionSortCode,
      options: [
        'Porque realiza menos trocas e aproveita vetores parcialmente ordenados',
        'Porque sempre ordena em O(log n)',
        'Porque utiliza estruturas de dados mais complexas',
        'Porque executa operações em paralelo'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O Insertion Sort se beneficia de vetores parcialmente ordenados, evitando trocas desnecessárias.',
      feedbackIncorrect:
          'A resposta correta é: Porque realiza menos trocas e aproveita vetores parcialmente ordenados.',
    ),
  ],
),

// 25
 NewContentLevel(
  id: 25,
  title: 'Insertion Sort - Comparações e Desempenho',
  description:
      'Analise o desempenho e compare o Insertion Sort com outros algoritmos.',
  difficulty: NewContentDifficulty.avancado,
  theme: 'Algoritmos de Ordenação',
  content: insertionSortCode, // usando a variável global em C
  isLocked: false,
  feedbackSuccess:
      "Parabéns! Você concluiu o nível avançado do Insertion Sort!",
  feedbackFailure:
      "Estude mais sobre análise de algoritmos e tente novamente!",
  tasks: [
    NewContentTask(
      id: '25_1',
      title: '💡 Pergunta 1',
      description: 'Qual é a **complexidade de espaço** do Insertion Sort?',
      content: insertionSortCode,
      options: ['O(n)', 'O(1)', 'O(n log n)', 'O(n²)'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! O Insertion Sort é **in-place**, não precisa de memória extra significativa, então sua complexidade de espaço é O(1).',
      feedbackIncorrect: 'A resposta correta é: O(1).',
    ),
    NewContentTask(
      id: '25_2',
      title: '💡 Pergunta 2',
      description:
          'Se o vetor tiver 1.000 elementos e já estiver quase ordenado, qual algoritmo geralmente é mais eficiente?',
      content: insertionSortCode,
      options: ['Insertion Sort', 'Merge Sort', 'Heap Sort', 'Quick Sort'],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Exato! O Insertion Sort é ótimo para vetores pequenos ou quase ordenados.',
      feedbackIncorrect: 'A resposta correta é: Insertion Sort.',
    ),
    NewContentTask(
      id: '25_3',
      title: '💡 Pergunta 3',
      description:
          'Qual a diferença principal entre Insertion Sort e Selection Sort?',
      content: insertionSortCode,
      options: [
        'O Insertion Sort insere elementos no local correto, enquanto o Selection Sort troca o menor elemento com a posição inicial da parte não ordenada',
        'O Selection Sort é sempre mais rápido que o Insertion Sort',
        'O Insertion Sort precisa de um vetor auxiliar',
        'O Selection Sort usa recursão e o Insertion Sort não'
      ],
      correctOptionIndex: 0,
      feedbackCorrect:
          'Correto! O Selection Sort busca o menor elemento e troca, enquanto o Insertion Sort insere diretamente na posição correta.',
      feedbackIncorrect:
          'A resposta correta é: O Insertion Sort insere elementos no local correto, enquanto o Selection Sort troca o menor elemento com a posição inicial da parte não ordenada.',
    ),
    NewContentTask(
      id: '25_4',
      title: '💡 Pergunta 4',
      description:
          'Por que o Insertion Sort não é adequado para vetores muito grandes?',
      content: insertionSortCode,
      options: [
        'Porque consome muita memória',
        'Porque sua complexidade de tempo no pior caso é O(n²)',
        'Porque não consegue lidar com números negativos',
        'Porque precisa de threads para funcionar'
      ],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Correto! Para vetores grandes, algoritmos como Merge Sort ou Quick Sort são muito mais rápidos.',
      feedbackIncorrect:
          'A resposta correta é: Porque sua complexidade de tempo no pior caso é O(n²).',
    ),
    NewContentTask(
      id: '25_5',
      title: '💡 Pergunta 5',
      description:
          'Qual dos seguintes algoritmos pode ser mais rápido que o Insertion Sort para vetores grandes e desordenados?',
      content: insertionSortCode,
      options: ['Bubble Sort', 'Merge Sort', 'Selection Sort', 'Counting Sort'],
      correctOptionIndex: 1,
      feedbackCorrect:
          'Exato! O Merge Sort tem complexidade O(n log n), sendo mais eficiente que o Insertion Sort em vetores grandes.',
      feedbackIncorrect: 'Ops!!!',
    ),
  ],
),

 
  


];
