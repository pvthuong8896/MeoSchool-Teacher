import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  File file;
  String networkUrl;

  VideoPlayerScreen({Key key, this.file, this.networkUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;
  bool isShowOverlay = false;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  onSelectDownloadVideo() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      ToastMessage.showToastMessage(context, "Tải xuống ...");
      await dio.download(this.widget.networkUrl,
          "${dir.path}/meoschool${DateTime.now().millisecondsSinceEpoch}.mp4",
          onReceiveProgress: (rec, total) {});
      ToastMessage.showToastMessage(context, "Tải xuống thành công");
    } catch (e) {
      ToastMessage.showToastMessage(context, e.toString());
    }
  }

  Future<bool> buildPlayer() async {
    if (this.widget.file != null) {
      _videoPlayerController = VideoPlayerController.file(this.widget.file);
    } else {
      _videoPlayerController =
          VideoPlayerController.network(this.widget.networkUrl);
    }
    _videoPlayerController.setLooping(true);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio < 0.7
          ? 16 / 9
          : _videoPlayerController.value.aspectRatio,
      autoPlay: true,
      looping: true,
      allowFullScreen: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.white,
        handleColor: Colors.white,
        backgroundColor: Colors.white,
        bufferedColor: Colors.white,
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            // Here we create one to set status bar color
            backgroundColor: Color.fromRGBO(50, 50, 50,
                1), // Set any color of status bar you want; or it defaults to your theme's primary color
          )),
      body: Container(
          color: Color.fromRGBO(50, 50, 50, 1),
          child: Stack(
            children: <Widget>[
              Center(
                child: FutureBuilder<bool>(
                  future: buildPlayer(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.data == true) {
                      return Chewie(
                        controller: _chewieController,
                      );
                    } else {
                      return SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              EdTechColors.textWhiteColor),
                        ),
                        height: 30,
                        width: 30,
                      );
                    }
                  },
                ),
              ),
              Positioned(
                  left: 10,
                  top: 10,
                  child: SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                        iconSize: 20,
                      ))),
              this.widget.networkUrl != null
                  ? Positioned(
                      right: 10,
                      top: 10,
                      child: SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            onPressed: () {
                              onSelectDownloadVideo();
                            },
                            icon: Icon(
                              Icons.file_download,
                              color: Colors.white,
                              size: 20,
                            ),
                            iconSize: 20,
                          )))
                  : SizedBox.shrink()
            ],
          )),
    );
  }
}
