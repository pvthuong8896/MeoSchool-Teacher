import 'package:edtechteachersapp/src/blocs/index.dart';
import 'package:edtechteachersapp/src/global/dialogs/index.dart';
import 'package:edtechteachersapp/src/global/widgets/story/create_story_widget.dart';
import 'package:edtechteachersapp/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:edtechteachersapp/src/global/configs/index.dart';
import 'package:flutter/rendering.dart';
import 'package:edtechteachersapp/src/global/dialogs/custom_dialog.dart'
    as customDialog;

class StoryStudentScreen extends StatefulWidget {
  final Student student;
  StoryStudentScreen({Key key, this.student}) : super(key: key);

  @override
  _StoryStudentScreenState createState() => _StoryStudentScreenState();
}

class _StoryStudentScreenState extends State<StoryStudentScreen> {
  TeacherBloc teacherBloc;
  List<String> listAction = ["Chung", "Sức khoẻ", "Học tập"];
  var selectedAction = 0;
  var loadingData = true;
  TextEditingController _createStoryController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    getListReport();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // InkWell(
            //   onTap: () {
            //     createStoryDialog(context);
            //   },
            //   child: Container(
            //       padding: EdgeInsets.symmetric(horizontal: 10),
            //       margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            //       alignment: Alignment.center,
            //       decoration: new BoxDecoration(
            //         color: EdTechColors.mainColor,
            //         borderRadius:
            //             new BorderRadius.all(new Radius.circular(20.0)),
            //         border: new Border.all(
            //           color: EdTechColors.textColor,
            //           width: 0.1,
            //         ),
            //       ),
            //       child: Text(
            //         "Thêm tiểu sử",
            //         style: TextStyle(
            //             fontSize: EdTechFontSizes.small,
            //             fontWeight: EdTechFontWeight.semibold,
            //             color: EdTechColors.textWhiteColor),
            //       )),
            // )
          ],
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Tiểu sử",
              style: TextStyle(
                  fontWeight: EdTechFontWeight.semibold,
                  color: EdTechColors.textBlackColor,
                  fontSize: EdTechFontSizes.medium),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
                onPressed: () {
                  createStoryDialog(context);
                },
                child: Icon(Icons.add),
                backgroundColor: EdTechColors.mainColor,
              ),
        body: getBody());
  }

  Widget getBody() {
    return Container(
      color: EdTechColors.backgroundColor,
      child: StreamBuilder(
        stream: teacherBloc.selectedTimeController,
        builder: (BuildContext context, snapShot) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
              children: [
                Text(
                  widget.student.name,
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
            )),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildActionRow(),),
            Expanded(
              child: _buildListStory(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        _buildActionCell(0),
        SizedBox(
          width: 10,
        ),
        _buildActionCell(1),
        SizedBox(
          width: 10,
        ),
        _buildActionCell(2),
      ],
    );
  }

  Widget _buildActionCell(index) {
    return InkWell(
        onTap: () {
          teacherBloc.selectedTime();
          selectedAction = index;
          getListReport();
        },
        child: Container(
            height: 27,
            width: (EdTechAppStyles(context).width - 52) / 3,
            alignment: Alignment.center,
            child: Text(
              listAction[index],
              style: TextStyle(
                  color: selectedAction == index
                      ? EdTechColors.textWhiteColor
                      : EdTechColors.timeColor,
                  fontWeight: EdTechFontWeight.semibold,
                  fontSize: EdTechFontSizes.small),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27.0),
                color: selectedAction == index
                    ? EdTechColors.mainColor
                    : EdTechColors.dividerColor.withOpacity(0.5))));
  }

  Widget _buildListStory() {
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      child: StreamBuilder(
      stream: teacherBloc.listReportController,
      builder: (context, snapshot) => teacherBloc.listStory.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: teacherBloc.listStory.length,
              itemBuilder: (BuildContext context, int index) {
                final story = teacherBloc.listStory[index];
                return _buildStory(story);
              })
          : NodataView.showNodataView(context, "Chưa có tiểu sử"),
    ));
  }

  Widget _buildStory(Story story) {
    return InkWell(
      onTap: () => settingModalBottomSheet(context, story),
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(top: 5.0),
                decoration: new BoxDecoration(
                  color: EdTechColors.mainColor,
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(story.content,
                        style: new TextStyle(
                            fontSize: EdTechFontSizes.normal,
                            fontWeight: EdTechFontWeight.semibold,
                            color: EdTechColors.textBlackColor)),
                    SizedBox(
                      height: 2,
                    ),
                    Text('Thêm bởi ${story.creator.name}',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontSize: EdTechFontSizes.small,
                            fontWeight: EdTechFontWeight.normal,
                            color: EdTechColors.timeColor)),
                  ],
                ),
              )
            ],
          )),
    );
  }

  void editStory(Story story) {
    _createStoryController.text = story.content;
    var index = 0;
    switch (story.type) {
      case GENERAL: { index = 0; } break;
      case HEALTH: { index = 1; } break;
      case STUDY: { index = 2; } break;
      default: { index = 0; } break;
    }
    teacherBloc.setstoryActionSelected(listAction[index]);
    Widget createStoryDialog = customDialog.Dialog(
        child: CreateStoryWidget(
          teacherBloc: teacherBloc,
          listAction: [],
          actionFunc: () {editStoryAction(story.id);},
          editingController: _createStoryController,
          isEditing: true,
        ));
    showDialog(
        context: context, builder: (BuildContext context) => createStoryDialog);
  }

  void deleteStory(Story story) {
    ActionDialog.showActionDialog(context, "Chú ý!",
        "Bạn có muốn xoá tiểu sử này không?", "Huỷ", "Xoá", () { deleteStoryAction(story.id); });
  }

  void deleteStoryAction(int story_id) async {
    try {
      teacherBloc.deleteStory(story_id);
      getListReport();
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, "Xoá thành công");
    } catch(message) {
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, message);
    }
  }

  void editStoryAction(int story_id) async {
    try {
      Story _ = await teacherBloc.editStory( story_id, _createStoryController.text);
      _createStoryController.clear();
      Navigator.pop(context);
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, "Sửa thành công");
      getListReport();
    } catch (message) {
      Navigator.pop(context);
      ToastMessage.showToastMessage(context, message);
    }
  }

  void settingModalBottomSheet(BuildContext context, Story story) {
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
                    title: new Text("Sửa tiểu sử"),
                    onTap: () => editStory(story)),
                new ListTile(
                  leading: new Icon(Icons.delete,
                      color: EdTechColors.textBlackColor,
                      size: EdTechIconSizes.normal),
                  title: new Text('Xoá tiểu sử'),
                  onTap: () => deleteStory(story),
                ),
              ],
            ),
          );
        });
  }

  void createStoryDialog(context) {
    _createStoryController.clear();
    teacherBloc.setstoryActionSelected(listAction[selectedAction]);
    Widget createStoryDialog = customDialog.Dialog(
        child: CreateStoryWidget(
          teacherBloc: teacherBloc,
          listAction: listAction,
          actionFunc: createStoryAction,
          editingController: _createStoryController,
          isEditing: false,
    ));
    showDialog(
        context: context, builder: (BuildContext context) => createStoryDialog);
  }

  void createStoryAction() async {
    print('The List result = ' + teacherBloc.storyActionSelected);
    try {
      var type = GENERAL;
      var index = 0;
      switch (teacherBloc.storyActionSelected) {
        case "Chung": { type = GENERAL; index = 0; } break;
        case "Sức khoẻ": { type = HEALTH; index = 1; } break;
        case "Học tập": { type = STUDY; index = 2; } break;
        default: { type = GENERAL; } break;
      }
      Story _ = await teacherBloc.createStoryForStudent(
          this.widget.student.student_id, type, _createStoryController.text);
      _createStoryController.clear();
      Navigator.pop(context);
      selectedAction = index;
      teacherBloc.selectedTime();
      getListReport();
    } catch (message) {
      ToastMessage.showToastMessage(context, message);
    }
  }

  void getListReport() async {
    try {
      var type = GENERAL;
      switch (selectedAction) {
        case 0: { type = GENERAL; } break;
        case 1: { type = HEALTH; } break;
        case 2: { type = STUDY; } break;
        default: { type = GENERAL; } break;
      }
      loadingData = true;
      await teacherBloc.getListStory(widget.student.student_id, type);
      loadingData = false;
    } catch (message) {
      loadingData = false;
    }
  }
}
