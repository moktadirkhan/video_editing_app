import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:helpers/helpers/transition.dart';
import 'package:video_editing_app/src/provider/video_list.dart';
import 'package:video_editing_app/src/widget/top_navbar.dart';
import 'package:video_editing_app/src/widget/trim_slider.dart';
import 'package:video_editor/video_editor.dart';

import '../../router.dart';

class VideoEditorPage extends StatefulWidget {
  final File file;
  final VideoList vlist;
  const VideoEditorPage({Key? key, required this.file, required this.vlist}) : super(key: key);

  @override
  _VideoEditorPageState createState() => _VideoEditorPageState();
}

class _VideoEditorPageState extends State<VideoEditorPage> {
  late VideoEditorController _controller;
  final isExporting = ValueNotifier<bool>(false);
  final exportingProgress = ValueNotifier<double>(0.0);
  bool _exported = false;
  String _exportText = "";
  @override
  void initState() {
    _controller = VideoEditorController.file(widget.file,
        maxDuration: const Duration(seconds: 30))
      ..initialize().then((_) => setState(() {}));
    // print("files  ${widget.file.path}");
    super.initState();
  }

  // @override
  // void dispose() {
  //   TopNavbar().exportingProgress.dispose();
  //   TopNavbar().isExporting.dispose();
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? SafeArea(
              child: Stack(children: [
              Column(children: [
                topNavBar(context, _controller, File(widget.file.path), widget.vlist),
                Expanded(
                    child: DefaultTabController(
                        length: 2,
                        child: Column(children: [
                          Expanded(
                              child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Stack(alignment: Alignment.center, children: [
                                CropGridViewer(
                                  controller: _controller,
                                  showGrid: false,
                                ),
                                AnimatedBuilder(
                                  animation: _controller.video,
                                  builder: (_, __) => OpacityTransition(
                                    visible: !_controller.isPlaying,
                                    child: GestureDetector(
                                      onTap: _controller.video.play,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.play_arrow,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              CoverViewer(controller: _controller)
                            ],
                          )),
                          Container(
                            height: 200,
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                TabBar(
                                  indicatorColor: Colors.white,
                                  tabs: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(Icons.content_cut)),
                                          Text('Trim')
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(Icons.video_label)),
                                          Text('Cover')
                                        ]),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children:
                                              trimSlider(context, _controller)),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [_coverSelection()]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // _customSnackBar(),
                          ValueListenableBuilder(
                            valueListenable: isExporting,
                            builder: (_, bool export, __) => OpacityTransition(
                              visible: export,
                              child: AlertDialog(
                                backgroundColor: Colors.white,
                                title: ValueListenableBuilder(
                                  valueListenable: exportingProgress,
                                  builder: (_, double value, __) => Text(
                                    "Exporting video ${(value * 100).ceil()}%",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ])))
              ])
            ]))
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _coverSelection() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: CoverSelection(
          controller: _controller,
          height: 60,
          nbSelection: 8,
        ));
  }
  //   Widget _customSnackBar() {
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: SwipeTransition(
  //       visible: _exported,
  //       // direction: SwipeDirection.fromBottom,

  //       child: Container(
  //         height: 60,
  //         width: double.infinity,
  //         color: Colors.black.withOpacity(0.8),
  //         child:const Center(
  //           // child: Text(
  //           //   _exportText,
  //           //   bold: true,
  //           // ),
  //           child: Text("exported"),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget topNavBar(BuildContext context, VideoEditorController _controller,
      File file, VideoList vlist) {
    return SafeArea(
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _controller.rotate90Degrees(RotateDirection.left),
                child: const Icon(Icons.rotate_left, color: Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _controller.rotate90Degrees(RotateDirection.right),
                child: const Icon(Icons.rotate_right, color: Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => openCropPage(context, _controller),
                child: const Icon(Icons.crop, color: Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  exportVideos(context, _controller, vlist);
                  // openMergePage(context, _controller);
                },
                child: const Icon(Icons.add_a_photo_sharp, color: Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => saveVideo(_controller),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveVideo(VideoEditorController _controller) async {
    bool _firstStat = true;
    await _controller.exportVideo(onProgress: (statics) {
      isExporting.value = true;
      // First statistics is always wrong so if first one skip it

      if (_firstStat) {
        _firstStat = false;
      } else {
        exportingProgress.value =
            statics.getTime() / _controller.video.value.duration.inMilliseconds;
      }
    }, onCompleted: (file) {
      // isExporting.value = false;
      GallerySaver.saveVideo(file!.path).then((value) => print("Video Saved"));
    });
  }

  void exportVideos(BuildContext context, VideoEditorController _controller,
      VideoList vlist) async {
    bool _firstStat = true;
    await _controller.exportVideo(onProgress: (statics) {
      isExporting.value = true;
      // First statistics is always wrong so if first one skip it

      if (_firstStat) {
        _firstStat = false;
      } else {
        exportingProgress.value =
            statics.getTime() / _controller.video.value.duration.inMilliseconds;
      }
    }, onCompleted: (file) {
      isExporting.value = false;
      vlist.videolists.add(File(file!.path));
      vlist.videopath.add(file.path);
      openMergePage(context, _controller, vlist);
    });
  }
}
