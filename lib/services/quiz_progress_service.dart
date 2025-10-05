import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizProgressService {
  static const String _completedLevelsKey = 'quiz_completed_levels';

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

  static Future<void> addCompletedLevel(int levelId) async {
    final completedLevels = await getCompletedLevels();
    if (!completedLevels.contains(levelId)) {
      completedLevels.add(levelId);
      await saveCompletedLevels(completedLevels);
      // Nível de quiz adicionado aos completados
    }
  }

  static Future<bool> isLevelUnlocked(int levelId) async {
    if (levelId == 1) return true;
    final previousLevelId = levelId - 1;
    final completedLevels = await getCompletedLevels();
    return completedLevels.contains(previousLevelId);
  }

  static Future<bool> isLevelCompleted(int levelId) async {
    final completedLevels = await getCompletedLevels();
    return completedLevels.contains(levelId);
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
          'quizCompletedLevels': levels,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        // Níveis de quiz completados salvos no Firebase
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
        
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('quizCompletedLevels')) {
          final levels = List<int>.from(doc['quizCompletedLevels']);
          // Níveis de quiz completados carregados do Firebase
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
    // Níveis de quiz completados sincronizados localmente
  }

  // Método para limpar o progresso (útil para testes)
  static Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedLevelsKey);
    // Progresso de quiz limpo
    
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
          'quizCompletedLevels': FieldValue.delete(),
        });
        // Progresso de quiz limpo do Firebase
      } catch (e) {
        // Erro ao limpar do Firebase
      }
    }
  }
}
