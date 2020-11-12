import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/resources/student/components/student_gridview.dart';
import 'package:edtechteachersapp/src/resources/student/components/student_listview.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';

class ListStudentScreen extends StatefulWidget {
  final int classId;
  final bool isGrid;
  ListStudentScreen({Key key, @required this.classId, this.isGrid})
      : super(key: key);

  @override
  _ListStudentScreenState createState() => _ListStudentScreenState();
}

class _ListStudentScreenState extends State<ListStudentScreen> {
  TeacherBloc teacherBloc;
  bool _loading = false;
  List<Student> listStudents = [];

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    if (DataSingleton.instance.listStudents.isEmpty) {
      _getListStudentInClass();
    } else {
      listStudents = DataSingleton.instance.listStudents;
    }
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  getBody() {
    return StreamBuilder(
        stream: teacherBloc.listStudentsController,
        builder: (context, snapshot) {
          if (_loading) {
            return LoadingDataView.showLoadingDataView(context, "Đang tải...");
          }
          if (listStudents.isEmpty) {
            return NodataView.showNodataView(
                context, "Chưa có học sinh nào trong lớp.");
          }
          return Container(
              color: EdTechColors.backgroundColor,
              child: this.widget.isGrid
                  ? StudentGridView(listStudents: listStudents)
                  : StudentListView(listStudents: listStudents));
        });
  }

  // getBody() {
  //   return StreamBuilder(
  //       stream: teacherBloc.listStudentsController,
  //       builder: (context, snapshot) {
  //         if (snapshot.data == EMPTY) {
  //           return NodataView.showNodataView(
  //               context, "Chưa có học sinh nào trong lớp.");
  //         }
  //         if (snapshot.data == DONE) {
  //           return Container(
  //               color: EdTechColors.backgroundColor,
  //               child: this.widget.isGrid
  //                   ? StudentGridView(listStudents: listStudents)
  //                   : StudentListView(listStudents: listStudents));
  //         }
  //         return LoadingDataView.showLoadingDataView(context, "Đang tải...");
  //       });
  // }

  void _getListStudentInClass() async {
    _loading = true;
    await teacherBloc.getListStudentsInClass(this.widget.classId);
    _loading = false;
    listStudents = teacherBloc.listStudents;
    DataSingleton.instance.listStudents = listStudents;
  }
}
