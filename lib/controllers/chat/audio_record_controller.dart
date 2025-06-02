import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioRecorderController extends GetxController {
  final recorderController = RecorderController();
  final isRecording = false.obs;
  String? recordingPath;
  Timer? _recordingTimer;

  @override
  void onInit() {
    super.onInit();
    initRecorder();
  }

  Future<void> initRecorder() async {
    final dir = await getApplicationDocumentsDirectory();
    recordingPath =
        '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    recorderController
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000
      ..updateFrequency = const Duration(milliseconds: 100);
  }

  /// Starts recording with an optional duration limit
  Future<void> startRecording({
    Duration limit = const Duration(seconds: 5), // default: 60s
    Function(String audioPath)? onLimitReached,
  }) async {
    if (recordingPath == null) return;
    await recorderController.record(path: recordingPath!);
    isRecording.value = true;

    // Set a timer to stop recording after [limit]
    _recordingTimer = Timer(limit, () async {
      await stopRecording((path) {
        if (onLimitReached != null) {
          onLimitReached(path);
        }
      });
    });
  }

  Future<void> stopRecording(Function(String audioPath) onSend) async {
    await recorderController.stop();
    isRecording.value = false;
    _recordingTimer?.cancel();
    _recordingTimer = null;

    // Send the audio path to callback
    onSend(recordingPath!);

    // Reset path for next recording
    await initRecorder();
  }

  Future<void> cancelRecording() async {
    if (isRecording.value) {
      await recorderController.stop();
      isRecording.value = false;
    }

    _recordingTimer?.cancel();
    _recordingTimer = null;

    if (recordingPath != null) {
      final file = File(recordingPath!);
      if (file.existsSync()) {
        await file.delete();
      }
    }

    // Reset path for next recording
    await initRecorder();
  }

  @override
  void onClose() {
    recorderController.dispose();
    _recordingTimer?.cancel();
    super.onClose();
  }
}
