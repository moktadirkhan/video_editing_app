import 'package:flutter/material.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/ui/crop/crop_grid.dart';

class CropPage extends StatefulWidget {
  const CropPage({Key? key, required this.controller}) : super(key: key);
  final VideoEditorController controller;

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  @override
  void initState() {
    // widget.controller.preferredCropAspectRatio = 1 / 1;
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      widget.controller.rotate90Degrees(RotateDirection.left),
                  child: const Icon(Icons.rotate_left, color: Colors.white),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      widget.controller.rotate90Degrees(RotateDirection.right),
                  child: const Icon(Icons.rotate_right, color: Colors.white),
                ),
              )
            ]),
            const SizedBox(height: 15),
            Expanded(
              child: InteractiveViewer(
                maxScale: 2.4,
                child: CropGridViewer(
                    controller: widget.controller, horizontalMargin: 60),
              ),
            ),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(
                child: InkWell(
                  onTap: Navigator.of(context).pop,
                  child: const Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    widget.controller.updateCrop();
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
