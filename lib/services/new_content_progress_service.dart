import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewContentProgressService {
  static const String _completedLevelsKey = 'new_content_completed_levels';
  static const String _unlockedLevelsKey = 'new_content_unlocked_levels';
  static const String _userScoreKey = 'new_content_user_score';
  static const String _userBestStreakKey = 'new_content_user_best_streak';

  static Future<List<int>> getCompletedLevels() async {
    // Primeiro tenta buscar do Firebase
    final firebaseLevels = await _getCompletedLevelsFromFirebase();
    if (firebaseLevels.isNotEmpty) {
      // Sincroniza com o local
      await _saveCompletedLevelsToLocal(firebaseLevels);
      return firebaseLevels;
    }
    
    // Se não houver no Firebase, busca do local
    final prefs = await SharedPreferences.getInstance();
    final completedLevels = prefs.getStringList(_completedLevelsKey) ?? [];
    final levels = completedLevels.map((e) => int.parse(e)).toList();
    return levels;
  }

  static Future<void> saveCompletedLevels(List<int> levels) async {
    final prefs = await SharedPreferences.getInstance();
    final levelsStr = levels.map((e) => e.toString()).toList();
    await prefs.setStringList(_completedLevelsKey, levelsStr);
    
    // Salva também no Firebase
    await _saveCompletedLevelsToFirebase(levels);
  }

  static Future<List<int>> getUnlockedLevels() async {
    // Primeiro tenta buscar do Firebase
    final firebaseLevels = await _getUnlockedLevelsFromFirebase();
    if (firebaseLevels.isNotEmpty) {
      // Sincroniza com o local
      await _saveUnlockedLevelsToLocal(firebaseLevels);
      return firebaseLevels;
    }
    
    // Se não houver no Firebase, busca do local
    final prefs = await SharedPreferences.getInstance();
    final unlockedLevels = prefs.getStringList(_unlockedLevelsKey);
    if (unlockedLevels == null || unlockedLevels.isEmpty) {
      await saveUnlockedLevels([1]);
      return [1];
    }
    final levels = unlockedLevels.map((e) => int.parse(e)).toList();
    return levels;
  }

  static Future<void> saveUnlockedLevels(List<int> levels) async {
    final prefs = await SharedPreferences.getInstance();
    if (!levels.contains(1)) {
      levels.add(1);
    }
    levels.sort();
    final levelsStr = levels.map((e) => e.toString()).toList();
    await prefs.setStringList(_unlockedLevelsKey, levelsStr);
    
    // Salva também no Firebase
    await _saveUnlockedLevelsToFirebase(levels);
  }

  static Future<int> getUserScore() async {
    // Sempre busca do Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('user_points').doc(user.uid).get();
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('score')) {
          return doc['score'] as int;
        }
      } catch (e) {
        // Erro ao buscar score do Firestore
      }
      // Se não houver score no Firestore, retorna 0
      return 0;
    }
    // Se não estiver logado, retorna 0
    return 0;
  }

  static Future<void> saveUserScore(int score, {int? bestStreak}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = {
        'score': score,
        'displayName': user.displayName ?? '',
      };
      if (bestStreak != null) {
        data['bestStreak'] = bestStreak;
      }
      await FirebaseFirestore.instance.collection('user_points').doc(user.uid).set(
        data,
        SetOptions(merge: true),
      );
      // Score salvo no Firestore
    }
  }

  static Future<void> addUserScore(int points, {int? bestStreak}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('user_points').doc(user.uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        int firestoreScore = 0;
        if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey('score')) {
          firestoreScore = snapshot['score'] as int;
        }
        firestoreScore += points;
        final data = {
          'score': firestoreScore,
          'displayName': user.displayName ?? '',
        };
        if (bestStreak != null) {
          data['bestStreak'] = bestStreak;
        }
        transaction.set(docRef, data, SetOptions(merge: true));
      });
      // Score adicionado no Firestore
    }
  }

  static Future<int> getUserBestStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('user_points').doc(user.uid).get();
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('bestStreak')) {
          return doc['bestStreak'] as int;
        }
      } catch (e) {
        // Erro ao buscar bestStreak do Firestore
      }
      return 0;
    }
    return 0;
  }

  static Future<void> saveUserBestStreak(int streak) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('user_points').doc(user.uid).set({
        'bestStreak': streak,
      }, SetOptions(merge: true));
    }
  }

  /// Busca todos os usuários do ranking, ordenados por score decrescente
  static Future<List<Map<String, dynamic>>> getRanking() async {
    final query = await FirebaseFirestore.instance
        .collection('user_points')
        .orderBy('score', descending: true)
        .get();
    List<Map<String, dynamic>> ranking = [];
    for (var doc in query.docs) {
      if (!doc.data().containsKey('score')) continue; // Garante que só entra no ranking quem tem score
      String? nome;
      // Tenta buscar o nome do documento users
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(doc.id).get();
        if (userDoc.exists && userDoc.data() != null && userDoc.data()!.containsKey('nome')) {
          nome = userDoc['nome'];
        }
      } catch (_) {}
      // Se não encontrar, tenta displayName salvo no próprio documento de pontuação
      nome ??= doc.data().containsKey('displayName') ? doc['displayName'] : null;
      // Se não encontrar, tenta buscar do Firebase Auth (apenas se for o usuário logado)
      final currentUser = FirebaseAuth.instance.currentUser;
      if (nome == null && currentUser != null && currentUser.uid == doc.id) {
        nome = currentUser.displayName;
      }
      // Se não encontrar, mostra UID
      nome ??= doc.id;
      ranking.add({
        'uid': doc.id,
        'nome': nome,
        'score': doc['score'],
        'bestStreak': doc.data().containsKey('bestStreak') ? doc['bestStreak'] : 0,
      });
    }
    return ranking;
  }

  // Métodos privados para Firebase
  static Future<void> _saveUnlockedLevelsToFirebase(List<int> levels) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(user.uid)
            .set({
          'newContentUnlockedLevels': levels,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        // Níveis desbloqueados de novo conteúdo salvos no Firebase
      } catch (e) {
        // Erro ao salvar no Firebase
      }
    }
  }

  static Future<List<int>> _getUnlockedLevelsFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(user.uid)
            .get();
        
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('newContentUnlockedLevels')) {
          final levels = List<int>.from(doc['newContentUnlockedLevels']);
          // Níveis desbloqueados de novo conteúdo carregados do Firebase
          return levels;
        }
      } catch (e) {
        // Erro ao buscar do Firebase
      }
    }
    return [];
  }

  static Future<void> _saveUnlockedLevelsToLocal(List<int> levels) async {
    final prefs = await SharedPreferences.getInstance();
    final levelsStr = levels.map((e) => e.toString()).toList();
    await prefs.setStringList(_unlockedLevelsKey, levelsStr);
    // Níveis desbloqueados de novo conteúdo sincronizados localmente
  }

  // Métodos privados para Firebase
  static Future<void> _saveCompletedLevelsToFirebase(List<int> levels) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(user.uid)
            .set({
          'newContentCompletedLevels': levels,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        // Níveis completados de novo conteúdo salvos no Firebase
      } catch (e) {
        // Erro ao salvar no Firebase
      }
    }
  }

  static Future<List<int>> _getCompletedLevelsFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(user.uid)
            .get();
        
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('newContentCompletedLevels')) {
          final levels = List<int>.from(doc['newContentCompletedLevels']);
          // Níveis completados de novo conteúdo carregados do Firebase
          return levels;
        }
      } catch (e) {
        // Erro ao buscar do Firebase
      }
    }
    return [];
  }

  static Future<void> _saveCompletedLevelsToLocal(List<int> levels) async {
    final prefs = await SharedPreferences.getInstance();
    final levelsStr = levels.map((e) => e.toString()).toList();
    await prefs.setStringList(_completedLevelsKey, levelsStr);
    // Níveis completados de novo conteúdo sincronizados localmente
  }

  static Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedLevelsKey);
    await prefs.remove(_unlockedLevelsKey);
    await prefs.remove(_userScoreKey);
    await prefs.remove(_userBestStreakKey);
    // Progresso limpo localmente
    
    // Limpa também do Firebase
    await _clearProgressFromFirebase();
  }

  static Future<void> _clearProgressFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(user.uid)
            .update({
          'newContentCompletedLevels': FieldValue.delete(),
          'newContentUnlockedLevels': FieldValue.delete(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        // Progresso de novo conteúdo limpo do Firebase
      } catch (e) {
        // Erro ao limpar do Firebase
      }
    }
  }
} 