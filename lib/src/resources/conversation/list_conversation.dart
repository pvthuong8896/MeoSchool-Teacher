import 'package:bla_chat_sdk/BlaChannel.dart';
import 'package:bla_chat_sdk/BlaChannelType.dart';
import 'package:bla_chat_sdk/BlaMessageType.dart';
import 'package:bla_chat_sdk/BlaUser.dart';
import 'package:edtechteachersapp/src/app.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/widgets/notification/notification_widget.dart';
import 'package:edtechteachersapp/src/resources/conversation/chat_screen.dart';
import 'package:edtechteachersapp/src/resources/notification/index.dart';
import 'package:flutter/material.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'create_conversation.dart';

class ListConversation extends StatefulWidget {
  ListConversation({Key key}) : super(key: key);

  @override
  _ListConversationState createState() => _ListConversationState();
}

class _ListConversationState extends State<ListConversation> {
  String userId = DataSingleton.instance.edUser.chatId;
  String token = DataSingleton.instance.edUser.chatToken;
  ChatBloc chatBloc;
  NotificationBloc notificationBloc;
  TextEditingController _searchController = new TextEditingController();
  List<BlaChannel> _channels = [];
  List<BlaChannel> _searchResult = [];
  Map<String, List<BlaUser>> _listUsersOfChannel = Map();
  ChannelListener channelListener;
  ScrollController _scrollPostsController;

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    super.initState();
    getConversations("", 20);
    initChannelListener();
    _scrollPostsController = ScrollController();
    _scrollPostsController.addListener(_scrollPostsListener);
  }

  @override
  void dispose() {
    removeListener();
    _scrollPostsController.dispose();
    super.dispose();
  }

  _scrollPostsListener() {
    if (_scrollPostsController.offset >=
            _scrollPostsController.position.maxScrollExtent &&
        !_scrollPostsController.position.outOfRange) {
      getConversations(_channels.last.id, 20);
    }
  }

  void removeListener() async {
    await BlaChatSdk.instance.removeChannelListener(channelListener);
  }

  void initChannelListener() async {
    channelListener = ChannelListener(onTyping: (channel, user, eventType) {
      //
    }, onNewChannel: (channel) async {
      Map<String, List<BlaUser>> listUsersOfChannel = Map();
      var members = await getMembersOfChannel(channel.id);
      listUsersOfChannel[channel.id] = members;
      _listUsersOfChannel.addAll(listUsersOfChannel);
      _channels.insert(0, channel);
      chatBloc.onNewChannelListener();
    }, onUpdateChannel: (channel) {
      for (var i = 0; i < _channels.length; i++) {
        if (_channels[i].id == channel.id) {
          if (channel.updatedAt.millisecondsSinceEpoch != _channels[i].updatedAt.millisecondsSinceEpoch) {
            _channels.removeAt(i);
            _channels.insert(0, channel);
            break;
          } else {
            _channels[i] = channel;
          }
        }
      }
      chatBloc.onNewChannelListener();
    }, onDeleteChannel: (channelId) {
      for (var i = 0; i < _channels.length; i++) {
        if (_channels[i].id == channelId) {
          _channels.removeAt(i);
          break;
        }
      }
      chatBloc.onNewChannelListener();
    });
    await BlaChatSdk.instance.addChannelListener(channelListener);
  }

  void getConversations(String lastId, int limit) async {
    try {
      var channels = await BlaChatSdk.instance.getChannels(lastId, limit);
      Map<String, List<BlaUser>> listUsersOfChannel = Map();
      for (int i = 0; i < channels.length; i++) {
        var members = await getMembersOfChannel(channels[i].id);
        listUsersOfChannel[channels[i].id] = members;
      }
      _listUsersOfChannel.addAll(listUsersOfChannel);
      _channels.addAll(channels);
      chatBloc.onNewChannelListener();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<List<BlaUser>> getMembersOfChannel(String channelID) async {
    return await BlaChatSdk.instance.getUsersInChannel(channelID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EdTechColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: EdTechColors.backgroundColor,
        brightness: Brightness.light,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: EdTechColors.textBlackColor, size: EdTechIconSizes.medium),
          onPressed: backToHome,
        ),
        actions: [
          StreamBuilder(
              stream: notificationBloc.numberOfNotificationController,
              builder: (context, snapshot) {
                return NotificationWidget().buildNotificationWidget(context, EdTechColors.textBlackColor);
              })
        ],
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            DataSingleton.instance.classSelected.name,
            style: TextStyle(
                fontWeight: EdTechFontWeight.semibold,
                color: EdTechColors.textBlackColor,
                fontSize: EdTechFontSizes.medium),
          ),
        ),
      ),
      floatingActionButton: Container(
          margin: EdgeInsets.only(right: 10),
          width: 44,
          height: 44,
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return CreateConversationScreen();
            })),
            child: Icon(
              Icons.edit,
              color: EdTechColors.textWhiteColor,
            ),
            backgroundColor: EdTechColors.mainColor,
          )),
      body: getBody(),
    );
  }

  Widget getBody() {
    return StreamBuilder(
        stream: chatBloc.onNewChannelController,
        builder: (context, snapshot) {
          if (_channels.isNotEmpty) {
            return ListView.builder(
              controller: _scrollPostsController,
              itemCount: _searchResult.isEmpty
                  ? _channels.length + 1
                  : _searchResult.length + 1,
              itemBuilder: (context, position) {
                if (position == 0) {
                  return _buildSearchUI();
                } else {
                  final index = position - 1;
                  final channel = _searchResult.isEmpty
                      ? _channels[index]
                      : _searchResult[index];
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(channel, userId,
                                  _listUsersOfChannel[channel.id])),
                        );
                      },
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: _buildConversationUI(channel),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                              caption: 'Xoá',
                              color: EdTechColors.redColor,
                              icon: Icons.delete,
                              onTap: () => deleteChannel(channel)),
                        ],
                      ));
                }
              },
            );
          } else {
            return NodataView.showNodataView(context, "Chưa có cuộc trò chuyện nào.");
          }
        });
  }

  void getInfoConversation(
      BlaChannel channel,
      List<BlaUser> users,
      Function(String avatar, String name, bool isOnline, bool isSeen,
              String contentLastMessage)
          onResult) {
    String avatar = "";
    String name = "";
    bool isOnline = false;
    bool isSeen = false;
    String contentLastMessage = "Chưa có tin nhắn";
    if (channel.type == BlaChannelType.DIRECT) {
      for (var user in users) {
        if (user.id != userId) {
          avatar = channel.avatar != null
              ? channel.avatar
              : "http://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";
          name = channel.name != null ? channel.name : "";
          isOnline = user.online;
        }

      }
    } else {
      avatar = channel.avatar != null
          ? channel.avatar
          : "http://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";
      name = channel.name != null ? channel.name : "";
      for (var user in users) {
        if (user.online) {
          isOnline = true;
          break;
        }
      }
    }
    if (channel.lastMessage != null) {
      if (channel.lastMessage.type == BlaMessageType.TEXT) {
        contentLastMessage = channel.lastMessage.content;
      } else if (channel.lastMessage.type == BlaMessageType.IMAGE) {
        contentLastMessage = "Tin nhắn hình ảnh";
      } else {
        contentLastMessage = "Tin nhắn mới";
      }
    }
    if (channel.lastMessage != null) {
      for (var user in channel.lastMessage.seenBy) {
        if (user.id != userId) {
          isSeen = true;
          break;
        }
      }
    }
    onResult(avatar, name, isOnline, isSeen, contentLastMessage);
  }

  Widget _buildConversationUI(BlaChannel channel) {
    List<BlaUser> users = _listUsersOfChannel[channel.id];
    String _avatar = "";
    String _name = "";
    bool _isOnline = false;
    bool _isSeen = false;
    String _contentLastMessage = "";
    getInfoConversation(channel, users,
        (avatar, name, isOnline, isSeen, contentLastMessage) {
      _avatar = avatar;
      _name = name;
      _isOnline = isOnline;
      _isSeen = isSeen;
      _contentLastMessage = contentLastMessage;
    });
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(15),
          child: Row(children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      offset: Offset(0, 5),
                      blurRadius: 25)
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: EdTechColors.dividerColor,
                      backgroundImage: NetworkImage(_avatar),
                    ),
                  ),
                  _isOnline
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: TextStyle(
                        fontWeight: EdTechFontWeight.semibold,
                        color: EdTechColors.textBlackColor,
                        fontSize: EdTechFontSizes.simple),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(_contentLastMessage,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: _isSeen
                          ? TextStyle(
                              fontWeight: EdTechFontWeight.medium,
                              color: EdTechColors.textBlackColor,
                              fontSize: EdTechFontSizes.normal)
                          : TextStyle(
                              fontWeight: EdTechFontWeight.normal,
                              color: EdTechColors.textColor,
                              fontSize: EdTechFontSizes.normal)),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _isSeen
                        ? Icon(
                            Icons.done_all,
                            size: 15,
                          )
                        : Container(height: 15, width: 15),
                    Text(
                        EdTechConvertData.conversationTime(channel.updatedAt),
                        style: TextStyle(
                            fontWeight: EdTechFontWeight.normal,
                            color: EdTechColors.textColor,
                            fontSize: EdTechFontSizes.small))
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                int.parse(channel.numberMessageUnread,
                            onError: (source) => -1) >
                        0
                    ? Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: EdTechColors.mainColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          channel.numberMessageUnread,
                          style: TextStyle(
                              fontSize: EdTechFontSizes.small,
                              color: EdTechColors.textWhiteColor),
                        ),
                      )
                    : Container(
                        height: 20,
                        width: 20,
                      ),
              ],
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          height: 1,
          color: EdTechColors.dividerColor,
        )
      ],
    );
  }

  Widget _buildSearchUI() {
    return Container(
        margin: EdgeInsets.fromLTRB(16, 10, 12, 0),
        height: 40,
        decoration: BoxDecoration(
          color: EdTechColors.dividerColor.withOpacity(0.35),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Icon(Icons.search,
                  size: EdTechIconSizes.medium, color: EdTechColors.textColor),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: new InputDecoration(
                    hintText: 'Tìm kiếm', border: InputBorder.none),
                onChanged: onSearchTextChanged,
              ),
            ),
            IconButton(
              icon: new Icon(Icons.cancel,
                  size: EdTechIconSizes.normal, color: EdTechColors.textColor),
              onPressed: () {
                _searchController.clear();
                onSearchTextChanged('');
              },
            ),
          ],
        ));
  }

  Future deleteChannel(BlaChannel channel) async {
    await BlaChatSdk.instance.deleteChannel(channel);
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      chatBloc.onNewChannelListener();
      return;
    }
    _searchResult = await BlaChatSdk.instance.searchChannels(text);
    chatBloc.onNewChannelListener();
  }

  void backToHome() {
    DataSingleton.instance.backToHome();
    Navigator.of(context).pop();
  }
}
