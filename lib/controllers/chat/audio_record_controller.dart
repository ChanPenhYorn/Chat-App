import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioRecorderController extends GetxController {
  final recorderController = RecorderController();
  final isRecording = false.obs;
  String? recordingPath;

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
      // ..androidEncoder = AndroidEncoder.aac
      // ..androidOutputFormat = AndroidOutputFormat.mpeg4
      // ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      // ..sampleRate = 16000;
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000

      ..updateFrequency = const Duration(milliseconds: 100);
  }

  Future<void> startRecording() async {
    if (recordingPath == null) return;
    await recorderController.record(path: recordingPath!);
    isRecording.value = true;
  }

  Future<void> stopRecording(Function(String audioPath) onSend) async {
    await recorderController.stop();
    isRecording.value = false;

    // Reset path for next recording
    await initRecorder();
  }

  Future<void> cancelRecording() async {
    if (isRecording.value) {
      await recorderController.stop();
      isRecording.value = false;
    }

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
    super.onClose();
  }
}
