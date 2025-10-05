import 'package:flutter/material.dart';
import 'Telas/telaInicial/tela-inicial.dart';
import 'Telas/conceitos-introducao/tela-conceitos-iniciais.dart';
import 'Telas/conceitos-introducao/tela-condicao.dart';
import 'Telas/conceitos-introducao/tela-repeticao.dart';
import 'Telas/conceitos-introducao/tela-vetores.dart';
import 'Telas/conceitos-introducao/tela-tipos-dados.dart';
import 'Telas/conceitos-introducao/tela-operadores.dart';
import 'Telas/conceitos-introducao/tela-funcoes.dart';
import 'Telas/conceitos-introducao/tela-entrada-saida-dados.dart';
import 'Telas/conceitos-introducao/tela-variaveis.dart';
import 'Telas/jogo-introducao/quiz_levels_screen.dart';
import 'Telas/jogo-introducao/quiz_tasks_screen.dart';
import 'Telas/telaInicial/tela-guia-de-estudos.dart';
import 'Telas/desafios/tela-novos-desafios.dart';
import 'Telas/onboarding/telas-onboarding.dart';
import 'Telas/login/tela-login.dart';
import 'Telas/login/tela-registro.dart';
import 'models/quiz_models.dart';
import 'Telas/telaInicial/tela-referencias.dart';
import 'Telas/conceitos-introducao/tela-ponteiros.dart';

class AppRoutes {
  static const String home = '/';
  static const String basicConcepts = '/basic-concepts';
  static const String ifElse = '/if-else';
  static const String loops = '/loops';
  static const String lists = '/lists';
  static const String variables = '/variables';
  static const String dataTypes = '/data-types';
  static const String operators = '/operators';
  static const String functions = '/functions';
  static const String inputOutput = '/input-output';
  static const String quizLevels = '/quiz-levels';
  static const String quizTasks = '/quiz-tasks';
  static const String studyGuide = '/study-guide';
  static const String challengeHub = '/challenge-hub';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String references = '/references';
  static const String pointers = '/pointers';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      basicConcepts: (context) => const BasicConceptsScreen(),
      ifElse: (context) => const IfElseScreenC(),
      loops: (context) => const LoopsScreenC(),
      lists: (context) => const ArraysScreenC(),
      variables: (context) => const VariablesScreen(),
      dataTypes: (context) => const DataTypesScreen(),
      operators: (context) => const OperatorsScreenC(),
      functions: (context) => const FunctionsScreenC(),
      inputOutput: (context) => const InputOutputScreen(),
      quizLevels: (context) => const QuizLevelsScreen(),
      pointers: (context) => const PointersScreen(),
      quizTasks: (context) {
        final level = ModalRoute.of(context)!.settings.arguments as QuizLevel;
        return QuizTasksScreen(level: level);
      },
      studyGuide: (context) => const StudyGuideScreen(),
      challengeHub: (context) => const ChallengeHubScreen(),
      onboarding: (context) => const OnboardingScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      references: (context) => const StudyReferencesScreen(),
    };
  }
} 