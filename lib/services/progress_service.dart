import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressService {
  static const String _completedLevelsKey = 'completed_levels';
  static const String _unlockedLevelsKey = 'unlocked_levels';

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
    print('Níveis completados: $levels'); // Debug
    return levels;
  }

  static Future<void> saveCompletedLevels(List<int> levels) async {
    final prefs = await SharedPreferences.getInstance();
    final levelsStr = levels.map((e) => e.toString()).toList();
    await prefs.setStringList(_completedLevelsKey, levelsStr);
    print('Níveis completados salvos: $levelsStr'); // Debug
    
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
    
    // Se não existir nenhum nível desbloqueado, inicializa com o nível 1
    if (unlockedLevels == null || unlockedLevels.isEmpty) {
      print('Inicializando níveis desbloqueados com [1]'); // Debug
      await saveUnlockedLevels([1]);
      return [1];
    }
    
    final levels = unlockedLevels.map((e) => int.parse(e)).toList();
    print('Níveis desbloqueados: $levels'); // Debug
    return levels;
  }

  static Future<void> saveUnlockedLevels(List<int> levels) async {
    final prefs = await SharedPreferences.getInstance();
    // Garante que o nível 1 sempre esteja desbloqueado
    if (!levels.contains(1)) {
      levels.add(1);
    }
    // Ordena os níveis
    levels.sort();
    final levelsStr = levels.map((e) => e.toString()).toList();
    await prefs.setStringList(_unlockedLevelsKey, levelsStr);
    print('Níveis desbloqueados salvos: $levelsStr'); // Debug
    
    // Salva também no Firebase
    await _saveUnlockedLevelsToFirebase(levels);
  }

  // Método para limpar o progresso (útil para testes)
  static Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedLevelsKey);
    await prefs.remove(_unlockedLevelsKey);
    // Progresso limpo
    
    // Limpa também do Firebase
    await _clearProgressFromFirebase();
  }

  static Future<void> addCompletedLevel(int levelId) async {
    final completedLevels = await getCompletedLevels();
    if (!completedLevels.contains(levelId)) {
      completedLevels.add(levelId);
      await saveCompletedLevels(completedLevels);
      // Nível adicionado aos completados
    }
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
          'completedLevels': levels,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        // Níveis completados salvos no Firebase
      } catch (e) {
        // Erro ao salvar no Firebase
      }
    }
  }

  static Future<void> _saveUnlockedLevelsToFirebase(List<int> levels) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(user.uid)
            .set({
          'unlockedLevels': levels,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        // Níveis desbloqueados salvos no Firebase
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
        
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('unlockedLevels')) {
          final levels = List<int>.from(doc['unlockedLevels']);
          // Níveis desbloqueados carregados do Firebase
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
    // Níveis desbloqueados sincronizados localmente
  }

  static Future<List<int>> _getCompletedLevelsFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(user.uid)
            .get();
        
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('completedLevels')) {
          final levels = List<int>.from(doc['completedLevels']);
          // Níveis completados carregados do Firebase
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
    // Níveis completados sincronizados localmente
  }

  static Future<void> _clearProgressFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('user_progress')
            .doc(user.uid)
            .delete();
        // Progresso limpo do Firebase
      } catch (e) {
        // Erro ao limpar do Firebase
      }
    }
  }
} 