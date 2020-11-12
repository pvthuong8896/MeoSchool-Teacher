import 'package:dio/dio.dart';
import 'package:edtechteachersapp/src/global/dialogs/toast_message.dart';
import 'package:edtechteachersapp/src/models/edtech_file.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerScreen extends StatefulWidget {
  List<EdTechFile> listImage;

  PhotoViewerScreen({@required this.listImage, @required this.initialIndex})
      : pageController = PageController(initialPage: initialIndex);
  final PageController pageController;
  final int initialIndex;

  @override
  _PhotoViewerScreenState createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  onSelectDownload() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      ToastMessage.showToastMessage(context, "Tải xuống ...");
      await dio.download(this.widget.listImage[currentIndex].file_url,
          "${dir.path}/meoschool${DateTime.now().millisecondsSinceEpoch}.png",
          onReceiveProgress: (rec, total) {});
      ToastMessage.showToastMessage(context, "Tải xuống thành công");
    } catch (e) {
      ToastMessage.showToastMessage(context, e.toString());
    }
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
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider:
                          NetworkImage(widget.listImage[index].file_url),
                      initialScale: PhotoViewComputedScale.contained,
                      heroAttributes:
                          const PhotoViewHeroAttributes(tag: "someTag"),
                    );
                  },
                  itemCount: widget.listImage.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                event.expectedTotalBytes,
                      ),
                    ),
                  ),
//          backgroundDecoration: widget.backgroundDecoration,
                  pageController: widget.pageController,
                  onPageChanged: onPageChanged,
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
              this.widget.listImage != null
                  ? Positioned(
                      right: 10,
                      top: 10,
                      child: SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            onPressed: () {
                              onSelectDownload();
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
