import 'package:chatapp/controllers/chat/audio_record_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class WaveformRecorderWidget extends StatelessWidget {
  final Function(String audioPath) onSend;

  const WaveformRecorderWidget({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = Get.put(AudioRecorderController());

    return Obx(() {
      return audioCtrl.isRecording.value
          ? Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      // color: Colors.red,
                    ),
                    onPressed: () {
                      audioCtrl.stopRecording(onSend);
                    },
                  ),
                  Expanded(
                    child: audioCtrl.isRecording.value
                        ? AudioWaveforms(
                            enableGesture: false,
                            size: const Size(double.infinity, 50),
                            recorderController: audioCtrl.recorderController,
                            waveStyle: const WaveStyle(
                              waveColor: Colors.blue,
                              showMiddleLine: false,
                              extendWaveform: true,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            margin: EdgeInsets.only(right: 8),
                          )
                        : const SizedBox.shrink(),
                  ),
                  IconButton(
                    icon: Icon(
                      audioCtrl.isRecording.value
                          ? Icons.stop_circle_outlined
                          : Icons.mic,
                    ),
                    onPressed: () {
                      audioCtrl.isRecording.value
                          ? audioCtrl.stopRecording(onSend)
                          : audioCtrl.startRecording();
                    },
                  ),
                ],
              ),
            )
          : IconButton(
              icon: Icon(
                audioCtrl.isRecording.value
                    ? Icons.stop
                    : Icons.mic_none_outlined,
                // color: Colors.red,
              ),
              onPressed: () {
                audioCtrl.isRecording.value
                    ? audioCtrl.stopRecording(onSend)
                    : audioCtrl.startRecording();
              },
            );
    });
  }
}
