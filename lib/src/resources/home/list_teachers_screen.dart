import 'package:edtechteachersapp/src/resources/home/components/teacher_gridview.dart';
import 'package:edtechteachersapp/src/resources/home/components/teacher_listview.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';

class ListTeacherScreen extends StatefulWidget {
  final int classId;
  final bool isGrid;
  ListTeacherScreen({Key key, @required this.classId, this.isGrid})
      : super(key: key);

  @override
  _ListTeacherScreenState createState() => _ListTeacherScreenState();
}

class _ListTeacherScreenState extends State<ListTeacherScreen> {
  TeacherBloc teacherBloc;
  bool _loading = false;
  List<Teacher> listTeachers = [];

  @override
  void initState() {
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    if (DataSingleton.instance.listTeachers.isEmpty) {
      _getListTeachersInClass();
    } else {
      listTeachers = DataSingleton.instance.listTeachers;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  getBody() {
    return StreamBuilder(
        stream: teacherBloc.listTeachersController,
        builder: (context, snapshot) {
          if (_loading) {
            return LoadingDataView.showLoadingDataView(context, "Đang tải...");
          }
          if (listTeachers.isEmpty) {
            return NodataView.showNodataView(
                context, "Chưa có giáo viên nào trong lớp.");
          }
          return Container(
              color: EdTechColors.backgroundColor,
              child: this.widget.isGrid
                  ? TeacherGridView(listTeachers: listTeachers)
                  : TeacherListView(listTeachers: listTeachers));
        });
  }

  void _getListTeachersInClass() async {
    _loading = true;
    await teacherBloc.getListTeachersInClass(this.widget.classId);
    _loading = false;
    listTeachers = teacherBloc.listTeachers;
    DataSingleton.instance.listTeachers = listTeachers;
  }
}
