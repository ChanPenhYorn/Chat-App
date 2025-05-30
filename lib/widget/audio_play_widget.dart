import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/controllers/chat/audio_play_controller.dart';

class AudioWaveformPlayer extends StatelessWidget {
  final String audioPath;

  const AudioWaveformPlayer({super.key, required this.audioPath});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(AudioPlayerController(audioUrl: audioPath), tag: audioPath);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() => IconButton(
              icon: Icon(
                controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                color: Colors.blue,
              ),
              onPressed: controller.togglePlayPause,
            )),
        Expanded(
          child: AudioFileWaveforms(
              size: Size(double.infinity, 44),
              playerController: controller.playerController,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Colors.grey,
                liveWaveColor: Colors.blue,
              ),
              waveformData: controller.playerController.waveformData,
              enableSeekGesture: true),
        ),
        const SizedBox(width: 8),
        Obx(() => Text(
              '${controller.duration.value} / ${controller.totalDuration.value}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            )),
        const SizedBox(width: 8),
      ],
    );
  }
}
