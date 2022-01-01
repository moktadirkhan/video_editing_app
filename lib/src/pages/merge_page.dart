import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editing_app/src/components/card/grid_list_card.dart';
import 'package:video_editing_app/src/components/item_list.dart';
import 'package:video_editing_app/src/provider/video_list.dart';
import 'package:video_editor/video_editor.dart';
import 'package:ffmpeg_kit_flutter/execute_callback.dart';
import '../../router.dart';

class MergePage extends StatefulWidget {
  final VideoEditorController controller;
  final VideoList vlist;
  const MergePage({Key? key, required this.controller, required this.vlist})
      : super(key: key);

  @override
  _MergePageState createState() => _MergePageState();
}

class _MergePageState extends State<MergePage> {
  String? videos;
  List<Item>? videolist;
  List<Item>? selectedvideoList;
  final FlutterFFmpeg _fFmpeg = FlutterFFmpeg();
  final ImagePicker _picker = ImagePicker();
  int i = 0;
  @override
  void initState() {
    print("vlist ${widget.vlist.length()}");
    loadlist();
    super.initState();
  }

  void _pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      openVideoEditorPage(context, File(file.path), widget.vlist);
    }
  }

  void loadlist() {
    videolist = [];
    selectedvideoList = [];
    for (var i = 0; i < (widget.vlist.length()); i++) {
      videolist?.add(Item(widget.vlist.videolists.elementAt(i), i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (itemList!.isNotEmpty) {
        //   setState(() {
        //     widget.imageList.imagelist.removeAt(itemList!.length - 1);
        //     widget.imageList.imagepath.removeAt(itemList!.length - 1);
        //     itemList!.removeAt(itemList!.length - 1);
        //   });
        // }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          title: const Center(
            child: Text("Video Editing App"),
          ),
        ),
        body: GridView.builder(
            itemCount: videolist!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15),
                // child: Card(
                //   elevation: 10,
                child: GridListCard(
                  item: videolist![index],
                  isSelected: (bool value) {
                    setState(() {
                      if (value) {
                        selectedvideoList!.add(videolist![index]);
                      } else {
                        selectedvideoList!.remove(videolist![index]);
                      }
                    });
                  },
                  key: Key(
                    videolist![index].rank.toString(),
                  ),
                ),
                // ),
              );
            }),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _pickVideo();
              },
              child: const Icon(
                Icons.add,
                size: 40,
              ),
              heroTag: null,
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                mergeVideos();
              },
              child: const Icon(
                Icons.save_alt,
                size: 40,
              ),
              heroTag: null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> mergeVideos() async {

    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    final String? path = directory?.path;
    if (path == null) return;
    final String filePath = '$path/videos.txt';
    final File file = File(filePath);

    for (var i = 0; i < widget.vlist.videopath.length; i++) {
      file.writeAsStringSync(widget.vlist.videopath[i], mode: FileMode.append);
    }
    // String s1 = "image_picker7021259874615132520_1640976353455.mp4 \n image_picker943706405361856637_1640976342753.mp4";
    // file.writeAsString(s1);
    final contents = await file.readAsString();
    print("local files $contents");
    String command =
        "ffmpeg -i $filePath -filter_complex '[0:0][1:0]concat=n=2:v=0:a=1[out]' -map '[out]' -c copy $path/output.mp4";
    _fFmpeg.execute(command).then((value) => print("Ffmpeg1 process $value"));





    // openVideoEditorPage(context, widget.controller.file, widget.vlist);
    file.writeAsStringSync("");
    // openHomePage(context);
  }
}
