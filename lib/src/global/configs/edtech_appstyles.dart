import 'package:flutter/material.dart';

// Loading data
const LOADING = "Loading";
const DONE = "Done";
const EMPTY = "Empty";
const UPDATE = "Update";
const DELETE = "Delete";
// Loading image,video
const FROM_CAMERA = 'Máy ảnh';
const FROM_LIBRARY = 'Thư viện ảnh';
const FROM_VIDEO = 'Video';
const IMAGE_NULL = "Chưa chụp ảnh";
const IMAGE_LOADING = 'Đang tải ảnh lên...';
const IMAGE_LOAD_SUCCESS = 'Tải ảnh thành công';
const IMAGE_LOAD_ERROR = 'Tải ảnh lỗi';

const VIDEO_LOADING = 'Đang tải ảnh lên...';
const VIDEO_LOAD_SUCCESS = 'Tải ảnh thành công';
const VIDEO_LOAD_ERROR = 'Tải ảnh lỗi';
// Post target
const CLASS_ROOM = 'classroom';
const STUDENT = 'student';
const GROUP = 'group';
// Chat
const CHAT_GROUP = 1;
const CHAT_DIRECT = 2;
// Notification Center
const CHANNEL_NAME = 'logout_event';
// Checking
const CHECKIN = 'checkin';
const CHECKOUT = 'checkout';
const ABSENT = 'absent';
const CHECKING_SUCCESS = "Điểm danh thành công";
const CHECKING_ERROR = "Điểm danh lỗi";
// Store type
const GENERAL = "general";
const HEALTH = "health";
const STUDY = "study";

const guidelineBaseWidth = 375.0;
const guidelineBaseHeight = 812.0;
const messageBorder = 8.0;

class EdTechAppStyles {
  BuildContext context;

  EdTechAppStyles(this.context) : assert (context != null);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  scaleWidth(double thisWidth) {
    return (thisWidth/guidelineBaseWidth) * width;
  }

  scaleHeight(double thisHeight) {
    return (thisHeight/guidelineBaseHeight) * width;
  }
}
EdTechAppStyles globalSize;

// use this!!!!
scaleWidth(double thisWidth) {
  return (thisWidth/guidelineBaseWidth) * globalSize.width; 
}
// not recommended
scaleHeight(double thisHeight) {
  return (thisHeight/guidelineBaseHeight) * globalSize.width; 
}