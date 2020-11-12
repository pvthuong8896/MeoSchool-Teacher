import 'dart:core';
import 'package:edtechteachersapp/src/models/index.dart';

class DataSingleton {
  static final DataSingleton instance = DataSingleton();

  User edUser;
  int numberOfNoti = 0;
  List<ClassRoom> listClassroom = [];
  ClassRoom classSelected;
  List<Student> listStudents = [];
  List<Teacher> listTeachers = [];
  List<Parents> listParents = [];

  List<Student> checkListStudentSelected() {
    List<Student> selecteds = [];
    for(var i = 0; i < listStudents.length; i++) {
      if (listStudents[i].isSelected) {
        selecteds.add(listStudents[i]);
      }
    }
    return selecteds;
  }

  removeSelected() {
    for(var i = 0; i < listStudents.length; i++) {
      listStudents[i].isSelected = false;
    }
  }

  backToHome() {
    classSelected = null;
    listStudents = [];
    listTeachers = [];
    listParents = [];
  }

  logout() {
    edUser = null;
    classSelected = null;
    listStudents = [];
    listClassroom = [];
    listTeachers = [];
    listParents = [];
  }
}
