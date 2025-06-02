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
  final duration = '0:00'.obs;
  final totalDuration = '0:00'.obs;
  final isPlayerPrepared = false.obs;
  final waveformData = Rxn<List<double>>();

  static AudioPlayerController? _currentlyPlayingController;
  static final Map<String, String> _downloadedFiles = {};

  String? currentAudioUrl;
  String? _localFilePath;
  bool _isDisposed = false;

  final String audioUrl;

  AudioPlayerController({required this.audioUrl});

  @override
  void onInit() {
    super.onInit();
    _initializeController();
    currentAudioUrl = audioUrl;
  }

  void _initializeController() {
    if (_isDisposed) return;

    playerController = PlayerController();
    _initPlayer();
  }

  @override
  void onClose() {
    _isDisposed = true;
    _disposeController();
    super.onClose();
  }

  void _disposeController() {
    try {
      if (!_isDisposed) {
        playerController.dispose();
      }
    } catch (e) {
      Get.log('Dispose error: $e');
    }
  }

  // Method to refresh waveform data when widget rebuilds
  void refreshWaveform() {
    if (isPlayerPrepared.value && playerController.waveformData.isNotEmpty) {
      waveformData.value = List<double>.from(playerController.waveformData);
      update(); // Force UI update
    }
  }

  Future<void> _initPlayer() async {
    if (_isDisposed) return;

    isLoading.value = true;
    isPlayerPrepared.value = false;

    try {
      // Check if file is already downloaded
      if (_downloadedFiles.containsKey(audioUrl)) {
        _localFilePath = _downloadedFiles[audioUrl];
        final file = File(_localFilePath!);
        if (!await file.exists()) {
          _localFilePath = await _downloadFile(audioUrl);
          _downloadedFiles[audioUrl] = _localFilePath!;
        }
      } else {
        _localFilePath = kIsWeb ? audioUrl : await _downloadFile(audioUrl);
        if (!kIsWeb) {
          _downloadedFiles[audioUrl] = _localFilePath!;
        }
      }

      if (_isDisposed) return;

      await playerController.preparePlayer(
        path: _localFilePath!,
        shouldExtractWaveform: true,
        noOfSamples: 50,
        volume: 1.0,
      );

      if (_isDisposed) return;

      // Store waveform data
      if (playerController.waveformData.isNotEmpty) {
        waveformData.value = List<double>.from(playerController.waveformData);
      }

      final durationMs = await playerController.getDuration(DurationType.max);
      totalDuration.value = _formatDuration(durationMs);

      // Set up listeners
      playerController.onCurrentDurationChanged.listen((currentMs) {
        if (!_isDisposed) {
          duration.value = _formatDuration(currentMs);
        }

        int remainingMs = durationMs - currentMs;
        if (remainingMs < 0) remainingMs = 0;

        totalDuration.value = _formatDuration(remainingMs);
      });

      playerController.onCompletion.listen((_) async {
        duration.value = '0:00';
        isPlaying.value = false;
        await playerController.stopPlayer();
        await playerController.preparePlayer(
          path: _localFilePath!,
          shouldExtractWaveform: true,
          noOfSamples: 50,
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
      if (!_isDisposed) {
        Get.snackbar('Error', 'Failed to load audio: ${e.toString()}');
        Get.log('InitPlayer Error: $e');
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> reinitializeIfNeeded() async {
    if (!isPlayerPrepared.value || _isDisposed) {
      _initializeController();
    } else {
      refreshWaveform();
    }
  }

  Future<void> togglePlayPause() async {
    if (_isDisposed) return;

    // If the requested audio is different from what's currently loaded
    if (audioUrl != currentAudioUrl) {
      await switchAudio(audioUrl);
      return;
    }

    // If player isn't prepared, initialize it
    if (!isPlayerPrepared.value) {
      await reinitializeIfNeeded();
      return;
    }

    try {
      if (isPlaying.value) {
        await playerController.pausePlayer();
        isPlaying.value = false;

        if (_currentlyPlayingController == this) {
          _currentlyPlayingController = null;
        }
      } else {
        // Pause other players
        if (_currentlyPlayingController != null &&
            _currentlyPlayingController != this) {
          await _currentlyPlayingController!.pausePlayer();
        }

        _currentlyPlayingController = this;
        await playerController.startPlayer();
        isPlaying.value = true;
      }
    } catch (e) {
      Get.log('TogglePlayPause Error: $e');
      await reinitializeIfNeeded();
    }
  }

  Future<void> switchAudio(String newAudioUrl) async {
    if (_isDisposed) return;

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

      // Stop current player
      if (isPlayerPrepared.value) {
        await playerController.stopPlayer();
      }

      _currentlyPlayingController = this;
      currentAudioUrl = newAudioUrl;
      isPlaying.value = false;
      isPlayerPrepared.value = false;
      waveformData.value = null;

      // Dispose and recreate controller
      _disposeController();
      _initializeController();
    } catch (e) {
      if (!_isDisposed) {
        Get.snackbar('Error', 'Failed to switch audio: ${e.toString()}');
        Get.log('SwitchAudio Error: $e');
        isPlaying.value = false;
        isLoading.value = false;
        isPlayerPrepared.value = false;
      }
    }
  }

  Future<void> pausePlayer() async {
    if (_isDisposed || !isPlaying.value) return;

    try {
      await playerController.pausePlayer();
      isPlaying.value = false;
    } catch (e) {
      Get.log('PausePlayer Error: $e');
    }
  }

  Future<void> seekTo(int milliseconds) async {
    if (_isDisposed || !isPlayerPrepared.value) return;

    try {
      await playerController.seekTo(milliseconds);
    } catch (e) {
      Get.log('SeekTo Error: $e');
    }
  }

  Future<String> _downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download audio: ${response.statusCode}');
      }

      final tempDir = await getTemporaryDirectory();
      final fileName =
          url.split('/').last.split('?').first; // Remove query params
      final filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_$fileName';
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
    final minutes = (milliseconds ~/ 60000).toString().padLeft(1, '0');
    final seconds = ((milliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Clean up static cache periodically
  static void clearCache() {
    _downloadedFiles.clear();
  }
}
