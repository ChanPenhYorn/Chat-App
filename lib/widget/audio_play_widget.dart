import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:chatapp/controllers/chat/audio_play_controller.dart';

class AudioWaveformPlayer extends StatefulWidget {
  final String audioPath;
  final Color? waveColor;
  final Color? liveWaveColor;
  final double? height;

  const AudioWaveformPlayer({
    super.key,
    required this.audioPath,
    this.waveColor,
    this.liveWaveColor,
    this.height,
  });

  @override
  State<AudioWaveformPlayer> createState() => _AudioWaveformPlayerState();
}

class _AudioWaveformPlayerState extends State<AudioWaveformPlayer>
    with AutomaticKeepAliveClientMixin {
  AudioPlayerController? controller;
  String? controllerTag;

  @override
  bool get wantKeepAlive => true; // Keep widget alive during scrolling

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    controllerTag = 'audio_${widget.audioPath}_${widget.audioPath.hashCode}';

    // Try to get existing controller or create new one
    if (Get.isRegistered<AudioPlayerController>(tag: controllerTag)) {
      controller = Get.find<AudioPlayerController>(tag: controllerTag!);
      // Refresh waveform data in case widget was rebuilt
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller?.refreshWaveform();
      });
    } else {
      controller = Get.put(
        AudioPlayerController(audioUrl: widget.audioPath),
        tag: controllerTag!,
      );
    }
  }

  @override
  void didUpdateWidget(AudioWaveformPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If audio path changed, reinitialize controller
    if (oldWidget.audioPath != widget.audioPath) {
      _initializeController();
    } else {
      // Just refresh the waveform display
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller?.refreshWaveform();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildWaveform() {
    return Obx(() {
      if (controller == null) return const SizedBox.shrink();

      if (controller!.isLoading.value) {
        return SizedBox(
          height: widget.height ?? 44,
          child: Center(
            child: SpinKitRing(
              color: AppColors.primaryLight,
              size: 20.0,
              lineWidth: 4,
            ),
          ),
        );
      }

      if (!controller!.isPlayerPrepared.value) {
        return SizedBox(
          height: widget.height ?? 44,
          child: const Center(
            child: Text(
              'Preparing audio...',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        );
      }

      // Force rebuild waveform if data is available but widget shows empty
      if (controller!.playerController.waveformData.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller?.reinitializeIfNeeded();
        });
      }

      return AudioFileWaveforms(
        key: ValueKey(
            'waveform_${widget.audioPath}_${controller!.waveformData.value?.length ?? 0}'),
        // size: Size(MediaQuery.of(context).size.width / 1.55, 44),
        size: Size(50, 44),
        playerController: controller!.playerController,
        waveformType: WaveformType.fitWidth,
        playerWaveStyle: PlayerWaveStyle(
          fixedWaveColor: Colors.grey,
          seekLineThickness: 3,
          waveThickness: 1.5,
          spacing: 3,
          liveWaveColor: widget.liveWaveColor ?? Colors.blue,
          waveCap: StrokeCap.round,
        ),
        enableSeekGesture: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    if (controller == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(() => Container(
                decoration: BoxDecoration(
                  color: controller!.isPlaying.value
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    controller!.isLoading.value
                        ? Icons.hourglass_empty
                        : controller!.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                    color:
                        controller!.isLoading.value ? Colors.grey : Colors.blue,
                    size: 24,
                  ),
                  onPressed: controller!.isLoading.value
                      ? null
                      : controller!.togglePlayPause,
                ),
              )),
          Expanded(child: _buildWaveform()),
          const SizedBox(width: 8),
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  // '${controller!.duration.value} / ${controller!.totalDuration.value}',
                  controller!.duration.value.isEmpty
                      ? '0:00'
                      : controller!.totalDuration.value,

                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
