import 'dart:async';
import 'dart:io';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/post/components/create_feed_footer.dart';
import 'package:edtechteachersapp/src/resources/post/components/create_feed_header.dart';
import 'package:edtechteachersapp/src/resources/post/components/post_target.dart';
import 'package:edtechteachersapp/src/resources/video_player/index.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class CreatePostScreen extends StatefulWidget {
  final bool createForAStudent;
  CreatePostScreen({Key key, this.createForAStudent}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  BuildContext _scaffoldContext;
  final focusNode = FocusNode();
  List<EdTechFile> listImage = [];
  final TextEditingController _contentController = TextEditingController();
  PostBloc postBloc;
  var targetPost = CLASS_ROOM;
  var readyPost = false;
  List<Asset> images = List<Asset>();
  List<Student> selectedStudents = [];
  bool isSelectVideo = false;
  Image thumbnailVideo;
  File _videoSelected;
  String thumbnailUrl;

  @override
  void initState() {
    super.initState();
    postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: EdTechColors.backgroundColor,
          brightness: Brightness.light,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: EdTechColors.textBlackColor,
                  size: EdTechIconSizes.medium),
              onPressed: () {
                DataSingleton.instance.removeSelected();
                Navigator.of(context).pop();
              }),
        ),
        body: new Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return getBody();
        }));
  }

  getBody() {
    return GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: EdTechColors.backgroundColor,
          child: Column(
              children: <Widget>[
                CreateFeedHeader(createForAStudent: widget.createForAStudent, targetPost: _buildTargetTag()),
                SizedBox(
                  height: 16.0,
                ),
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                          children: [
                          _buildTextField(),
                          SizedBox(height: 10.0,),
                        this.isSelectVideo ? _buildVideo() : _buildListImage(),
                  ],
                ))),
                StreamBuilder(
                    stream: postBloc.uploadImageController,
                    builder: (context, snapshot) =>
                      CreateFeedFooter(
                          readyPost: readyPost,
                          onPressMedia: ()=>{_settingModalBottomSheet(context)},
                          onPressCreatePost: createNewPost)
                    ),
              ]),
        ));
  }

  Widget _buildTargetTag() => StreamBuilder(
    stream: postBloc.postTargetController,
    builder: (context, snapshot) {
      selectedStudents = DataSingleton.instance.checkListStudentSelected();
      if (selectedStudents.isEmpty) {
        targetPost = CLASS_ROOM;
        return PostTargetWidget(title: DataSingleton.instance.classSelected.name, icon: Icons.people);
      }
      if (selectedStudents.length == 1) {
        targetPost = STUDENT;
        return PostTargetWidget(title: selectedStudents.first.name, icon: Icons.person);
      }
      if (selectedStudents.length > 1) {
        targetPost = GROUP;
        return PostTargetWidget(title: "Đăng bài cho ${selectedStudents.length} học sinh", icon: Icons.people);
      }
      return Container();
    },
  );

  Widget _buildTextField() {
    return TextField(
        controller: _contentController,
        focusNode: focusNode,
        style: TextStyle(
            fontSize: 16,
            fontWeight: EdTechFontWeight.w600,
            color: EdTechColors.textBlackColor),
        onChanged: (content) {
          if (content.trim() != "") {
            readyPost = true;
            postBloc.uploadImageStates();
          } else {
            readyPost = false;
            postBloc.uploadImageStates();
          }
        },
        maxLines: null,
        decoration: InputDecoration(
          hintText: "Hôm nay ở lớp có gì mới? 🎉🎉",
          hintStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          border: InputBorder.none,
        ));
  }

  Widget _buildVideo() {
    final width = EdTechAppStyles(context).width;
    return Container(
        width: width,
        height: width * 9 / 16,
        child: thumbnailVideo != null && _videoSelected != null
            ? Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: thumbnailVideo,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isSelectVideo = false;
                          _videoSelected = null;
                          thumbnailUrl = "";
                          thumbnailVideo = null;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 0),
                        child: Icon(Icons.close,
                            size: EdTechIconSizes.medium,
                            color: EdTechColors.textColor),
                        decoration: BoxDecoration(
                          color: EdTechColors.textWhiteColor,
                          borderRadius: BorderRadius.circular(30),
                          border: new Border.all(
                            color: EdTechColors.textColor,
                            width: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: FlatButton(
                        onPressed: () =>
                            {this.onSelectPlayVideo(_videoSelected)},
                        child: Icon(
                          Icons.play_arrow,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            : null);
  }

  Widget _buildListImage() {
    final width = 160.0;
    final imageSize = 150.0;
    final padding = 10.0;
    return Container(
        width: double.infinity,
        height: width,
        child: StreamBuilder(
          stream: postBloc.uploadImageController,
          builder: (BuildContext context, snapShot) => ListView.builder(
              itemCount: listImage.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int position) {
                EdTechFile edfile = listImage[position];
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      width: width + padding,
                      height: width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: edfile.file != null
                            ? Image.file(
                                edfile.file,
                                fit: BoxFit.cover,
                                width: imageSize,
                                height: imageSize,
                              )
                            : Image.network(
                                edfile.file_url,
                                fit: BoxFit.cover,
                                width: imageSize,
                                height: imageSize,
                              ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        listImage.removeAt(position);
                        postBloc.uploadImageStates();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(Icons.close,
                            size: EdTechIconSizes.medium,
                            color: EdTechColors.textColor),
                        decoration: BoxDecoration(
                          color: EdTechColors.textWhiteColor,
                          borderRadius: BorderRadius.circular(30),
                          border: new Border.all(
                            color: EdTechColors.textColor,
                            width: 0.2,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }),
        ));
  }

  void createNewPost() async {
    try {
      LoadingDialog.showLoadingDialog(context, "Đang đăng...");
      if (this.isSelectVideo) {
        var videoUrl = await uploadVideo(_videoSelected);
        await postBloc.createVideoPost(
            targetPost,
            DataSingleton.instance.classSelected.classroom_id,
            selectedStudents,
            _contentController.text.trim(),
            this.thumbnailUrl,
            videoUrl.file_url);
        DataSingleton.instance.removeSelected();
        LoadingDialog.hideLoadingDialog(context);
        Navigator.of(context).pop();
      } else {
        await postBloc.createPost(
            targetPost,
            DataSingleton.instance.classSelected.classroom_id,
            selectedStudents,
            _contentController.text.trim(),
            listImage);
        DataSingleton.instance.removeSelected();
        LoadingDialog.hideLoadingDialog(context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);
      MessageDialog.showMessageDialog(context, "Thông báo", e.toString(), "OK");
    }
  }

  void _settingModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_camera,
                        color: EdTechColors.textBlackColor,
                        size: EdTechIconSizes.normal),
                    title: new Text(FROM_CAMERA),
                    onTap: () => getImageFromCamera()),
                new ListTile(
                  leading: new Icon(Icons.photo_library,
                      color: EdTechColors.textBlackColor,
                      size: EdTechIconSizes.normal),
                  title: new Text(FROM_LIBRARY),
                  onTap: () => loadAssets(),
                ),
                new ListTile(
                  leading: new Icon(Icons.video_library,
                      color: EdTechColors.textBlackColor,
                      size: EdTechIconSizes.normal),
                  title: Text(FROM_VIDEO),
                  onTap: () => getVideoFromLibrary(),
                )
              ],
            ),
          );
        });
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1500, maxWidth: 1500);
    Navigator.pop(context);
    setState(() {
      isSelectVideo = false;
      _videoSelected = null;
      thumbnailUrl = "";
      thumbnailVideo = null;
    });
    if (image == null) {
      SnackBarDialog.showNoImageView(_scaffoldContext, IMAGE_NULL);
    } else {
      uploadImage(image);
    }
  }

  Future getImageFromLibrary() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1500, maxWidth: 1500);
    Navigator.pop(context);
    setState(() {
      isSelectVideo = false;
      _videoSelected = null;
      thumbnailUrl = "";
      thumbnailVideo = null;
    });
    if (image == null) {
      SnackBarDialog.showNoImageView(_scaffoldContext, IMAGE_NULL);
    } else {
      uploadImage(image);
    }
  }

  Future getVideoFromLibrary() async {
    var _tempDir = (await getTemporaryDirectory()).path;
    print("_tmpDir" + _tempDir);
    try {
      File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
      Navigator.pop(context);
      if (video != null) {
        _videoSelected = video;
        final thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: video.path,
            thumbnailPath: _tempDir,
            imageFormat: ImageFormat.PNG,
            quality: 100);
        var edtechFile = await postBloc.uploadImage(File(thumbnailPath));
        this.thumbnailUrl = edtechFile.file_url;
        final _image = Image.file(File(thumbnailPath),
            fit: BoxFit.cover,
            width: EdTechAppStyles(context).width,
            height: EdTechAppStyles(context).width * 9 / 16);
        setState(() {
          thumbnailVideo = _image;
          isSelectVideo = true;
        });
      }
    } catch (e) {
      print("On error " + e.toString());
    }
  }

  Future uploadImage(File image) async {
    SnackBarDialog.showLoadingView(_scaffoldContext, IMAGE_LOADING);
    print("image " + image.path);
    var newImage = await postBloc.uploadImage(image);
    newImage.file = image;
    listImage.add(newImage);
    SnackBarDialog.showSuccessView(_scaffoldContext, IMAGE_LOAD_SUCCESS);
    postBloc.uploadImageStates();
  }

  Future<EdTechFile> uploadVideo(File video) async {
    try {
      var newVideo = await postBloc.uploadImage(video);
      return newVideo;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      Navigator.pop(context);
      await uploadMultiImage(resultList);
    } on Exception catch (e) {
      error = e.toString();
    }
    images = resultList;
  }

  Future uploadMultiImage(List<Asset> assets) async {
    try {
      SnackBarDialog.showLoadingView(_scaffoldContext, IMAGE_LOADING);
      var images = await postBloc.uploadMulImage(assets);
      listImage.addAll(images);
      SnackBarDialog.showSuccessView(_scaffoldContext, IMAGE_LOAD_SUCCESS);
      postBloc.uploadImageStates();
    } catch (e) {
      SnackBarDialog.showErrorView(_scaffoldContext, IMAGE_LOAD_ERROR);
    }
  }

  void onSelectPlayVideo(File file) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return VideoPlayerScreen(file: file);
    }));
  }
}
