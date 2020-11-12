import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/singleton/data_singleton.dart';
import 'package:edtechteachersapp/src/global/widgets/report/index.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/rendering.dart';
import 'package:edtechteachersapp/src/global/dialogs/custom_dialog.dart'
    as customDialog;

class ListReportScreen extends StatefulWidget {
  final Student student;
  ListReportScreen({Key key, this.student}) : super(key: key);

  @override
  _ListReportScreenState createState() => _ListReportScreenState();
}

class _ListReportScreenState extends State<ListReportScreen> {
  TeacherBloc teacherBloc;
  List<String> listTime = ["Ngày", "Tuần", "Tháng", "Năm"];
  var selectedTime = 0;
  ReportCategory generalType;
  List<ReportCategory> listCategory = [];
  List<Report> listReport = [];
  List<String> listReportIcons = [];
  var selectedCategory;
  Student student;
  var category_size;
  var loadingData = true;
  var currentDate = DateTime.now();
  var fromDate = EdTechConvertData.convertServerDate(DateTime.now());
  var toDate = EdTechConvertData.convertServerDate(DateTime.now());
  var displayTime =
      EdTechConvertData.convertTimeString(DateTime.now().toString());
  TextEditingController _createCategoryController = new TextEditingController();
  TextEditingController _createReportController = new TextEditingController();
  ScrollController _scrollReportsController;

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    student = widget.student;
    getListCategory();
    getGeneralType();
    getListReport(false);
    getListReportIcons();
    _scrollReportsController = ScrollController();
    _scrollReportsController.addListener(_scrollReportsListener);
  }

  _scrollReportsListener() {
    if (_scrollReportsController.offset >=
        _scrollReportsController.position.maxScrollExtent &&
        !_scrollReportsController.position.outOfRange) {
      getListReport(true);
    }
  }

  onTapTimeCell(index) {
    currentDate = DateTime.now();
    teacherBloc.selectedTime();
    selectedTime = index;
    displayTime = getTime(selectedTime);
    getListReport(false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    category_size = (EdTechAppStyles(context).width - 32) / 4;
    return Scaffold(
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
            InkWell(
              onTap: () {
                selectedCategory = generalType;
                createReport(context, generalType);
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: EdTechColors.mainColor,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(20.0)),
                    border: new Border.all(
                      color: EdTechColors.textColor,
                      width: 0.1,
                    ),
                  ),
                  child: Text(
                    "Báo cáo chung",
                    style: TextStyle(
                        fontSize: EdTechFontSizes.small,
                        fontWeight: EdTechFontWeight.semibold,
                        color: EdTechColors.textWhiteColor),
                  )),
            )
          ],
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              student == null ? "Báo cáo" : student.name,
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
        ),
        body: getBody());
  }

  Widget getBody() {
    return Container(
      color: EdTechColors.backgroundColor,
      child: CustomScrollView(
        controller: _scrollReportsController,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
                [SizedBox(height: 10.0), _buildListAction(),],
            ),
          ),
          makeHeader(110.0, 110.0, _buildListReportHeader()),
          _buildListReport()
        ],
      ),
    );
  }

  Widget _buildListAction() {
    return StreamBuilder(
      stream: teacherBloc.listReportCategoryController,
      builder: (context, snapshot) => Container(
        child: GridView.builder(
            // scrollDirection: Axis.horizontal,
            
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 0.9),
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listCategory.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == listCategory.length) {
                return InkWell(
                    onTap: () {
                      createCategoryReport(context);
                    },
                    child: ReportActionWidget(
                        size: category_size,
                        icon: Icon(Icons.add,
                            size: 45, color: EdTechColors.mainColor),
                        name: "Thêm báo cáo"));
              } else {
                final category = listCategory[index];
                return InkWell(
                    onTap: () {
                      selectedCategory = category;
                      createReport(context, category);
                    },
                    onLongPress: () {
                      settingModalBottomSheetForReportType(context, category);
                    },
                    child: ReportActionWidget(
                        size: category_size,
                        iconLink: category.icon,
                        name: category.name));
              }
            }),
      ),
    );
  }

  Widget _buildListReportHeader() {
    return StreamBuilder(
      stream: teacherBloc.selectedTimeController,
      builder: (BuildContext context, snapShot) => 
      Container(
        padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
        color: EdTechColors.backgroundColor, 
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Báo cáo",
                style: TextStyle(
                    color: EdTechColors.textBlackColor,
                    fontWeight: EdTechFontWeight.semibold,
                    fontSize: EdTechFontSizes.medium),
              ),
              SizedBox(
                width: 8,
              ),
              StreamBuilder(
                  stream: teacherBloc.listReportController,
                  builder: (context, snapshot) => loadingData
                      ? edTechLoaderWidget(10.0, 10.0)
                      : Container())
            ],
          ),
          SizedBox(
            height: 8,
          ),
          _buildTimeRow(),
          SizedBox(
            height: 8,
          ),
          _buildDateRow(),
          SizedBox(
            height: 8,
          ),
        ],
      )),
    );
  }

  Widget _buildTimeRow() {
    return Row(
      children: [
        _buildTimeCell(0),
        SizedBox(
          width: 10,
        ),
        _buildTimeCell(1),
        SizedBox(
          width: 10,
        ),
        _buildTimeCell(2),
        SizedBox(
          width: 10,
        ),
        _buildTimeCell(3),
      ],
    );
  }

  Widget _buildTimeCell(index) {
    return InkWell(
        onTap: () {
          onTapTimeCell(index);
        },
        child: Container(
            height: 27,
            width: (EdTechAppStyles(context).width - 65) / 4,
            alignment: Alignment.center,
            child: Text(
              listTime[index],
              style: TextStyle(
                  color: selectedTime == index
                      ? EdTechColors.textWhiteColor
                      : EdTechColors.timeColor,
                  fontWeight: EdTechFontWeight.semibold,
                  fontSize: EdTechFontSizes.small),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27.0),
                color: selectedTime == index
                    ? EdTechColors.mainColor
                    : EdTechColors.dividerColor.withOpacity(0.5))));
  }

  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            switch (selectedTime) {
              case 0:
                {
                  currentDate = DateTime(
                      currentDate.year, currentDate.month, currentDate.day - 1);
                }
                break;
              case 1:
                {
                  currentDate = DateTime(
                      currentDate.year, currentDate.month, currentDate.day - 7);
                }
                break;
              case 2:
                {
                  currentDate =
                      DateTime(currentDate.year, currentDate.month - 1, 1);
                }
                break;
              case 3:
                {
                  currentDate = DateTime(currentDate.year - 1, 1, 1);
                }
                break;
            }
            teacherBloc.selectedTime();
            displayTime = getTime(selectedTime);
            getListReport(false);
          },
          child: Container(
              width: 25,
              height: 25,
              color: Colors.transparent,
              child: Icon(Icons.keyboard_arrow_left)),
        ),
        Text(
          displayTime,
          style: TextStyle(
              color: EdTechColors.textBlackColor,
              fontWeight: EdTechFontWeight.semibold,
              fontSize: EdTechFontSizes.simple),
        ),
        InkWell(
          onTap: () {
            switch (selectedTime) {
              case 0:
                {
                  currentDate = DateTime(
                      currentDate.year, currentDate.month, currentDate.day + 1);
                }
                break;
              case 1:
                {
                  currentDate = DateTime(
                      currentDate.year, currentDate.month, currentDate.day + 7);
                }
                break;
              case 2:
                {
                  currentDate =
                      DateTime(currentDate.year, currentDate.month + 1, 1);
                }
                break;
              case 3:
                {
                  currentDate = DateTime(currentDate.year + 1, 1, 1);
                }
                break;
            }
            teacherBloc.selectedTime();
            displayTime = getTime(selectedTime);
            getListReport(false);
          },
          child: Container(
              width: 25,
              height: 25,
              color: Colors.transparent,
              child: Icon(Icons.keyboard_arrow_right)),
        )
      ],
    );
  }

  Widget _buildListReport() {
    return StreamBuilder(
      stream: teacherBloc.listReportController,
      builder: (context, snapshot) => listReport.isEmpty
        ? SliverList(
          delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
                return NodataView.showNodataView(context, "Chưa có báo cáo");
            }, childCount: 1))
        : SliverList(
        delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
              final report = listReport[index];
              return _buildReport(report);
          }, childCount: listReport.length))
    );
  }




  Widget _buildReport(Report report) {
    return InkWell(
      onTap: () { settingModalBottomSheet(context, report); },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 41,
                height: 41,
                alignment: Alignment.centerLeft,
                child: new CircleAvatar(
                  backgroundColor: Colors.brown,
                  backgroundImage: NetworkImage(
                    report.report_type.icon,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.report_type.name,
                        style: new TextStyle(
                            fontSize: EdTechFontSizes.normal,
                            fontWeight: EdTechFontWeight.bold,
                            color: EdTechColors.textBlackColor)),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(report.content,
                        style: new TextStyle(
                            fontSize: EdTechFontSizes.normal,
                            fontWeight: EdTechFontWeight.normal,
                            color: EdTechColors.textBlackColor)),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Thêm bởi ${report.reporter.name}',
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                fontSize: EdTechFontSizes.small,
                                fontWeight: EdTechFontWeight.normal,
                                color: EdTechColors.timeColor)),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                            EdTechConvertData.convertTimeString(
                                report.created_at),
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                fontSize: EdTechFontSizes.small,
                                fontWeight: EdTechFontWeight.normal,
                                color: EdTechColors.timeColor)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  void settingModalBottomSheetForReportType(BuildContext context, ReportCategory type) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.edit,
                        color: EdTechColors.textBlackColor,
                        size: EdTechIconSizes.normal),
                    title: new Text("Sửa loại báo cáo"),
                    onTap: () => editReportCategory(type)),
                new ListTile(
                  leading: new Icon(Icons.delete,
                      color: EdTechColors.textBlackColor,
                      size: EdTechIconSizes.normal),
                  title: new Text('Xoá loại báo cáo'),
                  onTap: () => deleteReportCategory(type),
                ),
              ],
            ),
          );
        });
  }

  void editReportCategory(ReportCategory type) {
    _createCategoryController.text = type.name;
    teacherBloc.setIconReportUrl(type.icon);
    Widget createCategoryDialog = customDialog.Dialog(
        child: AddCategoryReportWidget(
          action: () {
            editReportCategoryAction(type.report_type_id);
          },
          editingController: _createCategoryController,
          listIcons: listReportIcons,
          teacherBloc: teacherBloc,
          isEditting: true,
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) => createCategoryDialog);
  }

  void deleteReportCategory(ReportCategory type) {
    ActionDialog.showActionDialog(context, "Chú ý!",
        "Xoá mục này sẽ xóa toàn bộ các báo cáo liên quan, bạn có chắc chắn muốn xóa loại báo cáo này không?", "Huỷ", "Xoá", () { deleteReportCategoryAction(type.report_type_id); });
  }

  void editReportCategoryAction(int report_type_id) async {
    try {
      ReportCategory _ = await teacherBloc.editReportCategory(report_type_id, _createCategoryController.text);
      Navigator.pop(context);
      Navigator.pop(context);
      for (var i = 0; i < listCategory.length; i++) {
        if(listCategory[i].report_type_id == report_type_id) {
          listCategory[i].name =  _createCategoryController.text.trim();
          break;
        }
      }
      teacherBloc.updateListReportCategory();
      _createCategoryController.clear();
      ToastMessage.showToastMessage(context, "Sửa thành công");
    } catch (message) {
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, message);
    }
  }

  void deleteReportCategoryAction(int report_type_id) async {
    try {
      teacherBloc.deleteReportCategory(report_type_id);
      for (var i = 0; i < listCategory.length; i++) {
        if(listCategory[i].report_type_id == report_type_id) {
          listCategory.removeAt(i);
          break;
        }
      }
      teacherBloc.updateListReportCategory();
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, "Xoá thành công");
    } catch(message) {
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, message);
    }
  }

  void settingModalBottomSheet(BuildContext context, Report report) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.edit,
                        color: EdTechColors.textBlackColor,
                        size: EdTechIconSizes.normal),
                    title: new Text("Sửa báo cáo"),
                    onTap: () => editReport(report)),
                new ListTile(
                  leading: new Icon(Icons.delete,
                      color: EdTechColors.textBlackColor,
                      size: EdTechIconSizes.normal),
                  title: new Text('Xoá báo cáo'),
                  onTap: () => deleteReport(report),
                ),
              ],
            ),
          );
        });
  }

  void editReport(Report report) {
    _createReportController.text = report.content;
    Widget createReportDialog = customDialog.Dialog(
        child: CreateReportWidget(
            category: report.report_type,
            action: () {editReportAction(report.report_id);},
            editingController: _createReportController,
            isEditting: true));
    showDialog(
        context: context,
        builder: (BuildContext context) => createReportDialog);
  }

  void deleteReport(Report report) {
    ActionDialog.showActionDialog(context, "Chú ý!",
        "Bạn có muốn xoá báo cáo này không?", "Huỷ", "Xoá", () { deleteReportAction(report.report_id); });
  }

  void editReportAction(int report_id) async {
    try {
      Report _ = await teacherBloc.editReport(report_id, _createReportController.text);
      Navigator.pop(context);
      Navigator.pop(context);
      for (var i = 0; i < listReport.length; i++) {
        if(listReport[i].report_id == report_id) {
          listReport[i].content =  _createReportController.text;
          break;
        }
      }
      teacherBloc.updateListReport();
      _createReportController.clear();
      ToastMessage.showToastMessage(context, "Sửa thành công");
    } catch (message) {
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, message);
    }
  }

  void deleteReportAction(int report_id) async {
    try {
      teacherBloc.deleteReport(report_id);
      for (var i = 0; i < listReport.length; i++) {
        if(listReport[i].report_id == report_id) {
          listReport.removeAt(i);
          break;
        }
      }
      teacherBloc.updateListReport();
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, "Xoá thành công");
    } catch(message) {
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, message);
    }
  }

  void createCategoryReport(context) {
    _createCategoryController.clear();
    if (listReportIcons.isNotEmpty) {
      teacherBloc.setIconReportUrl(listReportIcons.first);
    } else {
      teacherBloc.setIconReportUrl("assets/img/avatar_default.png");
    }
    Widget createCategoryDialog = customDialog.Dialog(
        child: AddCategoryReportWidget(
          action: createCategoryAction,
          editingController: _createCategoryController,
          listIcons: listReportIcons,
          teacherBloc: teacherBloc,
          isEditting: false,
    ));
    showDialog(
        context: context,
        builder: (BuildContext context) => createCategoryDialog);
  }

  void createReport(context, category) {
    _createReportController.clear();
    Widget createReportDialog = customDialog.Dialog(
        child: CreateReportWidget(
            category: category,
            action: createReportAction,
            editingController: _createReportController,
            isEditting: false));
    showDialog(
        context: context,
        builder: (BuildContext context) => createReportDialog);
  }

  void getListCategory() async {
    try {
      var result = await teacherBloc.getListCategoryReport(
          DataSingleton.instance.classSelected.classroom_id, "");
      listCategory.addAll(result);
      teacherBloc.updateListReportCategory();
    } catch (message) {
      listCategory.addAll([]);
      teacherBloc.updateListReportCategory();
    }
  }

  void getGeneralType() async {
    try {
      var result = await teacherBloc.getListCategoryReport(
          DataSingleton.instance.classSelected.classroom_id, "general");
      generalType = result.isNotEmpty ? result.first : null;
    } catch (message) {
      generalType = null;
    }
  }

  void createCategoryAction() async {
    try {
      ReportCategory category = await teacherBloc.createCategoryReport(
          DataSingleton.instance.classSelected.classroom_id,
          _createCategoryController.text.trim(),
          teacherBloc.iconReportUrl,
          "");
      _createCategoryController.clear();
      Navigator.pop(context);
      listCategory.add(category);
      teacherBloc.updateListReportCategory();
    } catch (message) {
      ToastMessage.showToastMessage(context, message);
    }
  }

  void createReportAction() async {
    try {
      var student_id = -1;
      var target = CLASS_ROOM;
      if (student != null) {
        student_id = student.student_id;
        target = STUDENT;
      } else {
        student_id = -1;
        target = CLASS_ROOM;
      }
      await teacherBloc.createReport(
          DataSingleton.instance.classSelected.classroom_id,
          student_id,
          selectedCategory.report_type_id,
          target,
          _createReportController.text.trim());
      _createReportController.clear();
      Navigator.pop(context);
      onTapTimeCell(selectedTime);
      // listReport.insert(0, report);
      teacherBloc.updateListReport();
    } catch (message) {
      ToastMessage.showToastMessage(context, message);
    }
  }

  void getListReport(bool loadMore) async {
    var student_id = -1;
    var target = CLASS_ROOM;
    if (student != null) {
      student_id = student.student_id;
      target = STUDENT;
    } else {
      student_id = -1;
      target = CLASS_ROOM;
    }
    if(loadMore) {
      try {
        var result = await teacherBloc.getListReport(target, fromDate, toDate,
            DataSingleton.instance.classSelected.classroom_id, student_id, true, listReport.last.report_id);
        listReport.addAll(result);
        teacherBloc.updateListReport();
      } catch (message) {
        teacherBloc.updateListReport();
      }
    } else {
      try {
        loadingData = true;
        var result = await teacherBloc.getListReport(target, fromDate, toDate,
            DataSingleton.instance.classSelected.classroom_id, student_id, false, -1);
        listReport = result;
        loadingData = false;
        teacherBloc.updateListReport();
      } catch (message) {
        listReport = [];
        loadingData = false;
        teacherBloc.updateListReport();
      }
    }
  }

  void getListReportIcons() async {
    try {
      var result = await teacherBloc.getListReportIcons();
      listReportIcons = result;
    } catch (message) {
      listReportIcons = [];
    }
  }

  String getTime(index) {
    switch (index) {
      case 0:
        fromDate = EdTechConvertData.convertServerDate(currentDate);
        toDate = EdTechConvertData.convertServerDate(currentDate);
        return EdTechConvertData.convertTimeString(currentDate.toString());
      case 1:
        fromDate = EdTechConvertData.startOfWeekServer(currentDate);
        toDate = EdTechConvertData.endOfWeekServer(currentDate);
        return "${EdTechConvertData.startOfWeek(currentDate)} - ${EdTechConvertData.endOfWeek(currentDate)}";
      case 2:
        fromDate = EdTechConvertData.getStartOfMonthServer(currentDate);
        toDate = EdTechConvertData.getEndOfMonthServer(currentDate);
        return EdTechConvertData.getMonth(currentDate);
      case 3:
        fromDate = EdTechConvertData.getStartOfYear(currentDate);
        toDate = EdTechConvertData.getEndOfYear(currentDate);
        return EdTechConvertData.getYear(currentDate);
      default:
        return "";
    }
  }
}
