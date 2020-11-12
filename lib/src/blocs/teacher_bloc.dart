import 'dart:async';
import 'dart:io';
import 'package:edtechteachersapp/src/global/configs/edtech_appstyles.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/validators/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/repository/index.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';

class TeacherBloc extends Bloc {
  // ignore: non_constant_identifier_names
  final _user_api = UserAPI();
  // ignore: non_constant_identifier_names
  final _image_api = ImageAPI();

  List<ClassRoom> _listClassroom = [];
  List<Student> _listStudents = [];
  List<Teacher> _listTeachers = [];
  List<Parents> _listParents = [];
  List<Checking> _listCheckings = [];
  List<Story> _listStory = [];
  String _iconReportUrl = "";
  String _storyActionSelected = "";

  List<ClassRoom> get listClassRoom => _listClassroom;
  List<Student> get listStudents => _listStudents;
  List<Teacher> get listTeachers => _listTeachers;
  List<Parents> get listParents => _listParents;
  List<Checking> get listCheckings => _listCheckings;
  List<Story> get listStory => _listStory;
  String get iconReportUrl => _iconReportUrl;
  void setIconReportUrl(String newValue) {
    _iconReportUrl = newValue;
  }
  String get storyActionSelected => _storyActionSelected;
  void setstoryActionSelected(String newValue) {
    _storyActionSelected = newValue;
  }

  StreamController _listClassRoomController = new StreamController<String>.broadcast();
  StreamController _listStudentsController = new StreamController<String>.broadcast();
  StreamController _listTeachersController = new StreamController<String>.broadcast();
  StreamController _updateProfileTeacherSuccess = new StreamController<String>.broadcast();
  StreamController _listParentsController = new StreamController<String>.broadcast();
  StreamController _listConnectParentsController = new StreamController<String>.broadcast();
  StreamController _createCheckingController = new StreamController<String>.broadcast();
  StreamController _listCheckingController = new StreamController<String>.broadcast();
  StreamController _selectedTimeController = new StreamController<String>.broadcast();
  StreamController _listReportCategoryController = new StreamController<String>.broadcast();
  StreamController _listReportController = new StreamController<String>.broadcast();
  StreamController _selectedIconReportController = new StreamController<String>.broadcast();

  Stream get listClassRoomController => _listClassRoomController.stream;
  Stream get listStudentsController => _listStudentsController.stream;
  Stream get listTeachersController => _listTeachersController.stream;
  Stream get updateProfileTeacherSuccess => _updateProfileTeacherSuccess.stream;
  Stream get listParentsController => _listParentsController.stream;
  Stream get listConnectParentsController => _listConnectParentsController.stream;
  Stream get listCheckingController => _listCheckingController.stream;
  Stream get createCheckingController => _createCheckingController.stream;
  Stream get selectedTimeController => _selectedTimeController.stream;
  Stream get listReportCategoryController => _listReportCategoryController.stream;
  Stream get listReportController => _listReportController.stream;
  Stream get selectedIconReportController => _selectedIconReportController.stream;

  Future getListClassRoom() async {
    try {
      _listClassRoomController.sink.add(LOADING);
      _listClassroom = await _user_api.getListClassRoom();
      if (_listClassroom.isEmpty) {
        _listClassRoomController.sink.add(EMPTY);
      } else {
        _listClassRoomController.sink.add(DONE);
      }
    } catch (error) {
      _listClassroom = [];
      _listClassRoomController.sink.add(EMPTY);
    }
  }

  Future getListStudentsInClass(int classId) async {
    try {
      _listStudentsController.sink.add(LOADING);
      _listStudents = await _user_api.getListStudentsInClass(classId);
      if (_listStudents.isEmpty) {
        _listStudentsController.sink.add(EMPTY);
      } else {
        _listStudentsController.sink.add(DONE);
      }
    } catch (error) {
      _listStudents = [];
      _listStudentsController.sink.add(EMPTY);
    }
  }

  Future getListTeachersInClass(int classId) async {
    try {
      _listTeachersController.sink.add(LOADING);
      _listTeachers = await _user_api.getListTeachersInClass(classId);
      if (_listTeachers.isEmpty) {
        _listTeachersController.sink.add(EMPTY);
      } else {
        _listTeachersController.sink.add(DONE);
      }
    } catch (error) {
      _listTeachers = [];
      _listTeachersController.sink.add(EMPTY);
    }
  }

  void getListParents(int class_id) {
    _listParentsController.sink.add(LOADING);
    _user_api.getListParents(class_id, (results) {
      _listParents = results;
      _listParentsController.sink.add(DONE);
    }, (message) {
      _listParents = [];
      _listParentsController.sink.add(EMPTY);
    });
  }

  // SEND INVITATION
  bool isValidInvitePhonenumber(String phone) {
    if (LoginValidation.isValidPhone(phone)) {
      return true;
    }
    return false;
  }

  bool isValidInviteEmail(String email) {
    if (LoginValidation.isValidEmail(email)) {
      return true;
    }
    return false;
  }

  void postSendInvitaion(String emailParent, String studentCode,
      Function(String) onSuccess, Function(String) onError) {
    _user_api.postSendInvitaion(emailParent, studentCode, onSuccess, onError);
  }

  // UPDATE USER'S PROFILE
  StreamController _nameController = new StreamController<String>.broadcast();
  StreamController _emailController = new StreamController<String>.broadcast();
  StreamController _phoneNumberController =
      new StreamController<String>.broadcast();
  File avatar;

  Stream get nameStream => _nameController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get phoneNumberStream => _phoneNumberController.stream;

  bool isValidName(String name) {
    if (!LoginValidation.isValidSchoolId(name)) {
      _nameController.sink.addError("");
      return false;
    }
    _nameController.sink.add("");
    return true;
  }

  bool isValidEmail(String email) {
    if (!LoginValidation.isValidSchoolId(email)) {
      _emailController.sink.addError("");
      return false;
    }
    _emailController.sink.add("");
    return true;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    if (!LoginValidation.isValidSchoolId(phoneNumber)) {
      _phoneNumberController.sink.addError("");
      return false;
    }
    _phoneNumberController.sink.add("");
    return true;
  }

  void updateProfileTeacherSuccessful() {
    _updateProfileTeacherSuccess.sink.add("");
  }

  bool isValidUpdateProfile(name, email, dob, phoneNumber) {
    if (!LoginValidation.isValidSchoolId(name)) {
      return false;
    }
    if (!LoginValidation.isValidSchoolId(email)) {
      return false;
    }
    if (!LoginValidation.isValidSchoolId(dob)) {
      return false;
    }
    if (!LoginValidation.isValidSchoolId(phoneNumber)) {
      return false;
    }
    return true;
  }

  void putUpdateProfile(
      String _name,
      String _email,
      String _dob,
      String _phoneNumber,
      File _avatar,
      Function(User) onSuccess,
      Function(String) onError) async {
    var _avatarUrl = DataSingleton.instance.edUser.avatar;
    if (_avatar != null) {
      var file = await _image_api.postUploadImg(_avatar);
      _avatarUrl = file.file_url;
    }
    _user_api.putUpdateProfile(
        _name, _email, _dob, _phoneNumber, _avatarUrl, onSuccess, onError);
  }

  void updateProfileSuccessful() {
    _listStudentsController.sink.add("");
  }

  void updateListReportCategory() {
    _listReportCategoryController.sink.add("");
  }

  void updateListReport() {
    _listReportController.sink.add("");
  }

  // UPDATE STUDENT PROFILE
  StreamController _nameStudentController =
      new StreamController<String>.broadcast();
  StreamController _addressStudentController =
      new StreamController<String>.broadcast();

  Stream get nameStudentStream => _nameStudentController.stream;
  Stream get addressStudentStream => _addressStudentController.stream;

  bool isValidStudentName(String name) {
    if (!LoginValidation.isValidNull(name)) {
      _nameStudentController.sink.addError("Tên không được để trống");
      return false;
    }
    _nameStudentController.sink.add("");
    return true;
  }

  bool isValidStudentAddress(String address) {
    if (!LoginValidation.isValidNull(address)) {
      _addressStudentController.sink.addError("Địa chỉ không được để trống");
      return false;
    }
    _addressStudentController.sink.add("");
    return true;
  }

  bool isValidUpdateStudentProfile(name, dob, address) {
    if (!LoginValidation.isValidSchoolId(name)) {
      return false;
    }
    if (!LoginValidation.isValidSchoolId(dob)) {
      return false;
    }
    if (!LoginValidation.isValidSchoolId(address)) {
      return false;
    }
    return true;
  }

  Future<Student> getStudentDetail(int studentId) async {
    try {
      return await _user_api.getStudentDetail(studentId);
    } catch(error) {
      throw error;
    }
  }

  void putUpdateStudentProfile(
      String _name,
      String _dob,
      String _address,
      File _avatar,
      String _oldAvatarUrl,
      int _studentId,
      Function(Student) onSuccess,
      Function(String) onError) async {
    var _avatarUrl = _oldAvatarUrl;
    if (_avatar != null) {
      var file = await _image_api.postUploadImg(_avatar);
      _avatarUrl = file.file_url;
    }
    _user_api.putUpdateStudentProfile(
        _name, _dob, _address, _avatarUrl, _studentId, onSuccess, onError);
  }

  void getConnectParents(
      int classId, Function onSuccess, Function(String) onError) {
    _listConnectParentsController.add(LOADING);
    _user_api.getListConnectParents(classId,
        (listNotConnected, listWaiting, listConnected) {
      _listConnectParentsController.add(DONE);
      onSuccess(listNotConnected, listWaiting, listConnected);
    }, onError);
  }

  void checkingForStudent(int studentId, String image, int classroom_id,
      String status, Function(Checking) onSuccess, Function(String) onError) {
    _user_api.checkingStudent(
        studentId, image, classroom_id, status, onSuccess, onError);
  }

  Future getCheckingListHistory(int studentId, int classroom_id) async {
    try {
      _listCheckings = [];
      final result = await _user_api.getCheckingListHistory(studentId, classroom_id, false, -1);
      _listCheckings = result;
      _listCheckingController.sink.add(DONE);
    } catch (_) {
      _listCheckings = [];
      _listCheckingController.sink.add(EMPTY);
    }
  }

  Future loadMoreCheckingListHistory(int studentId, int classroom_id) async {
    try {
      final result = await _user_api.getCheckingListHistory(studentId, classroom_id, true, _listCheckings.last.checking_id);
      _listCheckings.addAll(result);
      _listCheckingController.sink.add(DONE);
    } catch (_) {
      _listCheckings.addAll([]);
      _listCheckingController.sink.add(EMPTY);
    }
  }

  void createCheckingForStudent() {
    _createCheckingController.sink.add("");
    _listCheckingController.sink.addError("");
  }

  void selectedTime() {
    _selectedTimeController.sink.add("");
  }

  void selectedReportIcon() {
    _selectedIconReportController.sink.add("");
  }

  Future<EdTechFile> uploadImage(File imageFile) async {
    var file = await _image_api.postUploadImg(imageFile);
    return file;
  }

  Future<ReportCategory> createCategoryReport(
      int classroom_id, String name, String icon, String description) async {
    return await _user_api.createCategoryReport(
        classroom_id, name, icon, description);
  }

  Future<Report> createReport(int classroom_id, int student_id, int report_type_id,
      String target, String content) async {
    return await _user_api.createReport(classroom_id, student_id, report_type_id, target, content);
  }

  Future<List<ReportCategory>> getListCategoryReport(int classroom_id, String type) async {
    return await _user_api.getListCategoryReport(classroom_id, type);
  }

  Future<ReportCategory> editReportCategory(int report_type_id, String content) async {
    return await _user_api.editReportCategory(report_type_id, content);
  }

  Future deleteReportCategory(int report_type_id) async {
    return await _user_api.deleteReportCategory(report_type_id);
  }

  Future<List<Report>> getListReport(String target, String from, String to, int classroom_id, int student_id, bool loadMore, int lastId) async {
    return await _user_api.getListReport(target, from, to, classroom_id, student_id, loadMore, lastId);
  }

  Future<Report> editReport(int report_id, String content) async {
    return await _user_api.editReport(report_id, content);
  }

  Future deleteReport(int reportId) async {
    return await _user_api.deleteReport(reportId);
  }

  Future getListStory(int student_id, String type) async {
    try {
      _listStory = await _user_api.getListStory(student_id, type);
      updateListReport();
    } catch (_) {
      _listStory = [];
      updateListReport();
    }
  }

  Future<Story> createStoryForStudent(int student_id, String type, String content) async {
    return await _user_api.createStory(student_id, type, content);
  }

  Future deleteStory(int story_id) async {
    return await _user_api.deleteStory(story_id);
  }

  Future<Story> editStory(int story_id, String content) async {
    return await _user_api.editStory(story_id, content);
  }

  Future<List<String>> getListReportIcons() async {
    final result = await _user_api.getListIconReport();
    if (result.isNotEmpty) {
      _iconReportUrl = result.first;
    } else {
      _iconReportUrl = "assets/img/avatar_default.png";
    }
    return result;
  }

  void dispose() {
    _listClassRoomController.close();
    _listStudentsController.close();
    _listTeachersController.close();
    _nameController.close();
    _emailController.close();
    _phoneNumberController.close();
    _nameStudentController.close();
    _addressStudentController.close();
    _updateProfileTeacherSuccess.close();
    _listParentsController.close();
    _listConnectParentsController.close();
    _listCheckingController.close();
    _selectedTimeController.close();
  }
}
