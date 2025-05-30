import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioPlayerController extends GetxController {
  final String audioPath;

  late PlayerController playerController;
  final RxBool isPlaying = false.obs;
  final RxString duration = '00:00'.obs;
  final RxString totalDuration = '00:00'.obs;
  final RxBool isPlayerPrepared = false.obs;

  late String _localPath;

  AudioPlayerController(this.audioPath) {
    playerController = PlayerController();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      String pathToUse = audioPath;

      // Check if it's a network file
      if (audioPath.startsWith("http")) {
        _localPath = await _downloadFile(audioPath);
        pathToUse = _localPath;
      }

      await playerController.preparePlayer(
        path: pathToUse,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );

      final durationMs = await playerController.getDuration(DurationType.max);
      totalDuration.value = _formatDuration(durationMs);

      playerController.onCurrentDurationChanged.listen((currentMs) {
        duration.value = _formatDuration(currentMs);
        if (currentMs >= durationMs && isPlaying.value) {
          isPlaying.value = false;
          duration.value = _formatDuration(0);
        }
      });

      playerController.onPlayerStateChanged.listen((state) {
        isPlaying.value = state == PlayerState.playing;
      });

      isPlayerPrepared.value = true;
    } catch (e) {
      print('Error initializing player: $e');
      isPlayerPrepared.value = false;
    }
  }

  Future<String> _downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${url.split('/').last}');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Future<void> togglePlayPause() async {
    if (!isPlayerPrepared.value) {
      await _initPlayer();
    }

    if (isPlaying.value) {
      await playerController.pausePlayer();
    } else {
      await playerController.startPlayer();
    }
  }

  Future<void> stopAndReset() async {
    if (isPlaying.value) {
      await playerController.stopPlayer();
    }

    duration.value = _formatDuration(0);
    isPlaying.value = false;
  }

  String _formatDuration(int milliseconds) {
    final minutes = (milliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((milliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    playerController.stopPlayer();
    playerController.dispose();
    super.onClose();
  }
}
