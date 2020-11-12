import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/photo_viewer/photo_viewer.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:edtechteachersapp/src/resources/post/slide_image_widget.dart';
import 'package:edtechteachersapp/src/resources/post/update_post_screen.dart';
import 'package:edtechteachersapp/src/resources/post/video_widget.dart';
import 'package:edtechteachersapp/src/resources/video_player/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostWidget extends StatelessWidget {
  final Post postItem;
  final PostBloc postBloc;
  final BuildContext context;

  const PostWidget({Key key, this.postItem, this.postBloc, this.context})
      : super(key: key);

  void onSelectLike() async {
    try {
      await postBloc.clickLikeButton(this.postItem.post_id);
    } catch (e) {
      ToastMessage.showToastMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext thisContext) {
    return _buildPostWidget();
  }

  Widget _buildPostWidget() {
    if (postItem.videoUrl == null) {
      return Container(
          child: Column(
        children: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPostCard(),
                  SizedBox(height: 20),
                  _buildSlideImage(),
                  SizedBox(height: postItem.files.length == 0 ? 0 : 10),
                  _buildContentPost(),
                  SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: EdTechColors.dividerColor,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _buildActionView(),
                ],
              )),
          Container(
            width: double.infinity,
            height: 10,
            color: EdTechColors.dividerColor,
          )
        ],
      ));
    } else {
      return Container(
          child: Column(
        children: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPostCard(),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return VideoPlayerScreen(
                          networkUrl: postItem.videoUrl,
                        );
                      }));
                    },
                    child: VideoWidget(post: postItem),
                  ),
                  SizedBox(height: postItem.files.length == 0 ? 0 : 15),
                  _buildContentPost(),
                  SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: EdTechColors.dividerColor,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _buildActionView(),
                ],
              )),
          Container(
            width: double.infinity,
            height: 10,
            color: EdTechColors.dividerColor,
          )
        ],
      ));
    }
  }

  Widget _buildPostCard() {
    const String DELETE_POST = 'Xoá bài viết';
    const String EDIT_POST = 'Sửa bài viết';
    List<String> post_choices = [EDIT_POST, DELETE_POST];
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Row(
            children: <Widget>[
              new Container(
                width: 44.0,
                height: 44.0,
                decoration: new BoxDecoration(
                  color: EdTechColors.textColor,
                  image: new DecorationImage(
                    image: DataSingleton.instance.edUser.avatar != null
                        ? new NetworkImage(postItem.author.avatar)
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    postItem.author.name,
                    style: TextStyle(
                      color: EdTechColors.textBlackColor,
                      fontSize: EdTechFontSizes.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    getTargetPost() +
                        " - " +
                        EdTechConvertData.timeAgoSinceDate(postItem.created_at),
                    style: TextStyle(
                        fontSize: EdTechFontSizes.small,
                        color: EdTechColors.textColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.more_vert,
                size: EdTechIconSizes.medium, color: EdTechColors.grey),
          ),
          onSelected: (String choice) async {
            if (choice == DELETE_POST) {
              try {
                ActionDialog.showActionDialog(context, "Chú ý!",
                    "Bạn có muốn xoá bài viết này không?", "Huỷ", "Xoá", () async {
                  await postBloc.deletePost(postItem.post_id);
                  ToastMessage.showToastMessage(
                      context, "Xóa bài viết thành công");
                });
              } catch (e) {
                ToastMessage.showToastMessage(
                    context, "Có lỗi xảy ra: ${e.toString()}");
              }
            } else if (choice == EDIT_POST) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return UpdatePostScreen(
                  post: postItem,
                  editPostAStudent: false,
                );
              }));
            } else {}
          },
          itemBuilder: (BuildContext context) {
            return post_choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice,
                    style: TextStyle(
                        fontSize: EdTechFontSizes.normal,
                        color: EdTechColors.textBlackColor)),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  Widget _buildSlideImage() {
    if (postItem.files.length == 0) {
      return Container();
    }
    if (postItem.files.length == 1) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PhotoViewerScreen(
              listImage: postItem.files,
              initialIndex: 0,
            );
          }));
        },
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Image.network(
                postItem.files.first.file_url,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: edTechImageLoader,
              ),
            ),
          ),
        ),
      );
    }
    return SlideImageWidget(
      post: postItem,
      onSelectImage: (index) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PhotoViewerScreen(
            listImage: postItem.files,
            initialIndex: index,
          );
        }));
      },
    );
  }

  Widget _buildContentPost() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return PostDetailScreen(post: postItem);
              }));
            },
            child: Text(postItem.content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: EdTechColors.textBlackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))),
        StreamBuilder(
          stream: postBloc.clickLikeController,
          builder: (context, snapshot) {
            return Container(
                padding: EdgeInsets.only(top: 15),
                child: postItem.total_comments > 0 ||
                        postItem.total_likes > 0 ||
                        postItem.total_seens > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/img/icons/heart.svg',
                                height: 12,
                                width: 12,
                                color: EdTechColors.grey,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text("${postItem.total_likes} lượt thích",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: EdTechColors.grey,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/img/icons/comment.svg',
                                height: 12,
                                width: 12,
                                color: EdTechColors.grey,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "${postItem.total_comments} bình luận",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: EdTechColors.grey,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.remove_red_eye,
                                  size: EdTechIconSizes.small,
                                  color: EdTechColors.grey),
                              SizedBox(
                                width: 3,
                              ),
                              Text("${postItem.total_seens} lượt xem",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: EdTechColors.grey,
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        ],
                      )
                    : Text(
                        "Hãy trở thành người đầu tiên thích bài viết 👏",
                        style: TextStyle(
                            fontSize: 12,
                            color: EdTechColors.grey,
                            fontWeight: FontWeight.bold),
                      ));
          },
        )
      ],
    );
  }

  Widget _buildActionView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
              onTap: () {
                this.onSelectLike();
              },
              child: Center(
                child: StreamBuilder(
                    stream: postBloc.clickLikeController,
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          postItem.liked
                              ? SvgPicture.asset(
                                  'assets/img/icons/heart.svg',
                                  height: EdTechIconSizes.normal,
                                  width: EdTechIconSizes.normal,
                                  color: Colors.red[700],
                                )
                              : SvgPicture.asset(
                                  'assets/img/icons/heart-outline.svg',
                                  height: EdTechIconSizes.normal,
                                  width: EdTechIconSizes.normal,
                                  color: EdTechColors.grey,
                                ),
                          SizedBox(width: 10),
                          Text("Thích",
                              style: TextStyle(
                                  color: EdTechColors.textBlackColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold))
                        ],
                      );
                    }),
              )),
        ),
        SizedBox(
          width: 50,
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return PostDetailScreen(post: postItem);
              }));
            },
            child: StreamBuilder(
              stream: postBloc.listCommentController,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/img/icons/comment.svg',
                      height: EdTechIconSizes.normal,
                      width: EdTechIconSizes.normal,
                      color: EdTechColors.grey,
                    ),
                    SizedBox(width: 10),
                    Text("Bình luận",
                        style: TextStyle(
                            color: EdTechColors.textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold))
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }

  String getTargetPost() {
    if (postItem.visible_with == CLASS_ROOM) {
      return postItem.classRoom.name;
    } else if (postItem.visible_with == STUDENT) {
      return postItem.students.length == 1
          ? postItem.students.first.name
          : "${postItem.students.length} học sinh";
    } else if (postItem.visible_with == GROUP) {
      return "Group";
    }
    return "Group";
  }
}
