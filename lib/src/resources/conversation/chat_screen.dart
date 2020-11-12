import 'package:bla_chat_sdk/BlaChannel.dart';
import 'package:bla_chat_sdk/BlaChannelType.dart';
import 'package:bla_chat_sdk/BlaMessage.dart';
import 'package:bla_chat_sdk/BlaMessageType.dart';
import 'package:bla_chat_sdk/BlaUser.dart';
import 'package:bla_chat_sdk/EventType.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'package:edtechteachersapp/src/blocs/bloc_provider.dart';
import 'package:edtechteachersapp/src/blocs/chat_bloc.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/widgets/chat/index.dart';
import 'package:edtechteachersapp/src/resources/conversation/group_detail.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

BuildContext _scaffoldContext;

class ChatScreen extends StatefulWidget {
  BlaChannel conversation;
  String myID;
  List<BlaUser> listUsersOfChannel = [];

  ChatScreen(this.conversation, this.myID, this.listUsersOfChannel);

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(conversation, myID, listUsersOfChannel);
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _textEditingFocusNode = new FocusNode();
  ChatBloc chatBloc;
  var isTyping = false;
  var isShowSticker = false;
  var otherUserTyping = false;
  BlaUser userTyping;
  BlaChannel conversation;
  String conversationID;
  String myID;
  List<BlaUser> listUsersOfChannel = [];
  ScrollController _scrollPostsController;

  _ChatScreenState(this.conversation, this.myID, this.listUsersOfChannel);

  List<BlaMessage> listMessage = <BlaMessage>[];
  Map<String, BlaUser> mapMembers = Map();

  MessageListener messageListener;
  ChannelListener channelListener;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    conversationID = conversation.id;
    getMessage("", 50);
    handleTyping();
    _textEditingFocusNode.addListener(onFocusChange);
    initMessageListener();
    initChannelListener();
    _scrollPostsController = ScrollController();
    _scrollPostsController.addListener(_scrollPostsListener);
  }

  void initMessageListener() async {
    messageListener = MessageListener(onNewMessage: (message) {
      if (message.channelId == conversationID) {
        if (message.author.id == myID) {
          if (listMessage.length > 0 && listMessage[0].id == message.id) {
            listMessage[0] = message;
          } else {
            listMessage.insert(0, message);
          }
        } else {
          listMessage.insert(0, message);
        }
        chatBloc.onNewMessageListener();
      }
    }, onDeleteMessage: (messageId) {
      for (var i = 0; i < listMessage.length; i++) {
        if (listMessage[i].id == messageId) {
          listMessage.removeAt(i);
          break;
        }
      }
      chatBloc.onNewMessageListener();
    }, onUserSeen: (message, user, time) {
      var editMessage =
          listMessage.firstWhere((element) => element.id == message.id);
      editMessage.seenBy = message.seenBy;
      chatBloc.onNewMessageListener();
    }, onUserReceive: (message, user, time) {
      var editMessage =
          listMessage.firstWhere((element) => element.id == message.id);
      editMessage.receivedBy = message.receivedBy;
      chatBloc.onNewMessageListener();
    });
    await BlaChatSdk.instance.addMessageListener(messageListener);
  }

  void initChannelListener() async {
    channelListener = ChannelListener(onTyping: (channel, user, eventType) {
      if (channel.id == conversationID && user.id != myID) {
        userTyping = user;
        otherUserTyping = eventType == EventType.START;
        chatBloc.onNewMessageListener();
      }
    }, onUserSeenMessage: (channel, user, message) {
    }, onUserReceiveMessage: (channel, user, message) {
    });
    await BlaChatSdk.instance.addChannelListener(channelListener);
  }

  void onFocusChange() {
    if (_textEditingFocusNode.hasFocus) {
      // Hide sticker when keyboard appear
      isShowSticker = false;
      chatBloc.onShowStickerListener();
    }
  }

  @override
  void dispose() {
    _textEditingFocusNode.dispose();
    removeListener();
    _scrollPostsController.dispose();
    super.dispose();
  }

  _scrollPostsListener() {
    if (_scrollPostsController.offset >=
            _scrollPostsController.position.maxScrollExtent &&
        !_scrollPostsController.position.outOfRange) {
      getMessage(listMessage.last.id, 20);
    }
  }

  void removeListener() async {
    await BlaChatSdk.instance.removeChannelListener(channelListener);
    await BlaChatSdk.instance.removeMessageListener(messageListener);
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context;
    String _avatar = "";
    String _name = "";
    bool _isOnline = false;
    bool _isSeen = false;
    getInfoConversation(conversation, listUsersOfChannel,
        (avatar, name, isOnline, isSeen) {
      _avatar = avatar;
      _name = name;
      _isOnline = isOnline;
      _isSeen = isSeen;
    });
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: EdTechColors.backgroundColor,
            brightness: Brightness.light,
            elevation: 1,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: EdTechColors.textBlackColor,
                  size: EdTechIconSizes.medium),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.info,
                    size: EdTechIconSizes.medium,
                    color: EdTechColors.mainColor),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return GroupDetailScreen(conversation: this.widget.conversation, myId: this.widget.myID,);
                  }));
                },
              ),
            ],
            title: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  MyCircleAvatar(
                    imgUrl: _avatar,
                  ),
                  SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Text(
                            _name,
                            style: TextStyle(
                                fontSize: EdTechFontSizes.simple,
                                fontWeight: EdTechFontWeight.semibold,
                                color: EdTechColors.textBlackColor),
                            overflow: TextOverflow.clip,
                          )),
                      _isOnline
                          ? Text(
                              "Đang hoạt động",
                              style: TextStyle(
                                  fontSize: EdTechFontSizes.small,
                                  color: EdTechColors.greenColor),
                            )
                          : Container()
                    ],
                  )
                ],
              ),
            )),
        body: new Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
//          return getBody();
          return Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: EdTechColors.backgroundChat,
                  image: DecorationImage(
                      image: AssetImage('assets/img/chat_background.png'),
                      fit: BoxFit.cover),
                ),
                width: double.infinity,
                height: double.infinity,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: getBody(),
              )
            ],
          );
        }));
  }

  getBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder(
            stream: chatBloc.onNewMessageController,
            builder: (context, snapshot) => ListView.builder(
              controller: _scrollPostsController,
              padding: const EdgeInsets.all(7.0),
              reverse: true,
              itemCount: listMessage.length + (otherUserTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (otherUserTyping) {
                  if (index == 0) {
                    return TypingMessageWidget(user: userTyping);
                  } else {
                    final newIndex = index - 1;
                    final message = listMessage[newIndex];
                    final beforeMessage =
                        newIndex == 0 ? null : listMessage[newIndex - 1];
                    final afterMessage = newIndex == listMessage.length - 1
                        ? null
                        : listMessage[newIndex + 1];
                    if (message.isSystemMessage) {
                      return SystemMessageWidget(
                          message: message,
                          beforeMessage: beforeMessage,
                          afterMessage: afterMessage);
                    } else {
                      if (listMessage[newIndex].author.id == myID) {
                        return SentMessageWidget(
                            message: message,
                            beforeMessage: beforeMessage,
                            afterMessage: afterMessage);
                      } else {
                        return ReceivedMessagesWidget(
                            message: listMessage[newIndex],
                            beforeMessage: beforeMessage,
                            afterMessage: afterMessage,
                            channel: conversation);
                      }
                    }
                  }
                } else {
                  final message = listMessage[index];
                  final beforeMessage =
                      index == 0 ? null : listMessage[index - 1];
                  final afterMessage = index == listMessage.length - 1
                      ? null
                      : listMessage[index + 1];
                  if (message.isSystemMessage) {
                    return SystemMessageWidget(
                        message: message,
                        beforeMessage: beforeMessage,
                        afterMessage: afterMessage);
                  } else {
                    if (listMessage[index].author.id == myID) {
                      return GestureDetector(
                        onLongPress: () {
                          ActionDialog.showActionDialog(context, "Chú ý",
                              "Bạn muốn xoá tin nhắn.", "Không", "Xoá", () {
                            deleteMessage(message);
                          });
                        },
                        child: SentMessageWidget(
                            message: message,
                            beforeMessage: beforeMessage,
                            afterMessage: afterMessage),
                      );
                    } else {
                      return ReceivedMessagesWidget(
                          message: listMessage[index],
                          beforeMessage: beforeMessage,
                          afterMessage: afterMessage,
                          channel: conversation);
                    }
                  }
                }
              },
            ),
          ),
        ),
        StreamBuilder(
            stream: chatBloc.onNewMessageController,
            builder: (context, snapshot) =>
                listMessage.length == 0 ? StartMessageWidget() : Container()),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: EdTechColors.grey,
                  width: 0.5,
                ),
              )),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StreamBuilder(
                  stream: chatBloc.onTypingController,
                  builder: (context, snapshot) => isTyping
                      ? SizedBox(
                          width: 16,
                        )
                      : Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.photo_camera,
                                  size: EdTechIconSizes.medium,
                                  color: EdTechColors.mainColor),
                              onPressed: getImageFromCamera,
                            ),
                            IconButton(
                              icon: Icon(Icons.photo,
                                  size: EdTechIconSizes.medium,
                                  color: EdTechColors.mainColor),
                              onPressed: getImageFromLibrary,
                            ),
                          ],
                        )),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: EdTechColors.dividerColor.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          focusNode: _textEditingFocusNode,
                          decoration: InputDecoration(
                              hintText: "Nhập tin nhắn...",
                              border: InputBorder.none),
                          minLines: 1,
                          maxLines: 4,
                          style: TextStyle(
                              color: EdTechColors.textBlackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.face,
                              size: EdTechIconSizes.medium,
                              color: EdTechColors.mainColor),
                          onPressed: () {
                            _textEditingFocusNode.unfocus();
                            isShowSticker = true;
                            chatBloc.onShowStickerListener();
                          }),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: chatBloc.onTypingController,
                builder: (context, snapshot) => isTyping
                    ? IconButton(
                        icon: Icon(Icons.send,
                            size: EdTechIconSizes.medium,
                            color: EdTechColors.mainColor),
                        onPressed: () {
                          createMessage(_textEditingController.text.trim(),
                              BlaMessageType.TEXT);
                        },
                      )
                    : SizedBox(width: 10),
              )
            ],
          ),
        ),
        StreamBuilder(
            stream: chatBloc.onShowStickerController,
            builder: (context, snapshot) =>
                isShowSticker ? buildSticker() : Container())
      ],
    );
  }

  void getInfoConversation(
      BlaChannel channel,
      List<BlaUser> users,
      Function(String avatar, String name, bool isOnline, bool isSeen)
          onResult) {
    String avatar = "";
    String name = "";
    bool isOnline = false;
    bool isSeen = false;
    if (channel.type == BlaChannelType.DIRECT) {
      for (var user in users) {
        if (user.id != myID) {
          avatar = user.avatar != null
              ? user.avatar
              : "http://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";
          name = user.name != null ? user.name : "EdTech";
          isOnline = user.online;
        }
      }
    } else {
      avatar = channel.avatar != null
          ? channel.avatar
          : "http://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";
      name = channel.name != null ? channel.name : "EdTech";
      for (var user in users) {
        if (user.online) {
          isOnline = true;
          break;
        }
      }
    }
    if (channel.lastMessage != null) {
      for (var user in channel.lastMessage.seenBy) {
        if (user.id != myID) {
          isSeen = true;
          break;
        }
      }
    }
    onResult(avatar, name, isOnline, isSeen);
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 4,
      columns: 8,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        _textEditingController.text = _textEditingController.text + emoji.emoji;
      },
    );
  }

  void getMessage(String lastId, int limit) async {
    BlaChatSdk.instance
        .getMessages(conversationID, lastId, limit)
        .then((listMessages) {
      if (mounted) {
        if (listMessages.length > 0) {
          listMessage.addAll(listMessages);
          markSeenMessage(listMessage.first.id);
          chatBloc.onNewMessageListener();
        }
      }
    });
  }

  void markSeenMessage(String messageId) async {
    await BlaChatSdk.instance.markSeenMessage(messageId, conversationID);
  }

  void createMessage(String content, BlaMessageType type) async {
    _textEditingController.clear();
    BlaMessage newMessage = await BlaChatSdk.instance
        .createMessage(content, conversationID, type, mapMembers);
    listMessage.insert(0, newMessage);
    chatBloc.onNewMessageListener();
  }

  void handleTyping() {
    _textEditingController.addListener(() {
      if (_textEditingController.text.trim().isEmpty) {
        BlaChatSdk.instance.sendStopTyping(conversationID);
        isTyping = false;
        chatBloc.onTypingListener();
      } else if (_textEditingController.text.trim().isNotEmpty &&
          isTyping == false) {
        BlaChatSdk.instance.sendStartTyping(conversationID);
        isTyping = true;
        chatBloc.onTypingListener();
      }
    });
  }

  Future deleteMessage(BlaMessage message) async {
    var test = await BlaChatSdk.instance.deleteMessage(message);
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1500, maxWidth: 1500);
    if (image == null) {
      SnackBarDialog.showNoImageView(_scaffoldContext, "Chưa chụp ảnh");
    } else {
      uploadImage(image);
    }
  }

  Future getImageFromLibrary() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1500, maxWidth: 1500);
    if (image == null) {
      SnackBarDialog.showNoImageView(_scaffoldContext, "Chưa chọn ảnh");
    } else {
      uploadImage(image);
    }
  }

  Future uploadImage(File image) async {
    try {
      SnackBarDialog.showLoadingView(_scaffoldContext, 'Đang tải ảnh lên...');
      var newImage = await chatBloc.uploadImage(image);
      SnackBarDialog.showSuccessView(_scaffoldContext, 'Tải ảnh thành công');
      createMessage(newImage.file_url, BlaMessageType.IMAGE);
    } catch (e) {
      SnackBarDialog.showErrorView(_scaffoldContext, 'Tải ảnh lỗi');
    }
  }
}
