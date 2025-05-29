import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:get/get.dart';

class AudioPlayerController extends GetxController {
  final String audioPath;

  late final PlayerController playerController;
  final RxBool isPlaying = false.obs;
  final RxString duration = '00:00'.obs;
  final RxString totalDuration = '00:00'.obs;
  final RxBool isPlayerPrepared = false.obs;

  AudioPlayerController(this.audioPath) {
    playerController = PlayerController();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      print('Initializing player for: $audioPath');
      await playerController.preparePlayer(
        path: audioPath,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );
      isPlayerPrepared.value = true;

      final durationMs = await playerController.getDuration(DurationType.max);
      print('Total duration: $durationMs ms');
      totalDuration.value = _formatDuration(durationMs);

      playerController.onCurrentDurationChanged.listen((currentMs) {
        duration.value = _formatDuration(currentMs);
        if (currentMs >= durationMs && isPlaying.value) {
          print('Audio reached end, resetting');
          isPlaying.value = false;
          _resetPlayer();
        }
      });

      playerController.onPlayerStateChanged.listen((state) {
        isPlaying.value = state == PlayerState.playing;
        print('Player state changed: $state');
      });
    } catch (e) {
      print('Error initializing player: $e');
      isPlayerPrepared.value = false;
    }
  }

  Future<void> _resetPlayer() async {
    try {
      print('Resetting player for: $audioPath');
      if (isPlaying.value) {
        await playerController.stopPlayer();
      }
      await playerController.preparePlayer(
        path: audioPath,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );
      isPlayerPrepared.value = true;
      duration.value = _formatDuration(0);
      print('Player reset complete');
    } catch (e) {
      print('Error resetting player: $e');
      isPlayerPrepared.value = false;
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (!isPlayerPrepared.value) {
        print('Player not prepared, reinitializing');
        await _initPlayer();
      }
      if (isPlaying.value) {
        print('Pausing player');
        await playerController.pausePlayer();
      } else {
        print('Starting player');
        await playerController.startPlayer();
      }
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  String _formatDuration(int milliseconds) {
    final minutes = (milliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((milliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    print('Disposing player for: $audioPath');
    playerController.stopPlayer();
    playerController.dispose();
    super.onClose();
  }
}
