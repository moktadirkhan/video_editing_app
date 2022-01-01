import 'package:flutter/material.dart';
import 'package:video_editing_app/src/components/item_list.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/ui/cover/cover_viewer.dart';
import 'package:video_editor/ui/video_viewer.dart';
import 'package:video_editor/video_editor.dart';

class GridListCard extends StatefulWidget {
  final Item item;
  final ValueChanged<bool> isSelected;
  const GridListCard({Key? key, required this.item, required this.isSelected})
      : super(key: key);

  @override
  _GridListCardState createState() => _GridListCardState();
}

class _GridListCardState extends State<GridListCard> {
  late VideoEditorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoEditorController.file(widget.item.videoPath)
      ..initialize().then((_) => setState(() {}));
  }

  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          // Image.file(
          //   widget.item.videoPath,
          //   color: Colors.black.withOpacity(isSelected ? 0.9 : 0),
          //   colorBlendMode: BlendMode.color,
          //   fit: BoxFit.fill, //Determines the size ratio of the gridimage
          //   width: 320,
          //   height: 320,
          // ),

          SizedBox.expand(
             
                  child: VideoViewer(
            controller: _controller,
          )),

          // CoverViewer(controller: _controller),
          if (isSelected)
            const Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.black,
                ),
              ),
            )
          else
            Container()
        ],
      ),
    );
  }
}
