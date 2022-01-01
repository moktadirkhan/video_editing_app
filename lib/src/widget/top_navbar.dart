// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:video_editing_app/router.dart';
// import 'package:video_editing_app/src/provider/video_list.dart';
// import 'package:video_editor/video_editor.dart';
// import 'package:gallery_saver/gallery_saver.dart';

// class TopNavbar {
//   final isExporting = ValueNotifier<bool>(false);
//   final exportingProgress = ValueNotifier<double>(0.0);
//   int index = 0;

//   Widget topNavBar(BuildContext context, VideoEditorController _controller,
//       File file, VideoList vlist) {
//     return SafeArea(
//       child: SizedBox(
//         height: 60,
//         child: Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => _controller.rotate90Degrees(RotateDirection.left),
//                 child: const Icon(Icons.rotate_left, color: Colors.white),
//               ),
//             ),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => _controller.rotate90Degrees(RotateDirection.right),
//                 child: const Icon(Icons.rotate_right, color: Colors.white),
//               ),
//             ),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => openCropPage(context, _controller),
//                 child: const Icon(Icons.crop, color: Colors.white),
//               ),
//             ),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   exportVideos(context, _controller, vlist);
//                   // openMergePage(context, _controller);
//                 },
//                 child: const Icon(Icons.add_a_photo_sharp, color: Colors.white),
//               ),
//             ),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => saveVideo(_controller),
//                 child: const Icon(Icons.arrow_forward, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void saveVideo(VideoEditorController _controller) async {
//     bool _firstStat = true;
//     await _controller.exportVideo(onProgress: (statics) {
//       isExporting.value = true;
//       // First statistics is always wrong so if first one skip it

//       if (_firstStat) {
//         _firstStat = false;
//       } else {
//         exportingProgress.value =
//             statics.getTime() / _controller.video.value.duration.inMilliseconds;
//       }
//     }, onCompleted: (file) {
//       isExporting.value = false;
//       GallerySaver.saveVideo(file!.path).then((value) => print("Video Saved"));
//     });
//   }

//   void exportVideos(BuildContext context, VideoEditorController _controller,
//       VideoList vlist) async {
//     bool _firstStat = true;
//     await _controller.exportVideo(onProgress: (statics) {
//       isExporting.value = true;
//       // First statistics is always wrong so if first one skip it

//       if (_firstStat) {
//         _firstStat = false;
//       } else {
//         exportingProgress.value =
//             statics.getTime() / _controller.video.value.duration.inMilliseconds;
//       }
//     }, onCompleted: (file) {
//       isExporting.value = false;
//       // GallerySaver.saveVideo(file!.path).then((value) => print("Video Saved"));
//       vlist.videolists.add(File(file!.path));
//       vlist.videopath.add(file.path);
//       openMergePage(context, _controller,vlist);
//     });
//   }
// }
