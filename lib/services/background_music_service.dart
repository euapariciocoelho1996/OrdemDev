import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundMusicService {
  static final BackgroundMusicService _instance = BackgroundMusicService._internal();
  factory BackgroundMusicService() => _instance;
  
  late AudioPlayer _backgroundPlayer;
  late AudioPlayer _ambientPlayer;
  
  bool _isMusicEnabled = true;
  bool _isPlaying = false;
  double _volume = 0.3; // Volume padrão mais baixo para música de fundo
  
  String? _currentTrack;
  MusicContext _currentContext = MusicContext.home;

  BackgroundMusicService._internal() {
    _initAudioPlayers();
    _loadSettings();
  }

  void _initAudioPlayers() {
    _backgroundPlayer = AudioPlayer();
    _ambientPlayer = AudioPlayer();
    
    // Configurações para música de fundo
    _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    _ambientPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isMusicEnabled = prefs.getBool('background_music_enabled') ?? true;
    _volume = prefs.getDouble('background_music_volume') ?? 0.3;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('background_music_enabled', _isMusicEnabled);
    await prefs.setDouble('background_music_volume', _volume);
  }

  // Métodos públicos
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  MusicContext get currentContext => _currentContext;

  Future<void> setMusicEnabled(bool enabled) async {
    _isMusicEnabled = enabled;
    await _saveSettings();
    
    if (!enabled) {
      await stopMusic();
    } else if (!_isPlaying) {
      await playContextualMusic(_currentContext);
    }
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _saveSettings();
    
    await _backgroundPlayer.setVolume(_volume);
    await _ambientPlayer.setVolume(_volume * 0.5); // Ambient sempre mais baixo
  }

  Future<void> playContextualMusic(MusicContext context) async {
    if (!_isMusicEnabled) return;
    
    _currentContext = context;
    final trackName = _getTrackForContext(context);
    
    if (trackName == _currentTrack && _isPlaying) return;
    
    try {
      await _backgroundPlayer.stop();
      await _ambientPlayer.stop();
      
      // Toca a música principal baseada no contexto
      await _backgroundPlayer.setSource(AssetSource('audio/$trackName'));
      await _backgroundPlayer.setVolume(_volume);
      await _backgroundPlayer.resume();
      
      // Adiciona ambient sounds se disponível
      final ambientTrack = _getAmbientTrackForContext(context);
      if (ambientTrack != null) {
        await _ambientPlayer.setSource(AssetSource('audio/$ambientTrack'));
        await _ambientPlayer.setVolume(_volume * 0.3);
        await _ambientPlayer.resume();
      }
      
      _currentTrack = trackName;
      _isPlaying = true;
      
    } catch (e) {
      print('Erro ao tocar música de fundo: $e');
      // Se não conseguir tocar a música específica, para silenciosamente
      _isPlaying = false;
    }
  }

  Future<void> stopMusic() async {
    await _backgroundPlayer.stop();
    await _ambientPlayer.stop();
    _isPlaying = false;
    _currentTrack = null;
  }

  Future<void> pauseMusic() async {
    if (_isPlaying) {
      await _backgroundPlayer.pause();
      await _ambientPlayer.pause();
    }
  }

  Future<void> resumeMusic() async {
    if (_isMusicEnabled && _currentTrack != null) {
      await _backgroundPlayer.resume();
      await _ambientPlayer.resume();
      _isPlaying = true;
    }
  }

  // Mapeamento de contexto para trilhas sonoras
  String _getTrackForContext(MusicContext context) {
    switch (context) {
      case MusicContext.home:
        return 'bg_home.mp3'; // Música calma para tela inicial
      case MusicContext.concepts:
        return 'bg_concepts.mp3'; // Música focada para conceitos
      case MusicContext.games:
        return 'bg_games.mp3'; // Música mais dinâmica para jogos
      case MusicContext.challenges:
        return 'bg_challenges.mp3'; // Música motivacional para desafios
      case MusicContext.quiz:
        return 'bg_quiz.mp3'; // Música tensa para quiz
      case MusicContext.onboarding:
        return 'bg_onboarding.mp3'; // Música inspiradora para onboarding
    }
  }

  String? _getAmbientTrackForContext(MusicContext context) {
    switch (context) {
      case MusicContext.concepts:
        return 'ambient_coding.mp3'; // Sons de digitação suaves
      case MusicContext.games:
        return 'ambient_gaming.mp3'; // Sons de jogo ambientais
      case MusicContext.challenges:
        return 'ambient_motivation.mp3'; // Sons motivacionais
      default:
        return null;
    }
  }

  // Método para ajustar música baseada no horário do dia
  Future<void> adjustMusicForTimeOfDay() async {
    if (!_isMusicEnabled) return;
    
    final hour = DateTime.now().hour;
    double timeBasedVolume = _volume;
    
    // Ajusta volume baseado no horário
    if (hour >= 22 || hour <= 6) {
      // Horário noturno - volume mais baixo
      timeBasedVolume = _volume * 0.5;
    } else if (hour >= 12 && hour <= 14) {
      // Horário de almoço - volume intermediário
      timeBasedVolume = _volume * 0.7;
    }
    
    await _backgroundPlayer.setVolume(timeBasedVolume);
    await _ambientPlayer.setVolume(timeBasedVolume * 0.3);
  }

  Future<void> dispose() async {
    await _backgroundPlayer.dispose();
    await _ambientPlayer.dispose();
  }
}

enum MusicContext {
  home,
  concepts,
  games,
  challenges,
  quiz,
  onboarding,
}

// Widget para controlar música de fundo
class BackgroundMusicController {
  static final BackgroundMusicService _service = BackgroundMusicService();
  
  static Future<void> playForContext(MusicContext context) async {
    await _service.playContextualMusic(context);
  }
  
  static Future<void> stop() async {
    await _service.stopMusic();
  }
  
  static Future<void> pause() async {
    await _service.pauseMusic();
  }
  
  static Future<void> resume() async {
    await _service.resumeMusic();
  }
  
  static Future<void> setEnabled(bool enabled) async {
    await _service.setMusicEnabled(enabled);
  }
  
  static Future<void> setVolume(double volume) async {
    await _service.setVolume(volume);
  }
  
  static bool get isEnabled => _service.isMusicEnabled;
  static bool get isPlaying => _service.isPlaying;
  static double get volume => _service.volume;
}
