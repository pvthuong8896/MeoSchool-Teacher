import 'dart:async';
import 'dart:io';

import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:edtechteachersapp/src/resources/video_player/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class UpdatePostScreen extends StatefulWidget {
  Post post;
  bool editPostAStudent;

  UpdatePostScreen({Key key, this.post, this.editPostAStudent})
      : super(key: key);

  @override
  _UpdatePostScreenState createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  BuildContext _scaffoldContext;
  final focusNode = FocusNode();
  List<EdTechFile> listImage = [];
  final TextEditingController _contentController = TextEditingController();
  PostBloc postBloc;
  var targetPost = 0;
  var startPost = false;
  List<Asset> images = List<Asset>();
  List<Student> selectedStudents = [];
  bool isSelectVideo = false;
  String thumbnailVideo;
  File _videoSelected;
  String thumbnailUrl;
  String videoUrl;

  @override
  void initState() {
    super.initState();
    postBloc = BlocProvider.of<PostBloc>(context);
    convertData();
  }

  void convertData() {
    startPost = true;
    this.listImage = this.widget.post.files;
    this._contentController.text = this.widget.post.content.trim();
    var selectedStudents = this.widget.post.students;
    if (selectedStudents.isEmpty) {
      targetPost = 0;
    }
    if (selectedStudents.length == 1) {
      targetPost = 1;
    }
    if (selectedStudents.length > 1) {
      targetPost = 2;
    }
    if (this.widget.post.videoUrl != null) {
      this.isSelectVideo = true;
      this.videoUrl = this.widget.post.videoUrl;
      this.thumbnailUrl = this.widget.post.videoThumbnail;
    }
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
    return new GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: EdTechColors.backgroundColor,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    this.isSelectVideo ? _buildVideo() : _buildListImage(),
                  ],
                ))),
                Column(
                  children: [
                    Container(
                      height: 0.5,
                      color: EdTechColors.dividerColor,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _settingModalBottomSheet(context);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add_a_photo,
                                  size: EdTechIconSizes.normal,
                                  color: EdTechColors.textColor),
                              SizedBox(width: 8),
                              Text(
                                "Ảnh/Video",
                                style: TextStyle(
                                    fontSize: EdTechFontSizes.normal,
                                    color: EdTechColors.textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder(
                            stream: postBloc.uploadImageController,
                            builder: (context, snapshot) => InkWell(
                                  onTap: () {
                                    if (startPost) {
                                      _onClickPost();
                                    }
                                  },
                                  child: Container(
                                      height: 28,
                                      width: 120,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: startPost
                                            ? EdTechColors.mainColor
                                            : EdTechColors.timeColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                      ),
                                      child: Text(
                                        "Sửa bài viết",
                                        style: TextStyle(
                                            fontSize: EdTechFontSizes.normal,
                                            color: EdTechColors.textWhiteColor,
                                            fontWeight: FontWeight.bold),
                                      )),
                                )),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ]),
        ));
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        new Container(
          width: 44.0,
          height: 44.0,
          decoration: new BoxDecoration(
            color: EdTechColors.textColor,
            image: new DecorationImage(
              image: DataSingleton.instance.edUser.avatar != null
                  ? new NetworkImage(DataSingleton.instance.edUser.avatar)
                  : AssetImage('assets/img/avatar_default.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
            border: new Border.all(
              color: EdTechColors.textColor,
              width: 0.1,
            ),
          ),
        ),
        SizedBox(
          width: 11,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              DataSingleton.instance.edUser.name,
              style: TextStyle(
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.normal,
                  fontWeight: EdTechFontWeight.semibold),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                if (!this.widget.editPostAStudent) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return TargetPostScreen();
                  }));
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                  border: new Border.all(
                    color: EdTechColors.timeColor,
                    width: 0.5,
                  ),
                ),
                child: _buildTargetTag(),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildTargetTag() => StreamBuilder(
        stream: postBloc.postTargetController,
        builder: (context, snapshot) {
          selectedStudents = DataSingleton.instance.checkListStudentSelected();
          if (selectedStudents.isEmpty) {
            targetPost = 0;
            return _buildPostAll();
          }
          if (selectedStudents.length == 1) {
            targetPost = 1;
            return _buildPostTarget();
          }
          if (selectedStudents.length > 1) {
            targetPost = 2;
            return _buildPostGroup(selectedStudents.length);
          }
          return Container();
        },
      );

  Widget _buildPostAll() {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.people,
          color: EdTechColors.textBlackColor,
          size: EdTechIconSizes.small,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          DataSingleton.instance.classSelected.name,
          style: TextStyle(
            fontSize: EdTechFontSizes.normal,
            color: EdTechColors.textBlackColor,
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: EdTechColors.textBlackColor,
          size: EdTechIconSizes.normal,
        ),
      ],
    );
  }

  Widget _buildPostTarget() {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.person,
          color: EdTechColors.textBlackColor,
          size: EdTechIconSizes.small,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          selectedStudents.first.name,
          style: TextStyle(
            fontSize: EdTechFontSizes.normal,
            color: EdTechColors.textBlackColor,
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: EdTechColors.textBlackColor,
          size: EdTechIconSizes.normal,
        ),
      ],
    );
  }

  Widget _buildPostGroup(int number) {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.people,
          color: EdTechColors.textBlackColor,
          size: EdTechIconSizes.small,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          "Đăng bài cho $number học sinh",
          style: TextStyle(
            fontSize: EdTechFontSizes.normal,
            color: EdTechColors.textBlackColor,
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: EdTechColors.textBlackColor,
          size: EdTechIconSizes.normal,
        ),
      ],
    );
  }

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
            startPost = true;
            postBloc.uploadImageStates();
          } else {
            startPost = false;
            postBloc.uploadImageStates();
          }
        },
        maxLines: null,
        decoration: InputDecoration(
          hintText: "Hôm nay lớp có gì mới? 🎉🎉",
          hintStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          border: InputBorder.none,
        ));
  }

  Widget _buildVideo() {
    final width = EdTechAppStyles(context).width;
    return Container(
        width: width,
        height: width * 9 / 16,
        child: (thumbnailVideo != null && _videoSelected != null) || (thumbnailUrl != null && videoUrl != null)
            ? Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: this.thumbnailVideo != null
                        ? Image.file(File(this.thumbnailVideo),
                            fit: BoxFit.cover,
                            width: EdTechAppStyles(context).width,
                            height: EdTechAppStyles(context).width * 9 / 16)
                        : Image.network(thumbnailUrl,
                            fit: BoxFit.cover,
                            width: EdTechAppStyles(context).width,
                            height: EdTechAppStyles(context).width * 9 / 16),
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
                          videoUrl = "";
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

  void _onClickPost() async {
    try {
      LoadingDialog.showLoadingDialog(context, "Đang sửa...");
      if (this.isSelectVideo) {
        var videoUrl = '';
        if (_videoSelected != null) {
          var videoFile = await uploadVideo(_videoSelected);
          videoUrl = videoFile.file_url;
        } else {
          videoUrl = this.videoUrl;
        }
        await postBloc.updateVideoPost(
            this.widget.post.post_id,
            targetPost,
            DataSingleton.instance.classSelected.classroom_id,
            selectedStudents,
            _contentController.text.trim(),
            this.thumbnailUrl,
            videoUrl);
        DataSingleton.instance.removeSelected();
        LoadingDialog.hideLoadingDialog(context);
        Navigator.of(context).pop();
      } else {
        await postBloc.updatePost(
            this.widget.post.post_id,
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
        setState(() {
          thumbnailVideo = thumbnailPath;
          isSelectVideo = true;
        });
      }
    } catch (e) {
      print("On error " + e.toString());
    }
  }

  Future uploadImage(File image) async {
    SnackBarDialog.showLoadingView(_scaffoldContext, IMAGE_LOADING);
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
      if (this._videoSelected != null) {
        return VideoPlayerScreen(file: file);
      } else {
        return VideoPlayerScreen(networkUrl: this.videoUrl);
      }
    }));
  }
}
