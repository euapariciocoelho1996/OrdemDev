enum AchievementType {
  firstSteps,      // Primeiros passos
  quickLearner,    // Aprendiz rápido
  persistent,       // Persistente
  perfectionist,   // Perfeccionista
  speedDemon,      // Demon da velocidade
  master,          // Mestre
  explorer,        // Explorador
  challenger,      // Desafiador
  streakKeeper,    // Mantenedor de sequência
  social,          // Social
}

enum AchievementRarity {
  common,    // Comum - Bronze
  rare,      // Raro - Prata
  epic,      // Épico - Ouro
  legendary, // Lendário - Diamante
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconData;
  final AchievementType type;
  final AchievementRarity rarity;
  final int points;
  final List<String> requirements;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String? category;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconData,
    required this.type,
    required this.rarity,
    required this.points,
    required this.requirements,
    this.isUnlocked = false,
    this.unlockedAt,
    this.category,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? iconData,
    AchievementType? type,
    AchievementRarity? rarity,
    int? points,
    List<String>? requirements,
    bool? isUnlocked,
    DateTime? unlockedAt,
    String? category,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconData: iconData ?? this.iconData,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      points: points ?? this.points,
      requirements: requirements ?? this.requirements,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconData': iconData,
      'type': type.toString(),
      'rarity': rarity.toString(),
      'points': points,
      'requirements': requirements,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.millisecondsSinceEpoch,
      'category': category,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconData: json['iconData'],
      type: AchievementType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      rarity: AchievementRarity.values.firstWhere(
        (e) => e.toString() == json['rarity'],
      ),
      points: json['points'],
      requirements: List<String>.from(json['requirements']),
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['unlockedAt'])
          : null,
      category: json['category'],
    );
  }
}

class AchievementProgress {
  final String achievementId;
  final Map<String, dynamic> currentProgress;
  final bool isCompleted;
  final double completionPercentage;

  const AchievementProgress({
    required this.achievementId,
    required this.currentProgress,
    required this.isCompleted,
    required this.completionPercentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'achievementId': achievementId,
      'currentProgress': currentProgress,
      'isCompleted': isCompleted,
      'completionPercentage': completionPercentage,
    };
  }

  factory AchievementProgress.fromJson(Map<String, dynamic> json) {
    return AchievementProgress(
      achievementId: json['achievementId'],
      currentProgress: Map<String, dynamic>.from(json['currentProgress']),
      isCompleted: json['isCompleted'],
      completionPercentage: json['completionPercentage'].toDouble(),
    );
  }
}

// Classe para definir conquistas pré-definidas
class AchievementDefinitions {
  static List<Achievement> get allAchievements => [
    // Conquistas de Primeiros Passos
    Achievement(
      id: 'first_login',
      title: 'Primeiro Login',
      description: 'Faça seu primeiro login no aplicativo',
      iconData: 'Icons.login',
      type: AchievementType.firstSteps,
      rarity: AchievementRarity.common,
      points: 10,
      requirements: ['Fazer login pela primeira vez'],
      category: 'Primeiros Passos',
    ),
    
    Achievement(
      id: 'first_concept',
      title: 'Primeiro Conceito',
      description: 'Complete seu primeiro conceito de programação',
      iconData: 'Icons.school',
      type: AchievementType.firstSteps,
      rarity: AchievementRarity.common,
      points: 15,
      requirements: ['Completar 1 conceito'],
      category: 'Primeiros Passos',
    ),

    Achievement(
      id: 'first_quiz',
      title: 'Primeiro Quiz',
      description: 'Complete seu primeiro quiz com sucesso',
      iconData: 'Icons.quiz',
      type: AchievementType.firstSteps,
      rarity: AchievementRarity.common,
      points: 20,
      requirements: ['Completar 1 quiz'],
      category: 'Primeiros Passos',
    ),

    // Conquistas de Aprendizado Rápido
    Achievement(
      id: 'quick_learner',
      title: 'Aprendiz Rápido',
      description: 'Complete 5 conceitos em menos de 1 hora',
      iconData: 'Icons.flash_on',
      type: AchievementType.quickLearner,
      rarity: AchievementRarity.rare,
      points: 50,
      requirements: ['Completar 5 conceitos', 'Em menos de 60 minutos'],
      category: 'Velocidade',
    ),

    Achievement(
      id: 'speed_reader',
      title: 'Leitor Veloz',
      description: 'Leia 10 conceitos em sequência sem pausas',
      iconData: 'Icons.speed',
      type: AchievementType.speedDemon,
      rarity: AchievementRarity.rare,
      points: 40,
      requirements: ['Ler 10 conceitos consecutivos'],
      category: 'Velocidade',
    ),

    // Conquistas de Persistência
    Achievement(
      id: 'week_streak',
      title: 'Semana de Dedicação',
      description: 'Use o aplicativo por 7 dias consecutivos',
      iconData: 'Icons.calendar_today',
      type: AchievementType.streakKeeper,
      rarity: AchievementRarity.epic,
      points: 100,
      requirements: ['7 dias consecutivos de uso'],
      category: 'Persistência',
    ),

    Achievement(
      id: 'month_streak',
      title: 'Mês de Dedicação',
      description: 'Use o aplicativo por 30 dias consecutivos',
      iconData: 'Icons.calendar_month',
      type: AchievementType.streakKeeper,
      rarity: AchievementRarity.legendary,
      points: 500,
      requirements: ['30 dias consecutivos de uso'],
      category: 'Persistência',
    ),

    // Conquistas de Perfeccionismo
    Achievement(
      id: 'perfect_score',
      title: 'Pontuação Perfeita',
      description: 'Obtenha 100% em 10 quizzes consecutivos',
      iconData: 'Icons.star',
      type: AchievementType.perfectionist,
      rarity: AchievementRarity.epic,
      points: 200,
      requirements: ['100% em 10 quizzes consecutivos'],
      category: 'Perfeição',
    ),

    Achievement(
      id: 'no_mistakes',
      title: 'Sem Erros',
      description: 'Complete 20 exercícios sem cometer erros',
      iconData: 'Icons.check_circle',
      type: AchievementType.perfectionist,
      rarity: AchievementRarity.legendary,
      points: 300,
      requirements: ['20 exercícios sem erros'],
      category: 'Perfeição',
    ),

    // Conquistas de Mestria
    Achievement(
      id: 'concept_master',
      title: 'Mestre dos Conceitos',
      description: 'Complete todos os conceitos disponíveis',
      iconData: 'Icons.emoji_events',
      type: AchievementType.master,
      rarity: AchievementRarity.legendary,
      points: 1000,
      requirements: ['Completar todos os conceitos'],
      category: 'Mestria',
    ),

    Achievement(
      id: 'quiz_master',
      title: 'Mestre dos Quizzes',
      description: 'Complete todos os quizzes disponíveis',
      iconData: 'Icons.quiz',
      type: AchievementType.master,
      rarity: AchievementRarity.legendary,
      points: 1000,
      requirements: ['Completar todos os quizzes'],
      category: 'Mestria',
    ),

    // Conquistas de Exploração
    Achievement(
      id: 'explorer',
      title: 'Explorador',
      description: 'Acesse todas as seções do aplicativo',
      iconData: 'Icons.explore',
      type: AchievementType.explorer,
      rarity: AchievementRarity.rare,
      points: 75,
      requirements: ['Acessar todas as seções'],
      category: 'Exploração',
    ),

    Achievement(
      id: 'night_owl',
      title: 'Coruja Noturna',
      description: 'Use o aplicativo entre 22h e 6h',
      iconData: 'Icons.nightlight',
      type: AchievementType.explorer,
      rarity: AchievementRarity.common,
      points: 25,
      requirements: ['Usar entre 22h e 6h'],
      category: 'Exploração',
    ),

    // Conquistas de Desafios
    Achievement(
      id: 'challenge_accepted',
      title: 'Desafio Aceito',
      description: 'Complete seu primeiro desafio aleatório',
      iconData: 'Icons.psychology',
      type: AchievementType.challenger,
      rarity: AchievementRarity.rare,
      points: 60,
      requirements: ['Completar 1 desafio aleatório'],
      category: 'Desafios',
    ),

    Achievement(
      id: 'challenge_master',
      title: 'Mestre dos Desafios',
      description: 'Complete 50 desafios aleatórios',
      iconData: 'Icons.military_tech',
      type: AchievementType.challenger,
      rarity: AchievementRarity.legendary,
      points: 800,
      requirements: ['Completar 50 desafios aleatórios'],
      category: 'Desafios',
    ),
  ];

  static List<Achievement> getAchievementsByCategory(String category) {
    return allAchievements.where((a) => a.category == category).toList();
  }

  static List<Achievement> getAchievementsByRarity(AchievementRarity rarity) {
    return allAchievements.where((a) => a.rarity == rarity).toList();
  }

  static List<String> getCategories() {
    return allAchievements
        .map((a) => a.category)
        .where((c) => c != null)
        .cast<String>()
        .toSet()
        .toList();
  }
}

