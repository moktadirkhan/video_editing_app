import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';

String formatter(Duration duration) => [
      duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
      duration.inSeconds.remainder(60).toString().padLeft(2, '0')
    ].join(":");

List<Widget> trimSlider(
    BuildContext context, VideoEditorController _controller) {
  return [
    AnimatedBuilder(
      animation: _controller.video,
      builder: (_, __) {
        final duration = _controller.video.value.duration.inSeconds;
        final pos = _controller.trimPosition * duration;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(formatter(Duration(seconds: pos.toInt())),
                  style: const TextStyle(color: Colors.white)),
              const Expanded(child: SizedBox()),
            ],
          ),
        );
      },
    ),
    Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TrimSlider(
          child: TrimTimeline(
              controller: _controller, margin: const EdgeInsets.only(top: 10)),
          controller: _controller,
          height: 60,
          horizontalMargin: 15),
    )
  ];
}
