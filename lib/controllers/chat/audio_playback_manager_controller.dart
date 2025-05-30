// import 'package:chatapp/controllers/chat/audio_play_controller.dart';

// class AudioPlaybackManager {
//   static final AudioPlaybackManager _instance =
//       AudioPlaybackManager._internal();

//   factory AudioPlaybackManager() => _instance;

//   AudioPlayerController? _currentController;

//   AudioPlaybackManager._internal();

//   Future<void> setCurrentController(AudioPlayerController controller) async {
//     if (_currentController != null && _currentController != controller) {
//       await _currentController!.stopIfPlaying();
//     }
//     _currentController = controller;
//   }

//   void clearCurrentController(AudioPlayerController controller) {
//     if (_currentController == controller) {
//       _currentController = null;
//     }
//   }
// }
