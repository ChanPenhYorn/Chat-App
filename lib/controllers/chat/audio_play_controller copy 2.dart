// import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class AudioController extends GetxController {
  // Recorder and Player controllers
  late RecorderController recorderController;
  late PlayerController playerController;

  // Observables for UI state
  final isRecording = false.obs;
  final isPlaying = false.obs;
  final hasPermission = false.obs;
  final recordedFilePath = ''.obs;
  final currentDuration = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    // checkPermission();
  }

  // Initialize controllers
  void _initializeControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000
      ..updateFrequency = const Duration(milliseconds: 100);

    playerController = PlayerController();

    // Listen to player state changes
    playerController.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });

    // Listen to current duration changes
    playerController.onCurrentDurationChanged.listen((duration) {
      currentDuration.value = duration;
    });
  }

  // Check and request microphone permission
  // Future<void> checkPermission() async {
  //   final status = await Permission.microphone.request();
  //   hasPermission.value = status == PermissionStatus.granted;
  // }

  // Start recording
  Future<void> startRecording() async {
    if (!hasPermission.value) {
      Get.snackbar('Permission Denied', 'Microphone permission is required');
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await recorderController.record(path: path);
      isRecording.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to start recording: $e');
    }
  }

  // Pause recording
  Future<void> pauseRecording() async {
    try {
      await recorderController.pause();
      isRecording.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to pause recording: $e');
    }
  }

  // Stop recording and save file path
  Future<void> stopRecording() async {
    try {
      recordedFilePath.value = (await recorderController.stop()) ?? '';
      isRecording.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop recording: $e');
    }
  }

  // Prepare and play audio
  Future<void> playAudio() async {
    if (recordedFilePath.value.isEmpty) {
      Get.snackbar('Error', 'No recorded audio available');
      return;
    }

    try {
      await playerController.preparePlayer(path: recordedFilePath.value);
      await playerController.startPlayer(forceRefresh: false);
      isPlaying.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to play audio: $e');
    }
  }

  // Pause audio playback
  Future<void> pauseAudio() async {
    try {
      await playerController.pausePlayer();
      isPlaying.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to pause audio: $e');
    }
  }

  // Stop audio playback
  Future<void> stopAudio() async {
    try {
      await playerController.stopPlayer();
      isPlaying.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop audio: $e');
    }
  }

  @override
  void onClose() {
    recorderController.dispose();
    playerController.dispose();
    super.onClose();
  }
}
