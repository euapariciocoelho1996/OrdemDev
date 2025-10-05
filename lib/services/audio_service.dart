import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  
  late AudioPlayer _audioPlayer;

  AudioService._internal() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> playCorrectSound() async {
    await _audioPlayer.play(AssetSource('All_Itens/correct.mp3'));
  }

  Future<void> playWrongSound() async {
    await _audioPlayer.play(AssetSource('All_Itens/erro.mp3'));
  }

  Future<void> playCongratulationsSound() async {
    await _audioPlayer.play(AssetSource('All_Itens/congratulations.mp3'));
  }

  Future<void> playErrorSound() async {
    
    await _audioPlayer.play(AssetSource('All_Itens/erro.mp3')); 
  }

  Future<void> playGameOverSound() async {
    // Crie um arquivo de som de game over (ex: game_over.mp3) e coloque na sua pasta de assets
    await _audioPlayer.play(AssetSource('All_Itens/erro.mp3'));
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _initAudioPlayer(); // Reinicializa o player após descartar
  }
} 