import 'dart:io';
import 'package:flutter/foundation.dart';
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
  static AudioPlayerController? _currentlyPlayingController;

  String? currentAudioUrl; // Track currently loaded audio URL
  String? _localFilePath; // Store local file path for reuse

  final String audioUrl;

  AudioPlayerController({required this.audioUrl});

  @override
  void onInit() {
    super.onInit();
    playerController = PlayerController();
    if (audioUrl != currentAudioUrl) {
      _initPlayer();
      currentAudioUrl = audioUrl;
    }
  }

  Future<void> _initPlayer() async {
    isLoading.value = true;
    isPlayerPrepared.value = false; // Reset prepared state
    try {
      // Reuse existing file if available and URL hasn't changed
      if (!kIsWeb && _localFilePath != null && audioUrl == currentAudioUrl) {
        final file = File(_localFilePath!);
        if (!await file.exists()) {
          _localFilePath = await _downloadFile(audioUrl);
        }
      } else {
        _localFilePath = kIsWeb ? audioUrl : await _downloadFile(audioUrl);
      }

      await playerController.preparePlayer(
        path: _localFilePath!,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );
      final durationMs = await playerController.getDuration(DurationType.max);
      totalDuration.value = _formatDuration(durationMs);
      playerController.onCurrentDurationChanged.listen((currentMs) {
        duration.value = _formatDuration(currentMs);
      });
      // playerController.onCompletion.listen((_) async {
      //   duration.value = '00:00';
      //   isPlaying.value = false;
      //   // Reinitialize player to ensure it can be reused
      //   await playerController.stopPlayer();
      //   await playerController.preparePlayer(
      //     path: _localFilePath!,
      //     shouldExtractWaveform: true,
      //     noOfSamples: 100,
      //     volume: 1.0,
      //   );
      //   await playerController.seekTo(0);
      //   isPlayerPrepared.value = true;
      //   Get.log('Player reinitialized after completion');
      // });

      playerController.onCompletion.listen((_) async {
        duration.value = '00:00';
        isPlaying.value = false;
        await playerController.stopPlayer();
        await playerController.preparePlayer(
          path: _localFilePath!,
          shouldExtractWaveform: true,
          noOfSamples: 100,
          volume: 1.0,
        );
        await playerController.seekTo(0);
        isPlayerPrepared.value = true;

        // Clear current controller reference
        if (_currentlyPlayingController == this) {
          _currentlyPlayingController = null;
        }
        Get.log('Player reinitialized after completion');
      });

      isPlayerPrepared.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load audio: ${e.toString()}');
      Get.log('InitPlayer Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> stopAndDisposePlayer() async {
    try {
      await playerController.stopPlayer();
      playerController.dispose();
      isPlaying.value = false;
    } catch (e) {
      Get.log('stopAndDisposePlayer Error: $e');
    }
  }

  Future<void> switchAudio(String newAudioUrl) async {
    // If this is the same URL and player is prepared, just toggle play/pause
    if (newAudioUrl == currentAudioUrl && isPlayerPrepared.value) {
      await togglePlayPause();
      return;
    }

    try {
      isLoading.value = true;

      // Stop any currently playing controller
      if (_currentlyPlayingController != null &&
          _currentlyPlayingController != this) {
        await _currentlyPlayingController!.pausePlayer();
      }

      // Stop and dispose current player if it exists
      if (isPlayerPrepared.value) {
        await playerController.stopPlayer();
        // await playerController.dispose();
      }

      // Update the global reference
      _currentlyPlayingController = this;
      currentAudioUrl = newAudioUrl;
      isPlaying.value = false;
      isPlayerPrepared.value = false;

      // Create new player controller
      playerController = PlayerController();

      // Initialize with new audio
      await _initPlayer();

      // Start playback
      await playerController.startPlayer();
      isPlaying.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to switch audio: ${e.toString()}');
      Get.log('SwitchAudio Error: $e');
      // Reset states on error
      isPlaying.value = false;
      isLoading.value = false;
      isPlayerPrepared.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> togglePlayPause() async {
  //   if (!isPlayerPrepared.value) {
  //     Get.log('Player not prepared, reinitializing');
  //     await _initPlayer();
  //     return;
  //   }

  //   if (audioUrl != currentAudioUrl) {
  //     Get.log('URL changed, reinitializing');
  //     currentAudioUrl = audioUrl;
  //     await playerController.stopPlayer();
  //     playerController.dispose();
  //     playerController = PlayerController();
  //     await _initPlayer();
  //     return;
  //   }

  //   try {
  //     if (isPlaying.value) {
  //       await playerController.pausePlayer();
  //       isPlaying.value = false;
  //     } else {
  //       await playerController.startPlayer();
  //       isPlaying.value = true;
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to toggle play/pause: ${e.toString()}');
  //     Get.log('TogglePlayPause Error: $e');
  //     // Fallback: Reinitialize player if startPlayer fails
  //     await _initPlayer();
  //   }
  // }

  Future<void> togglePlayPause() async {
    // If the requested audio is different from what's currently loaded
    if (audioUrl != currentAudioUrl) {
      Get.log('Different audio requested, switching...');
      await switchAudio(audioUrl); // Use switchAudio to handle the transition
      return;
    }

    // If player isn't prepared, initialize it
    if (!isPlayerPrepared.value) {
      Get.log('Player not prepared, initializing...');
      await _initPlayer();
      return;
    }

    try {
      if (isPlaying.value) {
        await playerController.pausePlayer();
        isPlaying.value = false;

        // Clear current controller reference when pausing
        if (_currentlyPlayingController == this) {
          _currentlyPlayingController = null;
        }
      } else {
        // If another controller is playing, pause it first
        if (_currentlyPlayingController != null &&
            _currentlyPlayingController != this) {
          await _currentlyPlayingController!.pausePlayer();
        }

        // Set this as the currently playing controller
        _currentlyPlayingController = this;
        await playerController.startPlayer();
        isPlaying.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle play/pause: ${e.toString()}');
      Get.log('TogglePlayPause Error: $e');
      // Attempt to recover by reinitializing
      await _initPlayer();
    }
  }

  Future<void> pausePlayer() async {
    if (isPlaying.value) {
      try {
        await playerController.pausePlayer();
        isPlaying.value = false;
      } catch (e) {
        Get.log('PausePlayer Error: $e');
      }
    }
  }

  Future<void> replayAudio() async {
    if (!isPlayerPrepared.value) {
      Get.log('Player not prepared for replay, reinitializing');
      await _initPlayer();
      return;
    }

    try {
      await playerController.seekTo(0);
      await playerController.startPlayer();
      isPlaying.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to replay audio: ${e.toString()}');
      Get.log('ReplayAudio Error: $e');
      // Fallback: Reinitialize player if startPlayer fails
      await _initPlayer();
    }
  }

  Future<void> restartAudio() async {
    if (!isPlayerPrepared.value) {
      Get.log('Player not prepared for restart, reinitializing');
      await _initPlayer();
      return;
    }

    try {
      await playerController.seekTo(0);
      await playerController.startPlayer();
      isPlaying.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to restart audio: ${e.toString()}');
      Get.log('RestartAudio Error: $e');
      // Fallback: Reinitialize player if startPlayer fails
      await _initPlayer();
    }
  }

  Future<String> _downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download audio: ${response.statusCode}');
      }
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${url.split('/').last}';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      Get.log('File downloaded: $filePath');
      return filePath;
    } catch (e) {
      Get.log('DownloadFile Error: $e');
      rethrow;
    }
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
    if (!kIsWeb && _localFilePath != null) {
      final file = File(_localFilePath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    super.onClose();
  }
}
