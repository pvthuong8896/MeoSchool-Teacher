import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/photo_viewer/photo_viewer.dart';
import 'package:edtechteachersapp/src/resources/post/index.dart';
import 'package:edtechteachersapp/src/resources/post/update_post_screen.dart';
import 'package:edtechteachersapp/src/resources/post/video_widget.dart';
import 'package:edtechteachersapp/src/resources/video_player/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  PostDetailScreen({Key key, this.post}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final addCommentFocusNode = FocusNode();
  PostBloc postBloc;
  final TextEditingController _contentController = TextEditingController();
  List<Comment> listComments = [];

  static const String deleteComment = 'Xoá bình luận';
  static const String editComment = 'Sửa bình luận';
  static const String DELETE_POST = 'Xoá bài viết';
  static const String EDIT_POST = 'Sửa bài viết';
  List<String> post_choices = [EDIT_POST, DELETE_POST];

  final choices = [editComment, deleteComment];
  bool isEditing = false;
  Comment selectedComment = Comment();
  ScrollController _mainScrollController = ScrollController();
  final GlobalKey _commentWidgetKey = GlobalKey();
  final GlobalKey _postWidgetKey = GlobalKey();
  Offset widgetPosition;
  Size postSize;

  @override
  void initState() {
    super.initState();
    postBloc = BlocProvider.of<PostBloc>(context);
    postBloc.getListComment(this.widget.post.post_id, (comments) {
      listComments = comments;
    }, (message) {});
    postBloc.getPostDetail(this.widget.post.post_id);
    selectedComment = null;
    _mainScrollController.addListener(_scrollCommentsListener);
  }

  _scrollCommentsListener() {
    if (_mainScrollController.offset >=
            _mainScrollController.position.maxScrollExtent &&
        !_mainScrollController.position.outOfRange) {
      postBloc.loadMoreComments(widget.post.post_id, (results) {
        listComments += results;
      }, (message) {});
    }
  }

  getPositionAndScroll() {
    RenderBox widgetBox = _commentWidgetKey.currentContext.findRenderObject();
    double scrollControllerPos = _mainScrollController.offset;
    widgetPosition = widgetBox.localToGlobal(Offset.zero);
    double scrolling = scrollControllerPos + widgetPosition.dy - 80.0;
    _mainScrollController.jumpTo(scrolling);
  }

  scrollToNewComment() {
    RenderBox postBox = _postWidgetKey.currentContext.findRenderObject();
    postSize = postBox.size;
    double scrolling = postSize.height;

    _mainScrollController.animateTo(scrolling,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: isEditing
                ? EdTechColors.mainColor
                : EdTechColors.backgroundColor,
            brightness: Brightness.light,
            title: isEditing
                ? Text(
                    "Sửa bình luận",
                    style: TextStyle(color: Colors.white),
                  )
                : Text(""),
            elevation: 1,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: isEditing ? Colors.white : EdTechColors.textBlackColor,
                  size: EdTechIconSizes.medium),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              isEditing
                  ? IconButton(
                      icon: Icon(Icons.close,
                          size: EdTechIconSizes.medium, color: Colors.white),
                      onPressed: () {
                        _contentController.clear();
                        addCommentFocusNode.unfocus();
                        setState(() {
                          isEditing = false;
                          selectedComment = null;
                        });
                      },
                    )
                  : PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert,
                          size: EdTechIconSizes.medium,
                          color: EdTechColors.textBlackColor),
                      onSelected: choiceAction,
                      itemBuilder: (BuildContext context) {
                        return post_choices.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: statusMenuBar(choice),
                          );
                        }).toList();
                      },
                    )
            ]),
        body: getBody());
  }

  getBody() {
    return new GestureDetector(
        onTap: () {
          addCommentFocusNode.unfocus();
        },
        child: Container(
          color: EdTechColors.backgroundColor,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            new Expanded(child: _buildListUI()),
            Column(
              children: [
                Container(
                  height: 0.5,
                  color: EdTechColors.dividerColor,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(width: 4.0),
                    new Container(
                      width: 28.0,
                      height: 28.0,
                      decoration: new BoxDecoration(
                        color: EdTechColors.textColor,
                        image: new DecorationImage(
                          image: DataSingleton.instance.edUser.avatar != null
                              ? new NetworkImage(
                                  DataSingleton.instance.edUser.avatar)
                              : AssetImage('assets/img/avatar_default.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(30.0)),
                        border: new Border.all(
                          color: EdTechColors.textColor,
                          width: 0.1,
                        ),
                      ),
                    ),
                    Container(
                      width: EdTechAppStyles(context).width - 120,
                      child: TextField(
                          controller: _contentController,
                          focusNode: addCommentFocusNode,
                          minLines: 1,
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: EdTechFontSizes.normal,
                              fontWeight: EdTechFontWeight.normal,
                              color: EdTechColors.textBlackColor),
                          decoration: InputDecoration(
                            hintText: isEditing
                                ? "Sửa bình luận..."
                                : "Thêm bình luận...",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          )),
                    ),
                    InkWell(
                        onTap: () async {
                          if (_contentController.text.trim().length == 0) {
                            ToastMessage.showToastMessage(
                                context, "Không để trống trường này");
                          } else {
                            try {
                              if (isEditing) {
                                var comment = await postBloc.clickEditComment(
                                    selectedComment.comment_id,
                                    _contentController.text.trim());
                                for (var i = 0; i < listComments.length; i++) {
                                  if (listComments[i].comment_id ==
                                      selectedComment.comment_id) {
                                    listComments[i] = comment;
                                    break;
                                  }
                                }
                                _contentController.clear();
                                addCommentFocusNode.unfocus();
                                setState(() {
                                  isEditing = false;
                                  selectedComment = null;
                                  listComments = listComments;
                                });
                                ToastMessage.showToastMessage(
                                    context, "Sửa thành công");
                              } else {
                                var comment = await postBloc.clickComment(this.widget.post.post_id, _contentController.text.trim());
                                listComments.insert(0, comment);
                                _contentController.clear();
                                addCommentFocusNode.unfocus();
                                setState(() {
                                  selectedComment = null;
                                  listComments = listComments;
                                });
                                Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                              (_) => scrollToNewComment());
                                    });
                                ToastMessage.showToastMessage(
                                    context, "Đăng bình luận thành công");
                              }
                            } catch (e) {
                              ToastMessage.showToastMessage(
                                  context, e.toString());
                            }
                          }
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          child: Icon(isEditing ? Icons.check : Icons.send,
                              size: EdTechIconSizes.medium,
                              color: EdTechColors.mainColor),
                        )),
                    SizedBox(
                      width: 4.0,
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ]),
        ));
  }

  Widget _buildListUI() => StreamBuilder(
        stream: postBloc.listCommentController,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // handle load comments and updating comments (delete, edit,...)
            if (snapshot.data == DONE) {
              return ListView.builder(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0),
                  controller: _mainScrollController,
                  itemCount: listComments.length + 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return _buildPostWidget(this.widget.post);
                    } else if (index == listComments.length + 1) {
                      return StreamBuilder(
                          stream: postBloc.loadMoreCommentsController,
                          builder: (context, snapshot) {
                            if (snapshot.data == DONE) {
                              // results in _onScroll function
                            } else if (snapshot.data == EMPTY ||
                                listComments.length < 10) {
                              return Column(
                                children: <Widget>[
                                  SizedBox(height: 10.0),
                                  Text(
                                      listComments.length == 0
                                          ? "Chưa có bình luận"
                                          : "Bạn đã xem hết bình luận 🤖",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: EdTechFontSizes.small,
                                          color: Colors.grey[500],
                                          fontWeight: EdTechFontWeight.normal)),
                                  SizedBox(height: 10.0),
                                ],
                              );
                            }
                            // loader
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                edTechLoaderWidget(20.0, 20.0),
                                SizedBox(height: 10.0),
                              ],
                            );
                          });
                    } else {
                      return _buildCommentItem(
                          listComments[index - 1], index - 1);
                    }
                  });
            } else if (snapshot.data == EMPTY) {
              return ListView.builder(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildPostWidget(this.widget.post);
                  });
            }
          }
          // loading comments
          return ListView.builder(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildPostWidget(this.widget.post);
                } else {
                  return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 15.0),
                      child: edTechLoaderWidget(15.0, 15.0));
                }
              });
        },
      );

  Widget _buildPostWidget(Post postItem) {
    if (postItem.videoUrl == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          _buildPostCard(postItem),
          SizedBox(height: 20),
          _buildSlideImage(postItem),
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
          _buildActionView(postItem),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 1,
            color: EdTechColors.dividerColor,
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          _buildPostCard(postItem),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
          _buildActionView(postItem),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 1,
            color: EdTechColors.dividerColor,
          ),
        ],
      );
    }
  }

  Widget _buildPostCard(Post postItem) {
    return Row(
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
                fontWeight: EdTechFontWeight.bold,
              ),
            ),
            Text(
              getTargetPost(postItem) +
                  " - " +
                  EdTechConvertData.timeAgoSinceDate(postItem.created_at),
              style: TextStyle(
                  fontSize: EdTechFontSizes.small,
                  color: EdTechColors.textColor,
                  fontWeight: EdTechFontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  String getTargetPost(Post postItem) {
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

  Widget _buildSlideImage(Post postItem) {
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
    var postItem = this.widget.post;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(postItem.content,
                maxLines: null,
                style: TextStyle(
                    color: EdTechColors.textBlackColor,
                    fontSize: 14,
                    fontWeight: EdTechFontWeight.bold)),
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
                                fontWeight: EdTechFontWeight.bold))
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
                              fontWeight: EdTechFontWeight.bold),
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
                                fontWeight: EdTechFontWeight.bold))
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

  Widget _buildActionView(Post postItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
              onTap: () {
                clickLikePost(postItem);
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
                                  fontWeight: EdTechFontWeight.bold))
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
              addCommentFocusNode.requestFocus();
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
                            fontWeight: EdTechFontWeight.bold))
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCommentItem(Comment comment, int index) {
    return Container(
        key: (selectedComment != null && isEditing)
            ? (comment.comment_id == selectedComment.comment_id)
                ? _commentWidgetKey
                : null
            : null,
        child: InkWell(
          onTap: (comment.user.user_id !=
                      DataSingleton.instance.edUser.user_id ||
                  selectedComment != null)
              ? () {
                  // dismiss keyboard
                  addCommentFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(new FocusNode());
                }
              : () {
                  setState(() {
                    selectedComment = comment;
                  });
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext buildContext) {
                        return WillPopScope(
                            onWillPop: () async {
                              _contentController.clear();
                              // dismiss keyboard
                              addCommentFocusNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              setState(() {
                                selectedComment = null;
                                // isEditing = false;
                              });
                              return true;
                            },
                            child: Container(
                              child: new Wrap(
                                children: <Widget>[
                                  new ListTile(
                                    leading: new Icon(Icons.edit,
                                        color: EdTechColors.textBlackColor,
                                        size: EdTechIconSizes.normal),
                                    title: new Text('Sửa bình luận'),
                                    onTap: () {
                                      Navigator.pop(context, editComment);
                                      editCommentAction(comment, index);
                                    },
                                  ),
                                  new ListTile(
                                      leading: new Icon(Icons.delete,
                                          color: EdTechColors.textBlackColor,
                                          size: EdTechIconSizes.normal),
                                      title: new Text('Xóa bình luận'),
                                      onTap: () {
                                        deleteCommentActionDialog() {
                                          deleteCommentAction(comment, index);
                                          ActionDialog.hideActionDialog(
                                              context);
                                        }
                                        ActionDialog.showActionDialog(
                                            context,
                                            "Xóa bình luận",
                                            "Bạn muốn xóa bình luận vĩnh viễn?",
                                            "Hủy",
                                            "Xóa",
                                            deleteCommentActionDialog);
                                      }),
                                ],
                              ),
                            ));
                      });
                },
          child: Stack(
            children: [
              new Container(
                margin: EdgeInsets.only(top: 10),
                width: 30.0,
                height: 30.0,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  image: new DecorationImage(
                    image: comment.user.avatar != null
                        ? new NetworkImage(comment.user.avatar)
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
              new Container(
                  margin: EdgeInsets.only(left: 40, top: 10, bottom: 10),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: (selectedComment != null)
                          ? selectedComment.comment_id == comment.comment_id
                              ? Border.all(
                                  color: EdTechColors.mainColor, width: 0.75)
                              : Border.all(
                                  color: Colors.transparent, width: 0.75)
                          : Border.all(color: Colors.transparent, width: 0.75),
                      color: EdTechColors.dividerColor.withOpacity(0.3),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            comment.user.name,
                            style: TextStyle(
                              color: EdTechColors.textBlackColor,
                              fontSize: EdTechFontSizes.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            EdTechConvertData.timeAgoSinceDate(
                                comment.created_at),
                            style: TextStyle(
                              fontSize: 12,
                              color: EdTechColors.grey,
                              fontWeight: EdTechFontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        comment.content,
                        style: TextStyle(
                            fontSize: EdTechFontSizes.normal,
                            color: EdTechColors.textBlackColor,
                            fontWeight: EdTechFontWeight.w600),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }

  void deleteCommentAction(Comment comment, int index) {
    postBloc.clickDeleteComment(comment.comment_id, (success) {
      listComments.removeAt(index);
      this.widget.post.total_comments = this.widget.post.total_comments - 1;
      setState(() {
        selectedComment = null;
      });
      ToastMessage.showToastMessage(context, success);
    }, (message) {
      ToastMessage.showToastMessage(context, message);
    });
  }

  void editCommentAction(Comment comment, int index) {
    _contentController.text = comment.content;
    addCommentFocusNode.requestFocus();
    setState(() {
      isEditing = true;
      selectedComment = comment;
    });
    Future.delayed(Duration(milliseconds: 200), () {
      if (_commentWidgetKey != null) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => getPositionAndScroll());
      }
    });
  }

  Text statusMenuBar(String choice) {
    return Text(choice,
        style: TextStyle(
            fontSize: EdTechFontSizes.normal,
            color: EdTechColors.textBlackColor));
  }

  void choiceAction(String choice) {
    if (choice == DELETE_POST) {
      ActionDialog.showActionDialog(context, "Chú ý!",
          "Bạn có muốn xoá bài viết này không?", "Huỷ", "Xoá", () {
        deletePostAction(this.widget.post.post_id);
      });
    } else if (choice == EDIT_POST) {
      print("run here " + this.widget.post.students.length.toString());
      if (this.widget.post.students.length == 1) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return UpdatePostScreen(
            post: this.widget.post,
            editPostAStudent: true,
          );
        }));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return UpdatePostScreen(
            post: this.widget.post,
            editPostAStudent: false,
          );
        }));
      }
    } else {
      //
    }
  }

  void deletePostAction(int post_id) async {
    try {
      await postBloc.deletePost(post_id);
      ToastMessage.showToastMessage(context, "Xoá thành công");
      Navigator.pop(context);
    } catch (message) {
      ToastMessage.showToastMessage(context, message);
    }
  }

  void clickLikePost(Post postItem) async {
    try {
      await postBloc.clickLikeButton(postItem.post_id);
    } catch (e) {}
  }
}
