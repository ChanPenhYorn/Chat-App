import 'dart:io';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioPlayerController extends GetxController {
  late PlayerController playerController;
  final isPlaying = false.obs;
  final isLoading = true.obs;
  final duration = '00:00'.obs;
  final totalDuration = '00:00'.obs;
  final isPlayerPrepared = false.obs;

  final String audioUrl;
  static AudioPlayerController?
      _currentPlayingController; // Track current playing controller

  AudioPlayerController({required this.audioUrl});

  @override
  void onInit() {
    super.onInit();
    playerController = PlayerController();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    isLoading.value = true;

    try {
      final localPath = await _downloadFile(audioUrl);

      await playerController.preparePlayer(
        path: localPath,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );

      final durationMs = await playerController.getDuration(DurationType.max);
      totalDuration.value = _formatDuration(durationMs);

      playerController.onCurrentDurationChanged.listen((currentMs) {
        duration.value = _formatDuration(currentMs);
        if (currentMs >= durationMs) {
          isPlaying.value = false;
          _currentPlayingController = null; // Reset when audio finishes
        }
      });

      playerController.onPlayerStateChanged.listen((state) {
        isPlaying.value = state == PlayerState.playing;
        if (state == PlayerState.stopped || state == PlayerState.paused) {
          if (_currentPlayingController == this) {
            _currentPlayingController = null; // Clear if this controller stops
          }
        }
      });

      isPlayerPrepared.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Audio load failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${url.split('/').last}';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> togglePlayPause() async {
    if (!isPlayerPrepared.value) return;

    // If another audio is playing, stop it
    if (_currentPlayingController != null &&
        _currentPlayingController != this) {
      await _currentPlayingController!.pausePlayer();
      _currentPlayingController!.isPlaying.value = false;
    }

    if (isPlaying.value) {
      await playerController.pausePlayer();
      _currentPlayingController = null;
    } else {
      await playerController.startPlayer();
      _currentPlayingController =
          this; // Set this as the current playing controller
    }
  }

  Future<void> pausePlayer() async {
    if (isPlaying.value) {
      await playerController.pausePlayer();
      isPlaying.value = false;
      if (_currentPlayingController == this) {
        _currentPlayingController = null;
      }
    }
  }

  String _formatDuration(int milliseconds) {
    final minutes = (milliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((milliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    if (_currentPlayingController == this) {
      _currentPlayingController = null;
    }
    playerController.stopPlayer();
    playerController.dispose();
    super.onClose();
  }
}
